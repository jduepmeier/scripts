#!/usr/bin/env bash
#
# display mode switches between primary and other display configurations

PRIMARY_DISPLAY="${PRIMARY_DISPLAY:-eDP-1}"

set -euo pipefail

log() {
	( >&2 echo "$@" )
}

select_mode() {
	wofi --show=dmenu <<-EOF
		primary
		secondary
		extended
		extended-right
		extended-left
		EOF
}

# Sends the command to sway.
# First parameter is the output name,
# second parameter is the cmd (on or off).
output_cmd() {
	output="${1}"
	cmd="${2}"
	log "${output}" "${cmd}"
	swaymsg "output '${output}' ${cmd}"
}

# Enables the primary display and disables all
# other displays.
mode_primary() {
	while read output
	do
		if [[ "${output}" == "${PRIMARY_DISPLAY}" ]]
		then
			mode='enable'
		else
			mode='disable'
		fi
		output_cmd "${output}" "${mode}"
	done <<<"${output_names}"
}

# Disables the primary display and
# enables all secondary displays.
mode_secondary() {
	while read output
	do
		if [[ "${output}" == "${PRIMARY_DISPLAY}" ]]
		then
			mode='disable'
		else
			mode='enable'
		fi
		output_cmd "${output}" "${mode}"
	done <<<"${output_names}"
}

# Extends the primary display.
mode_extended() {
	direction="${1:-}"
	while read output
	do
		output_cmd "${output}" "enable"
	done <<<"${output_names}"

	if [[ -n "${direction}" ]]
	then
		outputs=$(swaymsg -t get_outputs -r)
		output_names="$(jq -r '.[].name' <<<"${outputs}")"
		while read output
		do
			width="$(output="${output}" jq -r '.[] | select(.name == env.output) | .current_mode.width' <<<"$outputs")"
			log "found width ${width} for output ${output}"
			if [[ "${output}" == "${PRIMARY_DISPLAY}" ]]
			then
				primary_width="${width}"
				primary_output="${output}"
			else
				secondary_width="${width}"
				secondary_output="${output}"
			fi
		done <<<"${output_names}"
		case "${direction}" in
			left)
				swaymsg "output '${secondary_output}' pos 0 0"
				swaymsg "output '${primary_output}' pos ${secondary_width} 0"
				;;
			right)
				swaymsg "output '${primary_output}' pos 0 0"
				swaymsg "output '${secondary_output}' pos ${primary_width} 0"
				;;
		esac
	fi
}

main() {
	mode="${1:-}"
	outputs=$(swaymsg -t get_outputs -r)
	output_names=$(jq -r '.[].name' <<<"${outputs}")

	if [[ -z "${mode}" ]]
	then
		mode="$(select_mode)"
	fi

	case "${mode}" in
		primary)
			mode_primary
			;;
		secondary)
			mode_secondary
			;;
		extended)
			mode_extended
			;;
		extended-left)
			mode_extended left
			;;
		extended-right)
			mode_extended right
			;;
		*)
			log "unkown mode: ${mode}"
			exit 2
			;;
	esac
}
main "$@"
