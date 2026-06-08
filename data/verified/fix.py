import json

def fix_one(instance):
    flag = False
    f2p_cmd = instance["f2p_cmd"].strip().split()
    f2p_parsed = instance["f2p_parsed"]
    for i in range(len(f2p_cmd)):
        comps = f2p_cmd[i].strip().split(".")
        if len(comps) >= 2 and comps[-1] == comps[-2]:
            print(f2p_cmd)
            comps = comps[:-1]
            flag = True
            f2p_cmd[i] = ".".join(comps)
    f2p_cmd = "  ".join(f2p_cmd)
    for i in range(len(f2p_parsed)):
        comps = f2p_parsed[i].strip().split(".")
        if len(comps) >= 2 and comps[-1] == comps[-2]:
            comps = comps[:-1]
            f2p_parsed[i] = ".".join(comps)
            flag = True
    if flag:
        print(f2p_cmd, f2p_parsed)
        print("\n\n\n\n\n")
        instance["f2p_cmd"]=f2p_cmd
        instance["f2p_parsed"]=f2p_parsed
    return instance

base = "/home/v-kenanli/workspace/ablation/data/verified/4_verified_test_loc.jsonl"

with open(base) as f:
    l = [json.loads(i) for i in f]
    for i in range(len(l)):
        l[i]=fix_one(l[i])

with open(base, "w") as f:
    for i in l:
        f.write(json.dumps(i)+"\n")