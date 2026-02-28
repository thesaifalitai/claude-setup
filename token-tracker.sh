#!/usr/bin/env bash
# ============================================================
#  Token Usage Tracker — Monitor AI API costs across providers
#  Works with: Claude Code, Cursor, Aider, and any AI CLI tool
#  Usage: source token-tracker.sh && tt_enable
# ============================================================

# ─── Colors ──────────────────────────────────────────────────
TT_GREEN='\033[0;32m'
TT_YELLOW='\033[1;33m'
TT_CYAN='\033[0;36m'
TT_DIM='\033[2m'
TT_BOLD='\033[1m'
TT_NC='\033[0m'

# ─── Config ──────────────────────────────────────────────────
TT_LOG_DIR="$HOME/.claude/usage-logs"
TT_ENABLED=false
TT_SESSION_FILE=""
TT_SESSION_INPUT=0
TT_SESSION_OUTPUT=0
TT_SESSION_REQUESTS=0

# Pricing per 1M tokens (USD)
TT_OPUS_INPUT=15.00
TT_OPUS_OUTPUT=75.00
TT_SONNET_INPUT=3.00
TT_SONNET_OUTPUT=15.00
TT_HAIKU_INPUT=0.80
TT_HAIKU_OUTPUT=4.00

# Default model for cost calculation
TT_MODEL="sonnet"

# ─── Functions ────────────────────────────────────────────────

tt_enable() {
  TT_ENABLED=true
  mkdir -p "$TT_LOG_DIR"
  TT_SESSION_FILE="$TT_LOG_DIR/session_$(date +%Y%m%d_%H%M%S).log"
  TT_SESSION_INPUT=0
  TT_SESSION_OUTPUT=0
  TT_SESSION_REQUESTS=0

  echo -e "${TT_BOLD}${TT_GREEN}✅ Token tracking enabled${TT_NC}"
  echo -e "${TT_DIM}   Model: $TT_MODEL | Log: $TT_SESSION_FILE${TT_NC}"
  echo -e "${TT_DIM}   Commands: tt_log, tt_summary, tt_compare, tt_set_model, tt_disable${TT_NC}"
  echo ""
}

tt_disable() {
  if $TT_ENABLED; then
    tt_summary
  fi
  TT_ENABLED=false
  echo -e "${TT_YELLOW}⏭  Token tracking disabled${TT_NC}"
}

tt_set_model() {
  local model="${1:-sonnet}"
  case "$model" in
    opus|sonnet|haiku)
      TT_MODEL="$model"
      echo -e "${TT_CYAN}ℹ  Model set to: $TT_MODEL${TT_NC}"
      ;;
    *)
      echo -e "${TT_YELLOW}⚠  Unknown model: $model. Use: opus, sonnet, haiku${TT_NC}"
      ;;
  esac
}

tt_estimate_tokens() {
  # Estimate tokens from character count (1 token ≈ 4 chars)
  local chars="$1"
  echo $(( (chars + 3) / 4 ))
}

tt_calc_cost() {
  local input_tokens="$1"
  local output_tokens="$2"
  local model="${3:-$TT_MODEL}"

  local input_rate output_rate
  case "$model" in
    opus)   input_rate=$TT_OPUS_INPUT;   output_rate=$TT_OPUS_OUTPUT ;;
    sonnet) input_rate=$TT_SONNET_INPUT; output_rate=$TT_SONNET_OUTPUT ;;
    haiku)  input_rate=$TT_HAIKU_INPUT;  output_rate=$TT_HAIKU_OUTPUT ;;
  esac

  # Cost = (tokens / 1_000_000) * rate
  # Using awk for float math
  awk "BEGIN { printf \"%.6f\", ($input_tokens / 1000000 * $input_rate) + ($output_tokens / 1000000 * $output_rate) }"
}

