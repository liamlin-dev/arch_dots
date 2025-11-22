local wezterm = require("wezterm")

local platform = require("utils.platform")()

local M = {}

-- GPU information structure
M.GpuInfo = {
	has_discrete_gpu = false,
	has_integrated_gpu = false,
	DiscreteGpus = {},
	IntegratedGpus = {},
	Others = {},
}

-- Cached GPU selection
local cached_gpu = nil

-- Get preferred backend based on platform
local function get_preferred_backend()
	if platform.is_linux then
		return "Vulkan"
	elseif platform.is_win then
		return "Dx12"
	elseif platform.is_mac then
		return "Metal"
	end
	return nil
end

-- Get fallback backends for each platform
local function get_fallback_backends()
	if platform.is_linux then
		return { "Vulkan", "OpenGL" }
	elseif platform.is_win then
		return { "Dx12", "Vulkan", "OpenGL" }
	elseif platform.is_mac then
		return { "Metal" }
	end
	return {}
end

-- Unified function to find best GPU with specific backend
local function find_gpu_with_backend(gpu_list, backend)
	if not gpu_list or #gpu_list == 0 then
		return nil
	end

	for _, gpu in ipairs(gpu_list) do
		if gpu.backend == backend then
			return gpu
		end
	end
	return nil
end

-- Find the best GPU adapter based on platform and backend preferences
local function find_best_gpu(GpuInfo, preferred_backend)
	if not preferred_backend then
		return nil
	end

	-- Try discrete GPU first (better performance)
	if GpuInfo.has_discrete_gpu then
		local gpu = find_gpu_with_backend(GpuInfo.DiscreteGpus, preferred_backend)
		if gpu then
			wezterm.log_info(
				string.format("Selected discrete GPU: %s (backend: %s)", gpu.name or "Unknown", gpu.backend)
			)
			return gpu
		end
	end

	-- Fallback to integrated GPU
	if GpuInfo.has_integrated_gpu then
		local gpu = find_gpu_with_backend(GpuInfo.IntegratedGpus, preferred_backend)
		if gpu then
			wezterm.log_info(
				string.format("Selected integrated GPU: %s (backend: %s)", gpu.name or "Unknown", gpu.backend)
			)
			return gpu
		end
	end

	return nil
end

-- Try fallback backends if preferred backend is not available
local function find_fallback_gpu(GpuInfo)
	local fallback_backends = get_fallback_backends()

	for _, backend in ipairs(fallback_backends) do
		local gpu = find_best_gpu(GpuInfo, backend)
		if gpu then
			wezterm.log_warn(
				string.format(
					"Using fallback backend: %s (GPU: %s)",
					backend,
					gpu.name or "Unknown"
				)
			)
			return gpu
		end
	end

	return nil
end

-- Select any available GPU as last resort
local function select_any_gpu(GpuInfo)
	-- Try discrete first
	if GpuInfo.has_discrete_gpu and #GpuInfo.DiscreteGpus > 0 then
		local gpu = GpuInfo.DiscreteGpus[1]
		wezterm.log_warn(
			string.format(
				"Using first available discrete GPU: %s (backend: %s)",
				gpu.name or "Unknown",
				gpu.backend
			)
		)
		return gpu
	end

	-- Then integrated
	if GpuInfo.has_integrated_gpu and #GpuInfo.IntegratedGpus > 0 then
		local gpu = GpuInfo.IntegratedGpus[1]
		wezterm.log_warn(
			string.format(
				"Using first available integrated GPU: %s (backend: %s)",
				gpu.name or "Unknown",
				gpu.backend
			)
		)
		return gpu
	end

	-- Finally, any other GPU
	if #GpuInfo.Others > 0 then
		local gpu = GpuInfo.Others[1]
		wezterm.log_warn(
			string.format("Using other GPU type: %s (backend: %s)", gpu.name or "Unknown", gpu.backend)
		)
		return gpu
	end

	return nil
end

