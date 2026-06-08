import json

with open("data/verified/subset/all.jsonl") as f:
    l = [json.loads(i) for i in f]

print(len(l))

todo = []

for i in l:
    api_info =  i["api"]
    valid = 0
    al = 0
    for file_path in api_info:
        for func in api_info[file_path]:
            al+=1
            if "file of api definition" in func.keys():
                # print(i["instance_id"], func)
                valid += 1
    print(valid, al)
    if al == 0: 
        continue
    if valid/al >= 0.45:
        todo.append(i)

print(len(todo))

with open("data/verified/subset/overlap.jsonl", "w") as f:
    for i in todo:
        f.write(json.dumps(i)+"\n")