import os
import pandas as pd

# Define the benchmarks and approaches
benchmarks = ["SporadicSender", "DistanceSensing", "CycleWithDelay"]
approaches = ["HLA_like", "SOTA", "Solution"]

# Timer periods and metrics to display
timer_periods = ["5ms", "10ms", "20ms", "50ms", "100ms"]
display_metrics = ["NET", "LTC", "TAG", "DNET", "Total"]

# Function to read CSV file
def read_csv_file(file_path):
    try:
        if os.path.exists(file_path):
            df = pd.read_csv(file_path, index_col=0)
            return df
        else:
            print(f"File not found: {file_path}")
            return pd.DataFrame()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return pd.DataFrame()

# Function to get value from dataframe
def get_value(df, metric, period):
    if df.empty or period not in df.columns:
        return float('nan')
    
    # Try with "num_" prefix first
    if f"num_{metric}" in df.index:
        return df.loc[f"num_{metric}", period]
    # Then try without prefix
    elif metric in df.index:
        return df.loc[metric, period]
    
    return float('nan')  # Using float('nan') instead of np.nan

# Function to format a value for LaTeX
def format_value(value):
    if pd.isna(value):
        return "N/A"
    try:
        return f"{int(float(value)):,}"
    except (ValueError, TypeError):
        return str(value)

# Function to generate LaTeX table
def generate_latex_table():
    latex_table = """\\begin{table*}
\\scriptsize
\t\\centering
\t\\begin{tabular}{|l|rrrrr||l|rrrrr||l|rrrrr|}
"""
    
    for benchmark in benchmarks:
        # Add header for each benchmark
        latex_table += f"\t\t\\hline\n\t\t\\multicolumn{{18}}{{|c|}}{{\\textbf{{{benchmark} (\\figurename~\\ref{{fig:{benchmark}}})}}}} \\\\\n\t\t\\hline\n"
        latex_table += "\t\t\\multicolumn{6}{|c||}{HLA-like} & \\multicolumn{6}{|c||}{SOTA} & \\multicolumn{6}{|c|}{Our Solution} \\\\\n\t\t\\hline\n"
        latex_table += "\t\tTimer Period \\hspace{-5pt} & 5ms & 10ms & 20ms & 50ms & 100ms & Timer Period \\hspace{-5pt} & 5ms & 10ms & 20ms & 50ms & 100ms & Timer Period \\hspace{-5pt} & 5ms & 10ms & 20ms & 50ms & 100ms \\\\\n\t\t\\hline\n"
        
        # Read data for each approach
        data = {}
        for approach in approaches:
            csv_path = f"{approach}/{benchmark}/{benchmark}_num_signals.csv"
            data[approach] = read_csv_file(csv_path)
        
        # Generate rows for each metric
        for metric in display_metrics:
            row = f"\t\t{metric} "
            
            # Add values for each approach
            for approach in approaches:
                values = []
                for period in timer_periods:
                    value = get_value(data[approach], metric, period)
                    values.append(format_value(value))
                
                # Add to row
                row += "& " + " & ".join(values) + " "
            
            row += "\\\\\n"
            latex_table += row
        
        latex_table += "\t\t\\hline\n"
        
        # Add a separator between benchmarks (except for the last one)
        if benchmark != benchmarks[-1]:
            latex_table += "%\n\t\t\\hline\n"
    
    # Finish the table
    latex_table += "\t\\end{tabular}\n\t\n\t\\caption{Number of exchanged signals during the 500 sec of runtime with timer periods from 5 ms to 100 ms.}\n\t\\label{tab:NumSignals}\n\\end{table*}"
    
    return latex_table

# Main function to run the script
def main():
    latex_table = generate_latex_table()
    print(latex_table)
    
    # Save to a file
    with open("table_num_signals.tex", "w") as f:
        f.write(latex_table)
    print("Table saved to table_num_signals.tex")

if __name__ == "__main__":
    main()