import json

with open("data/pro/pyt/5_test_loc_context_api.jsonl") as f:
    l = [json.loads(i) for i in f]

api = {}

for i in l:
    api_info =  i["api"]
    valid = 0
    for file_path in api_info:
        for func in api_info[file_path]:
            if "file of api definition" in func.keys():
                valid += 1
    if valid >= 3:
        api[i["instance_id"]] = i


print(len(api))

with open("data/pro/pyt/subset/api.jsonl", "w") as f:
    for i in api.values():
        f.write(json.dumps(i)+"\n")
