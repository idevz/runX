#!/bin/sh

set -e

BASE_DIR="./"
PROBLEM_PATTERN='zhoujing2|idevz@'
SAFE_FILES=".//shell/etc-profile,.//runX,.//shell/runX.funcs.sh"

safe_grep() {
	local pattern="${1}"
	grep -lEr "${pattern}" \
		--exclude='*.\/\/code\/*' --exclude='*\/\.oh-my-zsh\/*' \
		--exclude='*.\/\/\.git\/*' --exclude='*.\/\/\deploy\/*' \
		--exclude='*.\/\/\gdb\/*' \
		"${BASE_DIR}"
}

clean_count_line() {
	for file_with_problem in $(safe_grep "${PROBLEM_PATTERN}"); do
		[ $(echo "${SAFE_FILES}" | grep "${file_with_problem}") ] && continue
		sed -i '' "/${PROBLEM_PATTERN}/d" "${file_with_problem}"
	done
}

ip_dim() {
	local ip_pattern='[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
	for file_with_ip_addr in $(safe_grep "${ip_pattern}"); do
		[ $(echo "${SAFE_FILES}" | grep "${file_with_ip_addr}") ] && continue
		LC_ALL=C sed -Ei '.sed.bak' "s/[0-9]+\.[0-9]+(\.[0-9]+\.[0-9]+)/xxx\.xxx\1/g" "${file_with_ip_addr}"
	done
}

small_history_file() {
	for his in $(find "${BASE_DIR}" -name '*.zsh_history'); do
		"${BASE_DIR}/scripts/exclude.awk" "${his}" | sort >"${his}.tmp"
		mv "${his}.tmp" "${his}"
	done
}

# clean_count_line
# ip_dim
small_history_file