tt_log() {
  if ! $TT_ENABLED; then
    echo -e "${TT_YELLOW}⚠  Token tracking not enabled. Run: tt_enable${TT_NC}"
    return
  fi

  local input_chars="${1:-0}"
  local output_chars="${2:-0}"
  local description="${3:-request}"

  local input_tokens=$(tt_estimate_tokens "$input_chars")
  local output_tokens=$(tt_estimate_tokens "$output_chars")
  local total_tokens=$((input_tokens + output_tokens))
  local cost=$(tt_calc_cost "$input_tokens" "$output_tokens")

  # Update session totals
  TT_SESSION_INPUT=$((TT_SESSION_INPUT + input_tokens))
  TT_SESSION_OUTPUT=$((TT_SESSION_OUTPUT + output_tokens))
  TT_SESSION_REQUESTS=$((TT_SESSION_REQUESTS + 1))

  # Log to file
  echo "$(date +%H:%M:%S) | in:$input_tokens out:$output_tokens total:$total_tokens cost:\$$cost | $description" >> "$TT_SESSION_FILE"

  # Display
  echo ""
  echo -e "${TT_DIM}───────────────────────────────────${TT_NC}"
  echo -e "${TT_BOLD}📊 Token Usage ${TT_DIM}(request #$TT_SESSION_REQUESTS)${TT_NC}"
  printf "  Input tokens:  ${TT_CYAN}~%s${TT_NC}\n" "$(printf "%'d" "$input_tokens")"
  printf "  Output tokens: ${TT_CYAN}~%s${TT_NC}\n" "$(printf "%'d" "$output_tokens")"
  printf "  Total tokens:  ${TT_BOLD}~%s${TT_NC}\n" "$(printf "%'d" "$total_tokens")"
  printf "  Est. cost:     ${TT_GREEN}~\$%s${TT_NC} ${TT_DIM}(%s)${TT_NC}\n" "$cost" "$TT_MODEL"
  echo -e "${TT_DIM}───────────────────────────────────${TT_NC}"
  echo ""
}

tt_summary() {
  if ! $TT_ENABLED; then
    echo -e "${TT_YELLOW}⚠  No active session. Run: tt_enable${TT_NC}"
    return
  fi

  local total=$((TT_SESSION_INPUT + TT_SESSION_OUTPUT))
  local cost=$(tt_calc_cost "$TT_SESSION_INPUT" "$TT_SESSION_OUTPUT")
  local avg_cost="0.000000"
  if [ "$TT_SESSION_REQUESTS" -gt 0 ]; then
    avg_cost=$(awk "BEGIN { printf \"%.6f\", $cost / $TT_SESSION_REQUESTS }")
  fi

  echo ""
  echo -e "${TT_BOLD}═══════════════════════════════════${TT_NC}"
  echo -e "${TT_BOLD}📊 Session Summary${TT_NC}"
  printf "  Total requests:     ${TT_CYAN}%d${TT_NC}\n" "$TT_SESSION_REQUESTS"
  printf "  Total input tokens:  ${TT_CYAN}~%s${TT_NC}\n" "$(printf "%'d" "$TT_SESSION_INPUT")"
  printf "  Total output tokens: ${TT_CYAN}~%s${TT_NC}\n" "$(printf "%'d" "$TT_SESSION_OUTPUT")"
  printf "  Total tokens:        ${TT_BOLD}~%s${TT_NC}\n" "$(printf "%'d" "$total")"
  printf "  Session cost:        ${TT_GREEN}~\$%s${TT_NC} ${TT_DIM}(%s)${TT_NC}\n" "$cost" "$TT_MODEL"
  printf "  Avg cost/request:    ${TT_DIM}~\$%s${TT_NC}\n" "$avg_cost"
  echo -e "${TT_BOLD}═══════════════════════════════════${TT_NC}"
  echo ""
}

