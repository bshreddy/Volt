import os
import re
import sys
import csv
from pathlib import Path
from tabulate import tabulate


folders = ["backprop", "bfs", "blackscholes", "b+tree", "cfd", "conv3", "dotproduct", "hotspot3D", "kmeans", "lavaMD", "nearn", "lbm", "pathfinder", "psum", "saxpy", "sfilter", "sgemm", "sgemm2", "sgemm3", "spmv", "srad", "transpose", "vecadd", "psort", "gaussian"]
options = [1, 2, 3, 4, 8, 9]
header_name = ["Base", "Uni-HW", "Uni-Ann", "Uni-func", "ziCond", "Recon"]
instrs_table = {}
cycles_table = {}
instrs_reduction_table = {}
speedup_table = {}
coverage_table = {}

def parse_perf_file(filepath):
    instrs_total = 0
    cycles_total = 0
    with open(filepath, 'r') as f:
        for line in f:
            match = re.search(r'PERF: instrs=(\d+), cycles=(\d+)', line)
            if match:
                instrs_total += int(match.group(1))
                cycles_total += int(match.group(2))
    return instrs_total, cycles_total

def extract_O_value(filename):
    match = re.search(r'_O(\d+)\.txt', filename)
    return int(match.group(1)) if match else None

def print_table(table, table_name="Table", table_path="output.csv"):
    #headers = ["Folder"] + [f"Opt{opt}" for opt in options]
    headers = ["Folder"] + header_name
    rows = []
    for folder, row in table.items():
        if not row:
            continue
        rows.append([folder] + [row.get(opt, "") for opt in options])
    print(tabulate(rows, headers=headers, tablefmt="grid", floatfmt=".4f"))
    
    csv_path = table_path
    with open(csv_path, mode="a", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([table_name])
        writer.writerow(headers)
        writer.writerows(rows)
    print(f"Saved table '{table_name}' to {csv_path}")

def print_coverage_table(table, table_name="Coverage Table", table_path="coverage.csv"):
    headers = ["Folder", "Covered"]
    rows = []
    for folder, covered in table.items():
        rows.append([folder, "Yes" if covered else "No"])
    print(tabulate(rows, headers=headers, tablefmt="grid"))
    
    csv_path = table_path
    with open(csv_path, mode="a", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([table_name])
        writer.writerow(headers)
        writer.writerows(rows)
    print(f"Saved table '{table_name}' to {csv_path}")

def o_level_flag(folder) -> int:
    p = Path(folder)
    if any(p.glob("*O1*.txt")):
        return 2
    if any(p.glob("*O8*.txt")):
        return 1
    return 0

def run_perf_summary_on_folder(folder_path):
    str_option = ""
    str_data = folder_path + " "
    o_level = o_level_flag(folder_path)
    for filename in sorted(os.listdir(folder_path)):
        if folder_path not in instrs_table:
            instrs_table[folder_path] = {}
            cycles_table[folder_path] = {}
        if filename.endswith('.txt') and '_O' in filename:
            O_value = extract_O_value(filename)
            if O_value is not None and o_level == 2:
                filepath = os.path.join(folder_path, filename)
                instrs_total, cycles_total = parse_perf_file(filepath)  
                str_option = str_option + str(O_value) + " "
                str_data = str_data + str(instrs_total) + " " + str(cycles_total) + " "
                instrs_table[folder_path][O_value] = instrs_total
                cycles_table[folder_path][O_value] = cycles_total
                coverage_table[folder_path] = True
            elif o_level == 1:
                coverage_table[folder_path] = True
    print(str_option)
    print(str_data)

def calculate_reductions_and_speedups():
    for folder in folders:
        instrs_reduction_table[folder] = {}
        speedup_table[folder] = {}
        if instrs_table[folder].get(1, None) is None:
            continue
        if cycles_table[folder].get(1, None) is None:
            continue
        base_instrs = instrs_table[folder].get(1, None)
        base_cycles = cycles_table[folder].get(1, None)
        for opt in options:
            if instrs_table[folder].get(opt) is None:
                instrs_reduction_table[folder][opt] = "N/A"
            elif base_instrs and instrs_table[folder][opt]:
                instrs_reduction = base_instrs / instrs_table[folder][opt]
                instrs_reduction_table[folder][opt] = round(instrs_reduction, 4)
            else:
                instrs_reduction_table[folder][opt] = "N/A"
            if cycles_table[folder].get(opt) is None:
                speedup_table[folder][opt] = "N/A"
            elif base_cycles and cycles_table[folder][opt]:
                speedup = base_cycles / cycles_table[folder][opt]
                speedup_table[folder][opt] = round(speedup, 4)
            else:
                speedup_table[folder][opt] = "N/A"

if __name__ == "__main__":
    for folder in folders:
        run_perf_summary_on_folder(folder)
    calculate_reductions_and_speedups()

    print("================================\n")
    print("\nInstructions Table:")
    #print_table(instrs_table, "Instructions Count")
    print("\nCycles Table:")
    #print_table(cycles_table, "Cycles Count")

    print("================================\n")
    print("\nInstructions Reduction Table:")
    print_table(instrs_reduction_table, "Instructions Reduction", "Figure7.csv")
    print("\nSpeedup Table:")
    print_table(speedup_table, "Speedup", "Figure8.csv")

    print("================================\n")
    print("\nCoverage Table:")
    cov_rows = [[str(k), v] for k, v in sorted(coverage_table.items(), key=lambda kv: str(kv[0]))]
    print("\n[coverage_table]")
    print_coverage_table(coverage_table, "Coverage Table", "coverage.csv")