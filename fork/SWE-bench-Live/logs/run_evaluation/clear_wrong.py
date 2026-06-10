import os
import json
import shutil

base_dir = "/home/v-kenanli/workspace/ablation/fork/SWE-bench-Live/logs/run_evaluation/live_test_loc_100_4o/live_test_loc_100.jsonl_dev"

# iterate {instance_id}/report.json 
# if report.json not exists, delete instance_id folder -r
# with open(report.json) as f:
#   d = json.load(f)
#   if d[instance_id]["resolved"] == False:
#       delete instance_id folder -r

# Iterate through all subdirectories in base_dir
for instance_id in os.listdir(base_dir):
    instance_path = os.path.join(base_dir, instance_id)
    
    # Skip if not a directory
    if not os.path.isdir(instance_path):
        continue
    
    report_path = os.path.join(instance_path, "report.json")
    
    # If report.json doesn't exist, delete the instance folder
    if not os.path.exists(report_path):
        print(f"Deleting {instance_id} (no report.json found)")
        shutil.rmtree(instance_path)
        continue
    
    # If report.json exists, check if resolved is False
    try:
        with open(report_path, 'r') as f:
            d = json.load(f)
            if instance_id in d and d[instance_id].get("resolved") == False:
                print(f"Deleting {instance_id} (resolved=False)")
                shutil.rmtree(instance_path)
    except (json.JSONDecodeError, KeyError) as e:
        print(f"Error reading {report_path}: {e}")
        shutil.rmtree(instance_path)
        continue