import json

forward_files = [
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_verified_gpt5.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_go_cl46.jsonl",
]
oracle_files = [
    "/home/v-kenanli/workspace/ablation/data/verified/7_test_loc_context_api_injected.jsonl",
    "/home/v-kenanli/workspace/ablation/data/live/6_test_loc_context_api_injected.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/pyt/6_test_loc_context_api_injected.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/go/5_test_loc_context_api.jsonl",
]

forward = {}
oracle = {}
for filename in forward_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            forward[instance["instance_id"]] = instance["error_context"]
            #print(type(forward[instance["instance_id"]]), len(forward[instance["instance_id"]]), len(forward[instance["instance_id"]][0]))
            #input()
for filename in oracle_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            oracle[instance["instance_id"]] = instance

res = {}

def norm_path(path):
    return path.strip().strip("/").strip(".").removeprefix("testbed/").removeprefix("app/")

def get_func(path):
    return path.strip().strip("/").strip(".").strip("/").split("/")[-1].split(".")[-1]

for instance_id, prediction in forward.items():
    overlap_file: set[str] = set()
    oracle_file: set[str] = set()
    prediction_file: set[str] = set()
    overlap_func: set[str] = set()
    oracle_func: set[str] = set()
    prediction_func: set[str] = set()
    if instance_id not in oracle.keys():
        continue
    for stack in prediction:
        for frame in stack:
            path = norm_path(frame[0])
            func = get_func(frame[2])
            prediction_file.add(path)
            if "module" not in func:
                prediction_func.add((path, func))
    for stack in oracle[instance_id]["error_context"]:
        for frame in reversed(stack):
            path = norm_path(frame[0])
            if "test" in path.lower():
                break
            func = get_func(frame[2])
            oracle_file.add(path)
            if func != "<module>":
                oracle_func.add((path, func))
    #if len(res)%25 == 0:
    #    print(instance_id)
    #    print(prediction_file)
    #    print(prediction_func)
    #    print()
    #    print(oracle_file)
    #    print(oracle_func)
    #    print()
    overlap_file = prediction_file & oracle_file
    overlap_func = prediction_func & oracle_func
    res[instance_id] = {
        "overlap_file": len(overlap_file),
        "oracle_file": len(oracle_file),
        "prediction_file": len(prediction_file),
        "overlap_func": len(overlap_func),
        "oracle_func": len(oracle_func),
        "prediction_func": len(prediction_func),
        "file_precision": len(overlap_file)/len(prediction_file) if len(prediction_file) > 0 else 0.0,
        "file_recall": len(overlap_file)/len(oracle_file) if len(oracle_file) > 0 else 0.0,
        "func_precision": len(overlap_func)/len(prediction_func) if len(prediction_func) > 0 else 0.0,
        "func_recall": len(overlap_func)/len(oracle_func) if len(oracle_func) > 0 else 0.0,
    }

with open("analysis/con.json", "w") as f:
    json.dump(res, f, indent=True)