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
            forward[instance["instance_id"]] = instance["api"]
            #input(forward[instance["instance_id"]].keys())
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

sum_recall = 0.0
sum_precision = 0.0
non_zero = 0

global_all_val_def = 0
global_overlap_val_def = 0
for instance_id, prediction in forward.items():
    if instance_id not in oracle.keys():
        continue
    overlap_func: set[tuple[str,str]] = set()
    oracle_func: set[tuple[str,str]] = set()
    prediction_func: set[tuple[str,str]] = set()
    prediction_def_mapping: dict[tuple[str,str], str] = {}
    all_def = 0
    overlap_def = 0
    for path in prediction.keys():
        for item in prediction[path]:
            func = get_func(item["api function name"])
            prediction_func.add((norm_path(path),get_func(item["api function name"])))
            prediction_def_mapping[(norm_path(path),get_func(item["api function name"]))] = item["file of api definition"]
    for path in oracle[instance_id]["api"].keys():
        for item in oracle[instance_id]["api"][path]:
            tpl = (norm_path(path),get_func(item["api function name"]))
            oracle_func.add(tpl)
            if item.get("file of api definition", "") and tpl in prediction_def_mapping and "test" not in item.get("file of api definition", "").lower():
                all_def += 1
                normed_oracle_def = norm_path(item["file of api definition"])
                normed_pred_def = norm_path(prediction_def_mapping[tpl])
                if normed_oracle_def in normed_pred_def or normed_pred_def in normed_oracle_def or "(" in normed_pred_def or "frozen" in normed_oracle_def:
                    overlap_def += 1
                else:
                    print(norm_path(item["file of api definition"]))
                    print(norm_path(prediction_def_mapping[tpl]))
                    print()
    #if len(res)%25 == 0:
    #    print()
    #    print(prediction_def_mapping)
    #    print(prediction_func)
    #    print(oracle_func)
    #    print()
    overlap_func = prediction_func & oracle_func
    res[instance_id] = {
        "overlap_func": len(overlap_func),
        "oracle_func": len(oracle_func),
        "prediction_func": len(prediction_func),
        "func_precision": len(overlap_func)/len(prediction_func) if len(prediction_func) > 0 else 0.0,
        "func_recall": len(overlap_func)/len(oracle_func) if len(oracle_func) > 0 else 0.0,
        "all_valid_def": all_def,
        "overlap_def": overlap_def,
        "def_recall": overlap_def/all_def if all_def > 0 else 0.0
    }
    sum_recall += res[instance_id]["func_recall"]
    sum_precision += res[instance_id]["func_precision"]
    global_all_val_def += all_def
    global_overlap_val_def += overlap_def
    if len(overlap_func) > 0:
        non_zero += 1
    #print(res[instance_id])

with open("analysis/api.json", "w") as f:
    json.dump(res, f, indent=True)

print(f"Avg recall: {sum_recall/len(res)}, excluding zero-hit instances: {sum_recall/non_zero}")
print(f"Avg precision: {sum_precision/len(res)}, excluding zero-hit instances: {sum_precision/non_zero}")
print(global_overlap_val_def/global_all_val_def)