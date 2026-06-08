import json

l=[]
with open("/home/v-rongzhili/code/ablation/data/pro/go/4_test_loc_api_old.jsonl") as f:
    for i in f:
        try:
            if len(i)>=500*1024:
                print(1)
                continue
            print(0, end=" ")
            l.append(json.loads(i))
        except:
            pass

with open("/home/v-rongzhili/code/ablation/data/pro/go/4_test_loc_api.jsonl", "w") as f:
    for i in l:
        f.write(json.dumps(i)+"\n")

'''
print(len(l))

todo = []

for instance in l:
    api_info = instance["api"]
    c=0
    for file in api_info.keys():
        for api in api_info[file]:
            if api.get("lineno of api definition", "") and api.get("api function definition", "Not available.") != "Not available.":
                c+=1
                break
    if c>=2:
        print(c, end=" ")
        todo.append(instance)
print(len(todo))

with open("/home/v-rongzhili/code/ablation/data/pro/go/subset/test_loc_api.jsonl", "w") as f:
    for i in todo:
        f.write(json.dumps(i)+"\n")
'''