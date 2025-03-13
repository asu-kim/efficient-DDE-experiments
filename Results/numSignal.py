import os
import subprocess
import pandas as pd
import sys

current_dir = os.path.dirname(os.path.abspath(__file__))
trace_path_HLA_like = os.path.join(current_dir, '../lingua-franca-HLA-like/core/src/main/resources/lib/c/reactor-c/util/tracing/trace_to_csv')
trace_path_SOTA = os.path.join(current_dir, '../lingua-franca-SOTA/core/src/main/resources/lib/c/reactor-c/util/tracing/trace_to_csv')
trace_path_solution = os.path.join(current_dir, '../lingua-franca-solution/core/src/main/resources/lib/c/reactor-c/util/tracing/trace_to_csv')

def extract_ms_value(folder_name):
    """Extract the ms value from folder name for sorting."""
    # Extract the ms value (e.g., '5' from 'CycleWithDelay_5ms')
    ms_part = folder_name.split('_')[-1]
    return int(ms_part.replace('ms', ''))

def process_rti_file(rti_path, top_dir):
    """Process a single rti.lft file and return signal counts."""
    # Get directory containing the rti file
    rti_dir = os.path.dirname(rti_path)
    
    # Initialize signal counts with zeros for all required columns
    signal_counts = {
        'num_NET': 0,
        'num_LTC': 0,
        'num_TAG': 0,
        'num_DNET': 0
    }
    
    # Save current directory
    original_dir = os.getcwd()
    
    # Select the appropriate trace_path based on top_dir
    if top_dir == "HLA_like":
        trace_tool = trace_path_HLA_like
    elif top_dir == "SOTA":
        trace_tool = trace_path_SOTA
    elif top_dir == "Solution":
        trace_tool = trace_path_solution
    else:
        print("The top directory should be HLA_like, SOTA, or Solution.")
        sys.exit(1)
    
    try:
        # Change to the directory containing rti.lft (like pushd)
        os.chdir(rti_dir)
        
        # Run trace_to_csv command with just the filename since we're in the right directory
        try:
            subprocess.run([trace_tool, 'rti.lft'], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error processing {rti_path}: {e}")
            return None
        
        # Read and process the summary file
        if not os.path.exists('rti_summary.csv'):
            print(f"Error: rti_summary.csv not generated for {rti_path}")
            return None
        
        # Process the summary file
        with open('rti_summary.csv', 'r') as f:
            for line in f:
                parts = line.strip().split(',')
                if len(parts) != 2:
                    continue
                    
                signal_type, count = parts[0].strip(), int(parts[1].strip())
                
                if 'Receiving NET' in signal_type:
                    signal_counts['num_NET'] = count
                elif 'Receiving LTC' in signal_type:
                    signal_counts['num_LTC'] = count
                elif 'Sending TAG' in signal_type:
                    signal_counts['num_TAG'] = count
                elif 'Sending DNET' in signal_type:
                    signal_counts['num_DNET'] = count
        
        # Calculate total
        total = sum(signal_counts.values())
        signal_counts['Total'] = total
        
        return signal_counts
        
    finally:
        # Always return to original directory (like popd)
        os.chdir(original_dir)

def process_benchmark_directory(benchmark_dir, top_dir):
    """Process all ms subfolders in a benchmark directory."""
    base_name = os.path.basename(benchmark_dir)
    results = {}
    
    # Look for ms directories in the benchmark directory
    ms_directories = []
    for item in os.listdir(benchmark_dir):
        item_path = os.path.join(benchmark_dir, item)
        if os.path.isdir(item_path) and "ms" in item:
            ms_directories.append(item_path)
    
    if not ms_directories:
        print(f"No ms directories found in {benchmark_dir}")
        return
    
    # Sort the ms directories by their ms value
    ms_directories.sort(key=lambda x: extract_ms_value(os.path.basename(x)))
    
    # Process each ms directory
    for ms_dir_path in ms_directories:
        ms_dir_name = os.path.basename(ms_dir_path)
        ms_value = extract_ms_value(ms_dir_name)
        
        # Look for rti.lft file in the ms directory
        rti_path = os.path.join(ms_dir_path, 'rti.lft')
        if not os.path.exists(rti_path):
            print(f"Error: rti.lft not found in {ms_dir_path}")
            continue
        
        # Process the rti file
        signal_counts = process_rti_file(rti_path, top_dir)
        if signal_counts is None:
            print(f"Error processing {ms_dir_path}")
            continue
        
        # Store results with ms value as column name
        results[f"{ms_value}ms"] = signal_counts
    
    if not results:
        print(f"No data found in {benchmark_dir}")
        return
    
    # Create DataFrame and transpose it
    df = pd.DataFrame(results)
    
    # Ensure rows are in the desired order
    row_order = ['num_NET', 'num_LTC', 'num_TAG', 'num_DNET', 'Total']
    df = df.reindex(row_order)
    
    # Save to CSV
    output_file = os.path.join(benchmark_dir, f"{base_name}_num_signals.csv")
    df.to_csv(output_file)
    print(f"Created signal count file: {output_file}")

def main():
    # Find all benchmark directories one level deep
    benchmark_dirs = []
    
    # Top-level directories (like HLA_like, SOTA, Solution)
    for top_dir in os.listdir('.'):
        top_dir_path = os.path.join('.', top_dir)
        if os.path.isdir(top_dir_path) and top_dir in ["HLA_like", "SOTA", "Solution"]:
            print(f"Processing top directory: {top_dir}")
            
            # Check second level directories (like CycleWithDelay)
            for benchmark in os.listdir(top_dir_path):
                benchmark_path = os.path.join(top_dir_path, benchmark)
                if os.path.isdir(benchmark_path):
                    # Check if this directory contains any *ms subdirectories
                    has_ms_subdir = any("ms" in item for item in os.listdir(benchmark_path) 
                                       if os.path.isdir(os.path.join(benchmark_path, item)))
                    if has_ms_subdir:
                        benchmark_dirs.append((benchmark_path, top_dir))

    if not benchmark_dirs:
        print("Error: No suitable benchmark directories found")
        sys.exit(1)

    print(f"Found benchmark directories to process: {', '.join([d[0] for d in benchmark_dirs])}")

    for directory, top_dir in benchmark_dirs:
        print(f"\nProcessing directory: {directory} with {top_dir} trace tool")
        process_benchmark_directory(directory, top_dir)

if __name__ == "__main__":
    main()