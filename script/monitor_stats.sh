#!/bin/bash

# 🐳 対象コンテナ名（省略時はデフォルト）
CONTAINER_NAME="${1:-sidekiq-memory-test-sidekiq-1}"
OUTPUT_FILE=log/stats_${CONTAINER_NAME}_$(date +%Y%m%d%H%M%S).tsv
INTERVAL=0.1

EXIT_SIGNAL_FILE="/tmp/monitor_exit_signal_$$"

# TSV ヘッダー（タブ区切り）
echo -e "timestamp\tcpu_percent\tmem_usage" > "$OUTPUT_FILE"

# ⌨️ キーボード監視（macOS対応）
monitor_input() {
  old_stty=$(stty -g < /dev/tty 2>/dev/null)
  stty -icanon -echo min 1 time 0 < /dev/tty 2>/dev/null

  while true; do
    if IFS= read -rsn1 key < /dev/tty; then
      if [[ $key == "q" || $key == $'\e' ]]; then
        touch "$EXIT_SIGNAL_FILE"
        break
      fi
    fi
  done

  [[ -n "$old_stty" ]] && stty "$old_stty" < /dev/tty 2>/dev/null
}

monitor_input &
INPUT_PID=$!

echo "🔍 モニタリング開始: コンテナ '$CONTAINER_NAME'"
echo "❎ 終了するには 'q' または 'ESC' を押してください。"
echo ""
echo -e "timestamp\t\tcpu\tmemory"

# 📈 記録ループ
while true; do
  if [[ -f "$EXIT_SIGNAL_FILE" ]]; then
    echo "✅ 終了シグナルを検出しました。"
    break
  fi

  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S.%3N")

  docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" "$CONTAINER_NAME" | while IFS=',' read -r cpu mem; do
    mem_used=$(echo "$mem" | cut -d'/' -f1 | xargs)
    cpu_clean=$(echo "$cpu" | tr -d '%')
    echo -e "$TIMESTAMP\t$cpu_clean\t$mem_used" >> "$OUTPUT_FILE"
    echo -e "$TIMESTAMP\t$cpu_clean%\t$mem_used"
  done

  sleep "$INTERVAL"
done

# 🧹 クリーンアップ
rm -f "$EXIT_SIGNAL_FILE"
kill "$INPUT_PID" 2>/dev/null

# 📊 統計計算
MAX_CPU=$(awk -F'\t' 'NR>1 { if ($2+0 > max) max=$2+0 } END { print max }' "$OUTPUT_FILE")
MAX_MEM=$(awk -F'\t' 'NR>1 {
  val = $3;
  if (val ~ /MiB/) {
    sub(/MiB/, "", val); v = val + 0
  } else if (val ~ /GiB/) {
    sub(/GiB/, "", val); v = val * 1024
  } else {
    v = 0
  }
  if (v > max) max = v
} END { print max }' "$OUTPUT_FILE")

# 📤 出力
echo ""
echo "📊 統計結果"
echo "最大 CPU 使用率: ${MAX_CPU}%"
echo "最大 メモリ使用量: ${MAX_MEM} MiB"
echo ""
echo "📁 ログファイル: $OUTPUT_FILE"
