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
  if [[ "$1" == "-f" ]]; then
    echo "Fetching all..."
    git fetch --all --prune # 更新本地倉庫並刪除遠端以刪除的分支
  fi
  local branch
  branch=$(
    # 列出所有本地/遠端分支，且不包含 HEAD 指針
    git branch --all --color=always | grep -v 'HEAD' | fzf \
      --ansi \
      --no-sort \
      --reverse \
      --header "Select branch to checkout" \
      --preview 'git log -10 --pretty=format:"%C(yellow)%h%Creset %s (%an, %ar)" --graph $(echo {} | sed "s/.* //")' \
      --bind 'ctrl-s:toggle-sort' |
      awk '{print $NF}'
  )

  if [[ -n "$branch" ]]; then
    # 檢查是否為遠端分支 (e.g., remotes/origin/main)
    if [[ "$branch" == remotes/* ]]; then
      # 將遠端分支轉換成本地分支名稱 (例如: remotes/origin/feature -> feature)
      local remote_name=$(echo "$branch" | cut -d'/' -f3-)
      echo "Switching to remote track: $remote_name"
      git switch "$remote_name"
    else
      # 本地分支直接切換
      git switch "$branch"
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
  file=$(
    find /usr/share/doc -type f 2>/dev/null |
      fzf --height 100% \
        --prompt "Doc > " \
        --preview '
          if [[ {} == *.gz ]]; then
            zcat {} | bat -l md --color=always --style=-numbers
          else
            bat --color=always --style=-numbers {}
          fi
        '
  )

  [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
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
      fzf --height=100% \
        --prompt="Man > " \
        --preview 'man {2} {1} 2>/dev/null | bat -l man --color=always --style=-numbers'
  )

  if [[ -n "$page" ]]; then
    local name section
    name=$(echo "$page" | awk '{print $1}')
    section=$(echo "$page" | awk '{print $2}' | tr -d '()')

    man "$section" "$name" | bat -l man --style=-numbers
  fi
}

# frun: 模糊尋找並執行當前目錄下的可執行檔
function frun() {
  local exe

  exe=$(
    find . -type f -executable \
      -not -path '*/.*' \
      -not -path '*/node_modules/*' \
      -not -path '*/build/*/*/*.o' \
      2>/dev/null |
      fzf --prompt="Run > " \
        --header="Select an executable to run" \
        --preview '
          if file --mime-encoding {} | grep -q "binary"; then
            # 基本檔案資訊 (大小)
            echo -e "\033[1;33m==== File Info ====\033[0m"
            echo -n "  Size: "
            ls -lh {} | awk "{print \$5}"

            # ELF 標頭與架構
            echo -e "\n\033[1;36m==== Architecture ====\033[0m"
            readelf -h {} 2>/dev/null | grep -E "Class:|Machine:|Type:|Entry point" | sed "s/^[ \t]*/  /"

            # 編譯器資訊 (.comment section 通常會記錄 GCC/Clang 版本)
            echo -e "\n\033[1;35m==== Compiler Version ====\033[0m"
            readelf -p .comment {} 2>/dev/null | grep -oE "(GCC|clang version).*" | head -n 1 | sed "s/^/  /" || echo "  (Unknown/Stripped)"

            # 編譯與安全防護 (Hardening & Debug)
            echo -e "\n\033[1;32m==== Build & Hardening ====\033[0m"
            if readelf -S {} 2>/dev/null | grep -q "\.debug_info"; then
              echo -e "  [+] Debug Info:   \033[32mPresent\033[0m"
            else
              echo -e "  [-] Debug Info:   \033[31mStripped\033[0m"
            fi
            # 檢查是否有 Stack Canary (緩衝區溢位保護)
            if nm {} 2>/dev/null | grep -q "__stack_chk_fail"; then
              echo -e "  [+] Stack Canary: \033[32mEnabled\033[0m"
            else
              echo -e "  [-] Stack Canary: \033[31mDisabled\033[0m"
            fi

            # 動態庫與路徑 (CMake 專案中 RPATH/RUNPATH 設錯常導致 lib 找不到)
            echo -e "\n\033[1;34m==== Linkage & RPATH ====\033[0m"
            # 優先高亮顯示 RPATH
            readelf -d {} 2>/dev/null | grep -E "(RPATH|RUNPATH)" | sed -r "s/.*\[(.*)\].*/  ★ \1 (RPATH)/"
            readelf -d {} 2>/dev/null | grep "NEEDED" | sed -r "s/.*\[(.*)\].*/  - \1/" || echo "  (Static or no dependencies)"

            # 核心符號表
            echo -e "\n\033[1;36m==== Top Symbols (Demangled) ====\033[0m"
            readelf -W -s {} 2>/dev/null | awk "NF>=8 {print \$8}" | grep -vE "^(_|@)" | head -n 15 | sed "s/^/  /" | c++filt
          else
            bat --style=numbers --color=always {} 2>/dev/null || cat {}
          fi' \
        --preview-window=right:65%
  )

  # 執行所選的檔案，並支援傳入額外參數
  if [[ -n "$exe" ]]; then
    echo -e "\033[1;32mRunning:\033[0m $exe $@"
    "$exe" "$@"
  fi
}