tt_compare() {
  local input_tokens="${1:-$TT_SESSION_INPUT}"
  local output_tokens="${2:-$TT_SESSION_OUTPUT}"

  local opus_cost=$(tt_calc_cost "$input_tokens" "$output_tokens" "opus")
  local sonnet_cost=$(tt_calc_cost "$input_tokens" "$output_tokens" "sonnet")
  local haiku_cost=$(tt_calc_cost "$input_tokens" "$output_tokens" "haiku")

  # GPT-4o pricing
  local gpt4o_cost=$(awk "BEGIN { printf \"%.6f\", ($input_tokens / 1000000 * 2.50) + ($output_tokens / 1000000 * 10.00) }")
  # Gemini 1.5 Pro
  local gemini_cost=$(awk "BEGIN { printf \"%.6f\", ($input_tokens / 1000000 * 1.25) + ($output_tokens / 1000000 * 5.00) }")
  # DeepSeek V3
  local deepseek_cost=$(awk "BEGIN { printf \"%.6f\", ($input_tokens / 1000000 * 0.27) + ($output_tokens / 1000000 * 1.10) }")

  echo ""
  echo -e "${TT_BOLD}💰 Cost Comparison${TT_NC} ${TT_DIM}(~$(printf "%'d" "$input_tokens") in / ~$(printf "%'d" "$output_tokens") out)${TT_NC}"
  echo ""
  printf "  Claude Opus 4:    ${TT_CYAN}\$%s${TT_NC}\n" "$opus_cost"
  printf "  Claude Sonnet 4:  ${TT_CYAN}\$%s${TT_NC}\n" "$sonnet_cost"
  printf "  Claude Haiku 3.5: ${TT_CYAN}\$%s${TT_NC}\n" "$haiku_cost"
  printf "  GPT-4o:           ${TT_CYAN}\$%s${TT_NC}\n" "$gpt4o_cost"
  printf "  Gemini 1.5 Pro:   ${TT_CYAN}\$%s${TT_NC}\n" "$gemini_cost"
  printf "  DeepSeek V3:      ${TT_CYAN}\$%s${TT_NC}\n" "$deepseek_cost"
  echo ""
}

tt_history() {
  if [ ! -d "$TT_LOG_DIR" ] || [ -z "$(ls -A "$TT_LOG_DIR" 2>/dev/null)" ]; then
    echo -e "${TT_YELLOW}⚠  No usage logs found${TT_NC}"
    return
  fi

  echo ""
  echo -e "${TT_BOLD}📋 Recent Sessions${TT_NC}"
  echo ""

  for log in "$TT_LOG_DIR"/session_*.log; do
    [ -f "$log" ] || continue
    local filename=$(basename "$log")
    local date_part="${filename#session_}"
    date_part="${date_part%.log}"
    local lines=$(wc -l < "$log" | tr -d ' ')
    printf "  ${TT_CYAN}%s${TT_NC} — %s requests\n" "$date_part" "$lines"
  done
  echo ""
}

tt_help() {
  echo ""
  echo -e "${TT_BOLD}🛠️  Token Tracker Commands${TT_NC}"
  echo ""
  echo -e "  ${TT_CYAN}tt_enable${TT_NC}               Start tracking tokens"
  echo -e "  ${TT_CYAN}tt_disable${TT_NC}              Stop tracking and show summary"
  echo -e "  ${TT_CYAN}tt_log <in> <out>${TT_NC}       Log a request (chars in/out)"
  echo -e "  ${TT_CYAN}tt_summary${TT_NC}              Show session totals"
  echo -e "  ${TT_CYAN}tt_compare [in] [out]${TT_NC}   Compare costs across providers"
  echo -e "  ${TT_CYAN}tt_set_model <model>${TT_NC}    Set model (opus/sonnet/haiku)"
  echo -e "  ${TT_CYAN}tt_history${TT_NC}              Show past session logs"
  echo -e "  ${TT_CYAN}tt_help${TT_NC}                 Show this help"
  echo ""
}

# Auto-print help when sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo -e "${TT_DIM}Token tracker loaded. Run ${TT_CYAN}tt_enable${TT_DIM} to start or ${TT_CYAN}tt_help${TT_DIM} for commands.${TT_NC}"
fi
