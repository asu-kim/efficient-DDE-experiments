import os
import pandas as pd
import sys

def combine_csv_files(base_dir):
    # Get the directory name for the output file name
    base_name = os.path.basename(base_dir)
    dfs = {}

    # Find all directories that match the *ms pattern (e.g., CycleWithDelay_5ms)
    ms_directories = []
    for item in os.listdir(base_dir):
        item_path = os.path.join(base_dir, item)
        if os.path.isdir(item_path) and "ms" in item:
            ms_directories.append(item_path)
    
    if not ms_directories:
        print(f"No *ms directories found in {base_dir}")
        return
    
    # Process each directory
    for ms_dir_path in sorted(ms_directories):
        ms_dir_name = os.path.basename(ms_dir_path)
        ms_value = ms_dir_name.split('_')[-1].replace('ms', '')
        
        # Find all CSV files in this directory that end with ms.csv
        csv_files = [f for f in os.listdir(ms_dir_path) if f.endswith('ms.csv')]
        
        if len(csv_files) == 1:
            csv_path = os.path.join(ms_dir_path, csv_files[0])
            try:
                df = pd.read_csv(csv_path, header=None)
                if not df.empty:
                    # Take the first column and convert microseconds to milliseconds
                    first_col = df[0]
                    dfs[ms_value] = first_col / 1_000_000
                else:
                    print(f"Warning: Empty CSV file in {csv_path}")
            except Exception as e:
                print(f"Error reading {csv_path}: {e}")
        else:
            print(f"Warning: Expected exactly one *ms.csv file in {ms_dir_path}")
            print(f"Found: {csv_files}")
            continue
    
    if dfs:
        # Create the combined DataFrame
        result_df = pd.DataFrame(dfs)
        
        # Try to sort columns numerically
        try:
            result_df = result_df.reindex(columns=sorted(result_df.columns, key=int))
        except (ValueError, TypeError):
            # If columns can't be sorted numerically, keep them as is
            pass
        
        # Calculate averages and standard deviations for each column
        averages = result_df.mean()
        std_devs = result_df.std()
        
        # Standard ms values expected in the output
        ms_values = [5, 10, 20, 50, 100]
        
        # Format output in column-major format as requested
        # Create a new DataFrame with headers
        output_df = pd.DataFrame(columns=["", "Delay (ms)", "Avg", "Standard Deviation"])
        
        # Create rows for each ms value first, then create DataFrame at once
        rows = []
        row_index = 1
        for ms in ms_values:
            ms_str = str(ms)
            if ms_str in averages:
                new_row = {
                    "": row_index,
                    "Delay (ms)": ms,
                    "Avg": averages[ms_str],
                    "Standard Deviation": std_devs[ms_str]
                }
                rows.append(new_row)
                row_index += 1
                
        # Create DataFrame from all rows at once instead of concatenating
        output_df = pd.DataFrame(rows, columns=["", "Delay (ms)", "Avg", "Standard Deviation"])
        
        # Output to CSV with new naming convention and location
        # Get the parent directory name (e.g., Plain)
        parent_dir_name = os.path.basename(os.path.dirname(base_dir))
        # Create output filename using benchmark name + parent dir + Statistics.csv
        output_filename = f"{base_name}{parent_dir_name}Statistics.csv"
        # Save to current directory (where script is run)
        output_file = os.path.join('.', output_filename)
        output_df.to_csv(output_file, index=False)
        print(f"Output file created: {output_file}")
    else:
        print(f"No valid CSV data found in {base_dir}")

def main():
    # Find all benchmark directories one level deep
    benchmark_dirs = []
    
    # Top-level directories (like Plain)
    for top_dir in os.listdir('.'):
        top_dir_path = os.path.join('.', top_dir)
        if os.path.isdir(top_dir_path):
            # Check second level directories (like CycleWithDelay)
            for benchmark in os.listdir(top_dir_path):
                benchmark_path = os.path.join(top_dir_path, benchmark)
                if os.path.isdir(benchmark_path):
                    # Check if this directory contains any *ms subdirectories
                    has_ms_subdir = any("ms" in item for item in os.listdir(benchmark_path) 
                                       if os.path.isdir(os.path.join(benchmark_path, item)))
                    if has_ms_subdir:
                        benchmark_dirs.append(benchmark_path)

    if not benchmark_dirs:
        print("Error: No suitable benchmark directories found")
        sys.exit(1)

    print(f"Found benchmark directories to process: {', '.join(benchmark_dirs)}")

    for directory in benchmark_dirs:
        print(f"\nProcessing directory: {directory}")
        combine_csv_files(directory)

if __name__ == "__main__":
    main()