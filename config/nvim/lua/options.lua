-- Neovim Options

local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = false

-- Clipboard
vim.g.clipboard = "osc52" -- support remote copy
opt.clipboard = "unnamedplus"

-- UI
opt.number = true -- 顯示行號
opt.relativenumber = true -- 使用相對行號
opt.cursorline = true -- 高亮當前行
opt.termguicolors = true -- 啟用真彩色
opt.signcolumn = "yes" -- 總是顯示左側符號欄
opt.laststatus = 3 -- 全局狀態列
opt.showmode = false -- 不在下方顯示 mode
opt.scrolloff = 10 -- 游標上下保留 n 行緩衝
opt.sidescrolloff = 10 -- 游標左右保留 n 字元緩衝
opt.mouse = "a" -- 啟用滑鼠控制
opt.showmatch = true -- 高亮括弧匹配

-- Split
opt.splitbelow = true -- 新視窗開在下方
opt.splitright = true -- 新視窗開在右方
opt.splitkeep = "screen" -- 分割時保持文字位置穩定

-- Pop Menu
opt.pumblend = 10 -- 選單透明度
opt.pumheight = 10 -- 選單最大高度
opt.winblend = 0 -- 浮動窗口透明

-- Indentation
opt.autoindent = true -- 自動縮進
opt.smartindent = true -- 智慧縮排
opt.expandtab = true -- Tab 轉空格
opt.shiftwidth = 2 -- 縮排寬度
opt.tabstop = 2 -- Tab 代表的寬度
opt.shiftround = true -- 縮排時對齊 shiftwidth 的倍數
opt.wrap = false -- 不自動換行

-- Search
opt.ignorecase = true -- 搜尋忽略大小寫
opt.smartcase = true -- 但若輸入大寫則區分大小寫
opt.hlsearch = true -- 搜尋匹配高亮
opt.incsearch = true -- 顯示匹配數量

-- General
opt.confirm = true -- 退出前若有未存檔，跳出確認視窗
opt.swapfile = false -- 不要使用 swap file
opt.autowrite = true -- 自動存檔 (切換 buffer 或編譯時)
opt.autoread = true -- 自動讀取 (外部修改時)
opt.undofile = true -- 保留 Undo 紀錄 (即便重開編輯器)
opt.undolevels = 10000 -- 增加 Undo 記憶量
opt.updatetime = 200 -- 加快更新頻率 (影響 CursorHold 事件，對外掛很重要)
opt.virtualedit = "block" -- Visual Block 模式下可讓游標移動到無字元處
opt.iskeyword:append("-") -- 把 '-' 當成一個字不要當成兩個字
opt.errorbells = false -- 錯誤聲音
opt.updatetime = 300 -- 補全加速
opt.timeoutlen = 500 -- 超時時間
opt.ttimeoutlen = 0 -- keycode 超時

-- Folding
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.fillchars = { -- 美化摺疊與結尾符號
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Invisible Characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- External Tools
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Miscs
opt.formatoptions = "jcroqlnt" -- 設定自動排版行為
opt.jumpoptions = "view"
opt.spelllang = { "en" }
