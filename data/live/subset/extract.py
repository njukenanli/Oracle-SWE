import json

with open("data/live/5_test_loc_context_api.jsonl") as f:
    l = [json.loads(i) for i in f]

api = {}
con = {}
overlap = {}

for i in l:
    api_info =  i["api"]
    valid = 0
    for file_path in api_info:
        for func in api_info[file_path]:
            if "file of api definition" in func.keys():
                #print(i["instance_id"], func)
                valid += 1
    if valid >= 5:
        api[i["instance_id"]] = i
    context_info = i["error_context"]
    if len(context_info) == 0:
        continue
    for context in context_info:
        if len(context["frames"]) >= 5:
            #print(i["instance_id"], json.dumps(context, indent=True))
            con[i["instance_id"]] = i
            break

for idx in api.keys():
    overlap[idx] = api[idx]

for idx in con.keys():
    overlap[idx] = con[idx]

print(len(api), len(con), len(overlap))

with open("data/live/subset/api_46.jsonl", "w") as f:
    #json.dump([i["api"] for i in api.values()],f,indent=True)
    for i in api.values():
        f.write(json.dumps(i)+"\n")

with open("data/live/subset/con_50.jsonl", "w") as f:
    #json.dump([i["error_context"] for i in con.values()],f,indent=True)
    for i in con.values():
        f.write(json.dumps(i)+"\n")
import random
with open("data/live/subset/overlap_50.jsonl", "w") as f:
    sub=random.sample(list(overlap.values()), 50)
    print(len(sub))
    for i in sub:
        f.write(json.dumps(i)+"\n")
