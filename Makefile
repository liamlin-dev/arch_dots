# 變數定義
TARGET_HOME := ~
TARGET_CONFIG := ~/.config
TARGET_LOCAL := ~/.local/share

CHECK_FLATPAK_INSTALLED := if command -v flatpak >/dev/null 2>&1; then true; else false; fi
CHECK_USER_SESSION := if systemctl --user show >/dev/null 2>&1; then true; else false; fi

.PHONY: link unlink install upgrade refresh-package-list refresh-flatpak-list reset-audio flatpak-upgrade flatpak-install flatpak-refresh

## --- Dotfiles 管理 ---
link:
	@echo "🔗 Linking dotfiles..."
	@stow -v --target $(TARGET_HOME) home
	@stow -v --target $(TARGET_CONFIG) config
	@stow -v --target $(TARGET_LOCAL) local

unlink:
	@echo "❌ Unlinking dotfiles..."
	@stow -v --target $(TARGET_HOME) -D home
	@stow -v --target $(TARGET_CONFIG) -D config
	@stow -v --target $(TARGET_LOCAL) -D local

link-kde:
	@echo "🔗 Linking kde..."
	@stow -v --target $(TARGET_CONFIG) kde

unlink-kde:
	@echo "🔗 Linking kde..."
	@stow -v --target $(TARGET_CONFIG) -D kde


## --- 🚀 系統升級 ---
news:
	@echo "📰 Checking news (pacman & AUR with yay)..."
	@yay -Pw

upgrade:
	@echo "🔃 Upgrading system (pacman & AUR with yay)..."
	@yay -Syu --noconfirm
	@make refresh-package-list
	@make flatpak-upgrade

flatpak-upgrade:
	@if $(CHECK_FLATPAK_INSTALLED); then \
		echo "🔃 Upgrading Flatpak packages..."; \
		sudo flatpak update -y; \
		make flatpak-refresh; \
	else \
		echo "🔃 Flatpak not installed. Skipping Flatpak upgrade."; \
	fi



## --- 📝 產生最新手動安裝的套件清單 (pacman) ---
# Q: 查詢, q: 僅名稱, e: 手動安裝, n: 原生套件 (Native), m: 外部套件 (Foreign/AUR)
refresh-package-list:
	@echo "📝 Saving explicitly installed native packages to pkglist_native.txt..."
	@pacman -Qqen > pkglist_native.txt
	@echo "📝 Saving explicitly installed foreign (AUR) packages to pkglist_aur.txt..."
	@pacman -Qqem > pkglist_aur.txt

refresh-flatpak-list:
	@if $(CHECK_FLATPAK_INSTALLED); then \
		echo "📝 Saving manually installed flatpak packages to flatpak-packages.txt..."; \
		flatpak list --app --columns=application,origin | awk '{print $$1 " " $$2}' > flatpak-packages.txt; \
	else \
		echo "⚠️ Flatpak not installed. Skipping Flatpak package list refresh."; \
	fi


## --- 📦 套件安裝（來自 package list）---
install:
	@echo "📦 Installing Native packages from pkglist_native.txt (using pacman)..."
	@if [ ! -f pkglist_native.txt ]; then \
		echo "❌ pkglist_native.txt not found."; exit 1; \
	fi
	@sudo pacman -S --needed --noconfirm $$(grep -vE '^\s*#|^\s*$$' pkglist_native.txt)

	@echo "📦 Installing Foreign (AUR) packages from pkglist_aur.txt (using yay)..."
	@if [ ! -f pkglist_aur.txt ]; then \
		echo "❌ pkglist_aur.txt not found."; exit 1; \
	fi
	@yay -S --needed --noconfirm $$(grep -vE '^\s*#|^\s*$$' pkglist_aur.txt)

	@make flatpak-install

flatpak-install:
	@if $(CHECK_FLATPAK_INSTALLED); then \
		echo "📦 Installing Flatpak packages from flatpak-packages.txt..."; \
		if [ ! -f flatpak-packages.txt ]; then \
			echo "❌ flatpak-packages.txt not found."; exit 1; \
		fi; \
		awk '{print $$2 " " $$1}' flatpak-packages.txt | xargs -L1 flatpak install -y --noninteractive; \
	else \
		echo "ℹ️ Flatpak not installed. Skipping Flatpak installation."; \
	fi

