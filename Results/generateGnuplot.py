import csv
import os

def read_csv_values(csv_file):
    """
    Read CSV file and extract average values from first and second rows
    """
    try:
        with open(csv_file, 'r') as file:
            csv_reader = csv.DictReader(file)
            rows = list(csv_reader)
            
            if len(rows) < 2:
                print(f"Warning: CSV file {csv_file} has less than 2 rows of data")
                return None, None
            
            # Extract values from first row (for y5, y6)
            first_row_avg = float(rows[0]['Avg'])
            
            # Extract values from second row (for y3, y4)
            second_row_avg = float(rows[1]['Avg'])
            
            return first_row_avg, second_row_avg
            
    except Exception as e:
        print(f"Error reading CSV file {csv_file}: {e}")
        return None, None

def calculate_y_ranges(plain_csv, dnet_csv):
    """
    Calculate y-range values based on data from multiple CSV files
    (excludes solution statistics as requested)
    """
    # Fixed values for y1 and y2
    y1, y2 = 0, 4.5
    
    # For storing average values
    first_row_avgs = []
    second_row_avgs = []
    
    # Read values from PlainStatistics
    first_avg_plain, second_avg_plain = read_csv_values(plain_csv)
    if first_avg_plain is not None:
        first_row_avgs.append(first_avg_plain)
        second_row_avgs.append(second_avg_plain)
    
    # Read values from DNETStatistics
    first_avg_dnet, second_avg_dnet = read_csv_values(dnet_csv)
    if first_avg_dnet is not None:
        first_row_avgs.append(first_avg_dnet)
        second_row_avgs.append(second_avg_dnet)
    
    # Calculate y3 and y4 based on second row averages
    # y3 = smaller value - 30, y4 = bigger value + 30
    if second_row_avgs:
        y3 = min(second_row_avgs) - 30
        y4 = max(second_row_avgs) + 30
    else:
        y3, y4 = 0, 15000  # default values
    
    # Calculate y5 and y6 based on first row averages
    if first_row_avgs:
        y5 = min(first_row_avgs) - 30
        y6 = max(first_row_avgs) + 30
    else:
        y5, y6 = 200000, 350000  # default values
    
    # Ensure y values are integers
    y3, y4 = int(y3), int(y4)
    y5, y6 = int(y5), int(y6)
    
    return y1, y2, y3, y4, y5, y6

def update_gnuplot_script(gnuplot_file, y_values):
    """
    Update y range values in GNUPLOT script
    """
    y1, y2, y3, y4, y5, y6 = y_values
    
    try:
        with open(gnuplot_file, 'r') as file:
            content = file.read()
        
        # Find the line containing y-range definitions
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'y1' in line and 'y2' in line and 'y3' in line and 'y4' in line and 'y5' in line and 'y6' in line:
                # Replace the entire line with our new y-values
                lines[i] = f"y1 = {y1}; y2 = {y2}; y3 = {y3}; y4 = {y4}; y5 = {y5}; y6 = {y6}"
                break
        
        # Join the lines back together
        updated_content = '\n'.join(lines)
        
        # Update the original file
        with open(gnuplot_file, 'w') as file:
            file.write(updated_content)
            
        print(f"Updated GNUPLOT script: {gnuplot_file}")
        print(f"Y-range values: y1={y1}, y2={y2}, y3={y3}, y4={y4}, y5={y5}, y6={y6}")
        
    except Exception as e:
        print(f"Error updating GNUPLOT script {gnuplot_file}: {e}")

def process_files(prefix):
    """
    Process files for a specific prefix (CycleWithDelay or DistanceSensing)
    """
    print(f"\nProcessing {prefix} files:")
    
    # Define file paths
    plain_csv = f"{prefix}HLA_likeStatistics.csv"
    dnet_csv = f"{prefix}SOTAStatistics.csv"
    solution_csv = f"{prefix}SolutionStatistics.csv"  # Not used for calculations but checked for existence
    gnuplot_file = f"{prefix}Lags.gnuplot"
    
    # Check if files exist
    for file_path in [plain_csv, dnet_csv, solution_csv, gnuplot_file]:
        if not os.path.exists(file_path):
            print(f"Error: File {file_path} does not exist")
            return False
    
    # Calculate y-range values
    y_values = calculate_y_ranges(plain_csv, dnet_csv)
    
    # Update GNUPLOT script
    update_gnuplot_script(gnuplot_file, y_values)
    return True

def main():
    """
    Main function to process both tasks
    """
    # Task 1: Process DistanceSensing files
    process_files("DistanceSensing")
    
    # Task 2: Process CycleWithDelay files
    process_files("CycleWithDelay")
    
    print("\nAll processing completed.")

if __name__ == "__main__":
    main()