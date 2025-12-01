# zi: 快速切換目錄 (zoxide + fzf)
function zi() {
  local dir
  # zoxide query -l: 列出所有歷史目錄
  # fzf 選項說明:
  # --height 40%: 彈出視窗高度為終端機的 40%
  # --layout=reverse: 顯示在終端機頂部
  # --prompt "zoxide: ": 設定提示字元
  dir="$(
    zoxide query -l | fzf \
      --height 40% \
      --layout=reverse \
      --prompt "zoxide: "
  )"

  # 檢查是否有選取目錄，若有則切換
  [ -n "$dir" ] && cd "$dir"
}

# gb: Git 分支快速切換 (git + fzf)
function gb() {
  local branch
  branch=$(
    # 列出所有本地/遠端分支，且不包含 HEAD 指針
    git branch --all --color=always | grep -v 'HEAD' | fzf \
      --ansi \
      --no-sort \
      --reverse \
      --header "Select branch to checkout" \
      --preview 'echo {} | awk "{print \$NF}" | xargs -I{} git log -10 --pretty=format:"%C(yellow)%h%Creset %s (%an, %ar)" --graph {}' \
      --bind 'ctrl-s:toggle-sort' |
      awk '{print $NF}'
  )

  if [[ -n "$branch" ]]; then
    # 檢查是否為遠端分支 (e.g., remotes/origin/main)
    if [[ "$branch" =~ ^remotes/ ]]; then
      # 將遠端分支轉換成本地分支名稱 (例如: remotes/origin/feature -> feature)
      local local_branch="${branch#remotes/*/}"
      # checkout 遠端分支，並建立/切換到同名本地分支
      git checkout -B "$local_branch" "$branch"
    else
      # 直接 checkout 本地分支
      git checkout "$branch"
    fi
  fi
}

# fkill: 模糊殺死進程 (ps + fzf + kill)
function fkill() {
  local pids
  # ps -eo ... --sort=-pid: 列出進程資訊，按 PID 降序排序
  # 預覽視窗: 格式化輸出選中進程的詳細資訊
  pids=$(ps -eo pid,user,ppid,stime,cmd --sort=-pid |
    sed '1d' |
    fzf --multi \
      --ansi \
      --reverse \
      --header="Select processes to kill (TAB to select, ENTER to confirm)" \
      --preview='echo -e "\033[1;33mPID:\033[0m {1}
\033[1;33mUser:\033[0m {2}
\033[1;33mPPID:\033[0m {3}
\033[1;33mStart:\033[0m {4}
\033[1;33mCommand:\033[0m {5..}"' \
      --preview-window=down,5,border-horizontal \
      --bind 'shift-down:preview-page-down' \
      --bind 'shift-up:preview-page-up' |
    awk '{print $1}') # 只取得 PID 欄位

  # 檢查是否有選取 PID，若有則使用 kill -9 終止
  # xargs -r: 確保在沒有輸入時不執行命令
  if [[ -n "$pids" ]]; then
    echo "$pids" | xargs -r sudo kill -9
  fi
}

# fssh: 模糊 SSH 連線 (grep + awk + fzf + ssh)
function fssh() {
  local host
  # 從 ssh config 中提取 Host 別名 (忽略註解行)
  host=$(grep -v '^\s*#' ~/.ssh/config | grep 'Host' | awk '{print $2}' | fzf)

  if [ -n "$host" ]; then
    # 輸出連線提示到標準錯誤 (>&2)，避免干擾主機名稱選取
    echo "Connecting to $host..." >&2
    ssh "$host"
  fi
}

# fdoc: 模糊文件瀏覽 (find + fzf + bat)
function fdoc() {
  local file
  # 搜尋 /usr/share/doc 下的所有文件
  # 預覽視窗: 使用 bat 進行語法高亮和行號顯示
  file=$(
    find /usr/share/doc -type f 2>/dev/null |
      fzf --height 60% \
        --prompt "Doc > "
    --preview 'bat --style=numbers --color=always {}'
  )

  # 檢查是否有選取文件，若有則使用 $EDITOR 或 nano 開啟
  # 確保 $EDITOR 有預設值 (nano)
  [[ -n "$file" ]] && ${EDITOR:-nano} "$file"
}

# fman: 模糊 man 手冊頁查詢 (man -k + fzf)
function fman() {
  local page
  # man -k .: 取得所有 man page 條目
  # 預覽視窗: 提取 man page 名稱和章節，然後顯示 man 內容
  page=$(
    man -k . 2>/dev/null |
      awk '{printf "%-30s %s\n", $1, $2}' |
      sort -k1,1 -V |
      uniq |
      fzf --height=70% \
        --prompt="Man > " \
        --preview 'echo {} | awk "{print \$1 \" \" \$2}" | tr -d "()" | xargs man 2>/dev/null | col -bx'
  )

  if [[ -n "$page" ]]; then
    local name section
    name=$(echo "$page" | awk '{print $1}')
    section=$(echo "$page" | awk '{print $2}' | tr -d '()')

    man "$section" "$name"
  fi
}

# fclib: 模糊 C 函式庫查詢 (man -k -s 2:3 + fzf)
function fclib() {
  local page

  # man -k . -s 2:3: 搜索 man section 2 (系統呼叫) 和 3 (C 函式庫)
  # 預覽視窗: 提取名稱和章節，然後顯示 man 內容
  # sort: 對輸入的每一行，僅使用第一個欄位作為排序依據，並以版本號碼的方式進行比較和排序
  page=$(
    man -k . -s 2:3 2>/dev/null |
      awk '{printf "%-30s %s\n", $1, $2}' |
      sort -k1,1 -V |
      uniq |
      fzf --height=70% \
        --prompt="C-Lib > " \
        --preview '
              name=$(echo {} | awk "{print \$1}")
              sec=$(echo {} | awk "{print \$2}" | tr -d "()")
              man "$sec" "$name" 2>/dev/null | col -bx
          '
  )

  if [[ -n "$page" ]]; then
    local name section
    name=$(echo "$page" | awk '{print $1}')
    section=$(echo "$page" | awk '{print $2}' | tr -d '()')

    man "$section" "$name"
  fi
}

# fmenu: FZF 整合選單
function fmenu() {
  local choice
  # fconf 函式沒有定義在您的原始碼中，這裡假設它存在，或您可以替換成其他功能
  choice=$(printf "config (fconf)\nman (fman)\ndocs (fdoc)\nall-files (fzf)" | fzf --prompt="Menu > ")

  case $choice in
  *config*)  # 匹配包含 'config' 的行
    fconf ;; # 假設 fconf 存在
  *man*)     # 匹配包含 'man' 的行
    fman ;;
  *docs*) # 匹配包含 'docs' 的行
    fdoc ;;
  *all-files*) # 匹配包含 'all-files' 的行
    # 直接執行 fzf 進行遞迴文件搜尋，並使用 bat 預覽
    fzf --preview 'bat --style=numbers --color=always {}'
    ;;
  esac
}