-- Log detailed GPU information for debugging
local function log_gpu_info(GpuInfo)
	wezterm.log_info("=== GPU Information ===")
	wezterm.log_info(string.format("Platform: %s", platform.os))
	wezterm.log_info(string.format("Discrete GPUs found: %d", #GpuInfo.DiscreteGpus))
	wezterm.log_info(string.format("Integrated GPUs found: %d", #GpuInfo.IntegratedGpus))
	wezterm.log_info(string.format("Other GPUs found: %d", #GpuInfo.Others))

	-- Log discrete GPUs
	for i, gpu in ipairs(GpuInfo.DiscreteGpus) do
		wezterm.log_info(
			string.format("  Discrete GPU #%d: %s (backend: %s)", i, gpu.name or "Unknown", gpu.backend)
		)
	end

	-- Log integrated GPUs
	for i, gpu in ipairs(GpuInfo.IntegratedGpus) do
		wezterm.log_info(
			string.format("  Integrated GPU #%d: %s (backend: %s)", i, gpu.name or "Unknown", gpu.backend)
		)
	end

	-- Log other GPUs
	for i, gpu in ipairs(GpuInfo.Others) do
		wezterm.log_info(string.format("  Other GPU #%d: %s (backend: %s)", i, gpu.name or "Unknown", gpu.backend))
	end
end

-- Main function to pick the best GPU
M.pick_gpu = function()
	-- Return cached GPU if available
	if cached_gpu then
		wezterm.log_info("Using cached GPU selection")
		return cached_gpu
	end

	-- Enumerate available GPUs
	local adapters = wezterm.gui.enumerate_gpus()

	-- Error handling: no GPUs found
	if not adapters or #adapters == 0 then
		wezterm.log_error("No GPU adapters found! WezTerm will use default rendering.")
		return nil
	end

	wezterm.log_info(string.format("Found %d GPU adapter(s)", #adapters))

	-- Categorize GPUs by type
	for _, gpu in ipairs(adapters) do
		if gpu.device_type == "DiscreteGpu" then
			M.GpuInfo.has_discrete_gpu = true
			table.insert(M.GpuInfo.DiscreteGpus, gpu)
		elseif gpu.device_type == "IntegratedGpu" then
			M.GpuInfo.has_integrated_gpu = true
			table.insert(M.GpuInfo.IntegratedGpus, gpu)
		else
			table.insert(M.GpuInfo.Others, gpu)
		end
	end

	-- Log detailed GPU information
	log_gpu_info(M.GpuInfo)

	-- Get preferred backend for current platform
	local preferred_backend = get_preferred_backend()
	if not preferred_backend then
		wezterm.log_error("Unknown platform, cannot determine preferred GPU backend")
		return adapters[1]
	end

	wezterm.log_info(string.format("Preferred backend for %s: %s", platform.os, preferred_backend))

	-- Try to find GPU with preferred backend
	local selected_gpu = find_best_gpu(M.GpuInfo, preferred_backend)

	-- If not found, try fallback backends
	if not selected_gpu then
		wezterm.log_warn(string.format("No GPU found with preferred backend: %s", preferred_backend))
		selected_gpu = find_fallback_gpu(M.GpuInfo)
	end

	-- If still not found, select any available GPU
	if not selected_gpu then
		wezterm.log_warn("No GPU found with any preferred backend, selecting first available")
		selected_gpu = select_any_gpu(M.GpuInfo)
	end

	-- Final fallback: use first adapter
	if not selected_gpu then
		wezterm.log_error("Could not select any GPU, using first adapter as last resort")
		selected_gpu = adapters[1]
	end

	-- Cache the selected GPU
	cached_gpu = selected_gpu

	wezterm.log_info("=== GPU Selection Complete ===")
	return selected_gpu
end

-- Utility function to clear cache (useful for debugging/testing)
M.clear_cache = function()
	cached_gpu = nil
	M.GpuInfo = {
		has_discrete_gpu = false,
		has_integrated_gpu = false,
		DiscreteGpus = {},
		IntegratedGpus = {},
		Others = {},
	}
	wezterm.log_info("GPU cache cleared")
end

-- Utility function to get GPU info without selecting
M.get_gpu_info = function()
	return M.GpuInfo
end

return M
