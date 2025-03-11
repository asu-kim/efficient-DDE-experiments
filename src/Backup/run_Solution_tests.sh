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

					mkdir -p "../bin/Solution/$folder/$filename"

					mv "../bin/$filename" "../bin/Solution/$folder/$filename/$filename"
					echo "Compiled $file successfully and moved to bin/$filename"
					pushd ../bin/Solution/$folder/$filename
					./$filename
					popd
					echo "Ran ../bin/Solution/$folder/$filename/$filename."
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
mkdir -p ./Solution
mv ./CycleWithDelay ./DistanceSensing ./SporadicSender ./Solution
popd

echo "Solution Done"
