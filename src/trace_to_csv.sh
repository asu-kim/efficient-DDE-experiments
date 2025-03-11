#!/bin/bash

BASE_DIR="./bin"

for dir in "$BASE_DIR"/*; do
	if [[ -d "$dir" ]]; then
		echo "Trace_to_csv files in $dir:"
		for subdir in "$dir"/*; do
			if [[ -d "$subdir" ]]; then
				echo "Sub Dir is $subdir"
				for subsubdir in "$subdir"/*;do
					if [[ -d "$subsubdir" ]]; then
						echo "Sub Sub Dir is $subsubdir"
						for trace in "$subsubdir"/*.lft; do
							pushd "$subsubdir" > /dev/null
							echo "target file: $(basename "$trace")"
							if [[ "$(basename "$dir")" == "Plain" ]]; then
								echo "trace_to_csv_plain $(basename "$trace")"
								trace_to_csv_plain $(basename "$trace")
							else
								echo "trace_to_csv_DNET $(basename "$trace")"
								trace_to_csv_DNET $(basename "$trace")
							fi
							popd > /dev/null
						done
						for summary in "$subsubdir"/*summary.csv; do
							file=$(basename "$summary")
							new_path=$(echo "$subsubdir" | sed 's|/bin|/bin/summary|')
							mkdir -p $new_path
							cp $summary "$new_path/$file"
						done
					fi
				done
			fi
		done
	fi
done
