#!/bin/bash

folders=("SporadicSender" "DistanceSensing" "CycleWithDelay")

results_path="../Results"
bin_path="../bin"
lfc_path="../lingua-franca/bin/lfc-dev"
rti_relative_path="../lingua-franca/core/src/main/resources/lib/c/reactor-c/core/federated/RTI/build/RTI"
# Get absolute path of the RTI relative to the script location
# Get the absolute path
if command -v realpath &> /dev/null; then
    rti_abs_path=$(realpath -m "$rti_relative_path")
elif command -v readlink &> /dev/null; then
    rti_abs_path=$(readlink -f "$rti_relative_path")
else
    # Fallback if neither realpath nor readlink is available
    original_dir=$(pwd)
    path_dir=$(dirname "$rti_relative_path")
    path_base=$(basename "$rti_relative_path")
    cd "$path_dir" 2>/dev/null || exit 1
    rti_abs_path="$(pwd)/$path_base"
    cd "$original_dir" || exit 1
fi

rm -rf $bin_path/Solution

# Simulate the network with 10 ms of delay and 1 ms of jitter.
sudo tc qdisc add dev lo root netem delay 5ms 1ms

for folder in "${folders[@]}"; do
	if [[ -d "$folder" ]]; then
		echo "Compile .lf files in $folder:"
		for file in "$folder"/*.lf; do
			if [[ -f "$file" ]]; then
				filename_with_ext="${file##*/}"
				filename="${filename_with_ext%.lf}"
				echo "File name is $filename."
				$lfc_path "$file"

				if [[ $? -eq 0 ]]; then
					mkdir -p "$bin_path/Solution/$folder/$filename"

					mv "$bin_path/$filename" "$bin_path/Solution/$folder/$filename/$filename"
					echo "Compiled $file successfully and moved to $bin_path/Solution/$folder/$filename/$filename"
					pushd $bin_path/Solution/$folder/$filename
					
					# Replace the RTI check with a check for the absolute path
					sed -i '/# First, check if the RTI is on the PATH/,/fi/d' $filename
					
					# Insert new check after "echo "#### Launching the runtime infrastructure (RTI).""
					sed -i '/echo "#### Launching the runtime infrastructure (RTI)."/a\
# Check if RTI exists at the absolute path\
if [ ! -f "'"$rti_abs_path"'" ]; then\
    echo "RTI could not be found at '"$rti_abs_path"'."\
    echo "The source code can be obtained from https://github.com/lf-lang/reactor-c/tree/main/core/federated/RTI"\
    exit 1\
fi' $filename
					
					# Replace RTI with absolute path
					sed -i "s|RTI -i|$rti_abs_path -i|g" $filename

					./$filename
					popd
					echo "Ran $bin_path/Solution/$folder/$filename/$filename."
				else
					echo "Failed to compile $file."
				fi
			else
					echo "No .lf files found in $folder."
			fi
		done
	else
		echo "Directory $folder does not exist."
	fi
done

# Remove the simulated network delay.
sudo tc qdisc del dev lo root

mv $bin_path/Solution $results_path/

echo "Done"
