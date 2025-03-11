#!/bin/bash

folders=("SporadicSender" "DistanceSensing" "CycleWithDelay")

pushd ../Results
mkdir -p ./CycleWithDelay ./DistanceSensing ./SporadicSender
popd

for folder in "${folders[@]}"; do
	if [[ -d "$folder" ]]; then
		echo "Compile .lf files in $folder:"
		for file in "$folder"/*.lf; do
			if [[ -f "$file" ]]; then
				$lfc "$file"

				if [[ $? -eq 0 ]]; then
					filename_with_ext="${file##*/}"
					filename="${filename_with_ext%.lf}"
					echo "File name is $filename."

					mkdir -p "../bin/DNET/$folder/$filename"

					mv "../bin/$filename" "../bin/DNET/$folder/$filename/$filename"
					echo "Compiled $file successfully and moved to bin/$filename"
					pushd ../bin/DNET/$folder/$filename
					./$filename
					popd
					echo "Ran ../bin/DNET/$folder/$filename/$filename."
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

pushd ../Results
mkdir -p ./DNET
mv ./CycleWithDelay ./DistanceSensing ./SporadicSender ./DNET
popd

echo "Baseline Done"
