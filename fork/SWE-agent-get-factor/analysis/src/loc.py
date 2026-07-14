import json

def parse(line):
    start, end = line.split("(start lineno: ")[-1].split(", end lineno: ")
    end = end.strip().strip(")")
    return int(start), int(end)

def merge_intervals(ranges: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """Return sorted, non-overlapping inclusive intervals.

    Empty intervals (where the end precedes the start) do not represent any
    lines and are ignored.
    """
    merged: list[tuple[int, int]] = []

    for start, end in sorted(interval for interval in ranges if interval[0] <= interval[1]):
        if not merged or start > merged[-1][1]:
            merged.append((start, end))
            continue

        previous_start, previous_end = merged[-1]
        merged[-1] = (previous_start, max(previous_end, end))

    return merged

def overlap(prediction_ranges: list[tuple[int, int]], oracle_ranges: list[tuple[int, int]]) -> int:
    '''
    return number of lines that overlap
    '''
    predictions = merge_intervals(prediction_ranges)
    oracles = merge_intervals(oracle_ranges)
    prediction_index = 0
    oracle_index = 0
    overlap_count = 0

    while prediction_index < len(predictions) and oracle_index < len(oracles):
        prediction_start, prediction_end = predictions[prediction_index]
        oracle_start, oracle_end = oracles[oracle_index]

        overlap_start = max(prediction_start, oracle_start)
        overlap_end = min(prediction_end, oracle_end)
        if overlap_start <= overlap_end:
            overlap_count += overlap_end - overlap_start + 1

        if prediction_end < oracle_end:
            prediction_index += 1
        else:
            oracle_index += 1

    return overlap_count

def count_distance(ranges: list[tuple[int, int]]) -> int:
    s = 0
    for i in ranges:
        diff = i[1] - i[0] + 1
        if diff > 0:
            s += diff
    return s

forward_files = [
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_verified_gpt5.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_go_cl46.jsonl",
]
oracle_files = [
    "/home/v-kenanli/workspace/ablation/data/verified/4_verified_test_loc.jsonl",
    "/home/v-kenanli/workspace/ablation/data/live/3_verified_test_loc.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/pyt/3_test_loc.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/go/3_test_loc.jsonl",
]

forward = {}
oracle = {}
for filename in forward_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            raw_loc = instance["location"]
            forward[instance["instance_id"]] = {
                k: eval(v.replace("line number range ", "")) for k, v in raw_loc.items()
            }
            #input(forward[instance["instance_id"]])
for filename in oracle_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            oracle[instance["instance_id"]] = instance

res = {}

for instance_id, pred in forward.items():
    overlap_file = 0
    oracle_file = 0
    prediction_file = 0
    overlap_line = 0
    oracle_line = 0
    prediction_line = 0
    for path, line_ranges in oracle[instance_id]["location"].items():
        oracle_file += 1
        norm_ranges = []
        for line_range in line_ranges:
            norm_ranges.append(parse(line_range))
        norm_ranges = merge_intervals(norm_ranges)
        cur_oracle_line = count_distance(norm_ranges)
        oracle_line += cur_oracle_line
        if path in forward[instance_id].keys():
            overlap_file += 1
            overlap_count = overlap(forward[instance_id][path], norm_ranges)
            overlap_line += overlap_count
    for path in forward[instance_id].keys():
        prediction_file += 1
        norm_ranges = merge_intervals(forward[instance_id][path])
        prediction_line += count_distance(norm_ranges)
    res[instance_id] = {
        "overlap_file": overlap_file,
        "oracle_file": oracle_file,
        "prediction_file": prediction_file,
        "overlap_line": overlap_line,
        "oracle_line": oracle_line,
        "prediction_line": prediction_line,
        "file_precision": overlap_file/prediction_file if prediction_file > 0 else 0.0,
        "file_recall": overlap_file/oracle_file if oracle_file > 0 else 0.0,
        "line_precision": overlap_line/prediction_line if prediction_line > 0 else 0.0,
        "line_recall": overlap_line/oracle_line if oracle_line > 0 else 0.0,
    }

with open("analysis/loc.json", "w") as f:
    json.dump(res, f, indent=True)