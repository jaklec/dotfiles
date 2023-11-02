#!/usr/bin/env bash

DWNL_DIR=$HOME/Downloads

SCAN_DIR=$DWNL_DIR/avscan
QRNT_DIR=$DWNL_DIR/quarantine

mkdir -p $SCAN_DIR $QRNT_DIR

echo "Removing old marker files"
for file in "$SCAN_DIR"/*.avscan; do
	[[ -e $file ]] && rm "$file"
done

shopt -s lastpipe # Avoid creating two processes due to pipe
inotifywait --monitor $DWNL_DIR --event close_write --event moved_to |
	while read -r path action file; do
		## Wait for partial downloads to finish
		if [[ "$file" == *".part" ]]; then
			continue
		fi

		## Check if this event has already been processed
		if [[ -f "$SCAN_DIR/$file.avscan" ]]; then
			continue
		fi
		touch "$SCAN_DIR/$file.avscan"

		## Load clamscan virus definitions into memory. Scanning is really fast, but
		## it consumes around 1GB or RAM.
		##
		## Requires 'clamav-daemon': 'systemctl enable clamav-daemon.service --now'
		# CLAMSCAN_OUT="$(clamdscan --fdpass --move $QRNT_DIR "$DWNL_DIR/$file" | rg -i "Infected files")"

		## Lazy load virus definitions just in time for scanning. Scanning will slow
		## because definitions will have to be loaded and compiled each time.
		CLAMSCAN_OUT="$(clamscan --move $QRNT_DIR "$DWNL_DIR/$file" | rg -i "Infected files")"

		MESSAGE=$(printf "Scanning $file\n$CLAMSCAN_OUT")
		notify-send "$MESSAGE"
	done
