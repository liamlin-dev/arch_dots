# ==============================================================================
# 共用函數庫
# ==============================================================================

# --- 顏色定義 ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_BLUE='\033[0;34m'
C_BOLD='\033[1m'

# --- Log 函數 ---
function log_info() {
  echo -e "${C_BLUE}[INFO]${C_RESET} $*"
}

function log_success() {
  echo -e "${C_GREEN}[SUCCESS]${C_RESET} $*"
}

function log_warning() {
  echo -e "${C_YELLOW}[WARNING]${C_RESET} $*"
}

function log_error() {
  echo -e "${C_RED}[ERROR]${C_RESET} $*" >&2
}

# --- 錯誤處理 ---
function die() {
  log_error "$*"
  exit 1
}

# --- 檢查工具是否存在 ---
function check_command() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    die "找不到命令: $cmd，請先安裝"
  fi
}

# --- 檢查檔案是否存在 ---
function check_file() {
  local file="$1"
  if [ ! -f "$file" ]; then
    die "找不到檔案: $file"
  fi
}

# --- 檢查目錄是否存在 ---
function check_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    die "找不到目錄: $dir"
  fi
}

# --- 檢查執行檔是否存在且可執行 ---
function check_executable() {
  local exe="$1"
  if [ ! -f "$exe" ]; then
    die "找不到執行檔: $exe"
  fi
  if [ ! -x "$exe" ]; then
    die "檔案不可執行: $exe"
  fi
}

function tmux_kill_fzf() {
  local session=$(tmux ls | fzf | awk -F: '{print $1}')
  if [[ -n "$session" ]]; then
    tmux kill-session -t "$session"
  fi
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

function add_path() {
  # check args is directory and not in PATH
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

function add_path_append() {
  # check args is directory and not in PATH
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$PATH:$1"
  fi
}

source $HOME/.config/zsh/functions/fzf.zsh
