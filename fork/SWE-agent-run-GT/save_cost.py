import os, json

base = "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/trajectories"

def trav(folder: str):
    for sub in os.listdir(folder):
        path = f"{folder}/{sub}"
        if os.path.isdir(path):
            trav(path)
        if os.path.isfile(path) and path.endswith(".traj"):
            #if os.path.exists(f"{folder}/cost.json"):
            #    return
            try:
                with open(path) as f:
                    d=json.load(f)
                res = {
                    "info":{
                        "exit_status": d["info"]["exit_status"],
                        "model_stats": d["info"]["model_stats"],
                    }
                }
                with open(f"{folder}/cost.json", "w") as f:
                    json.dump(res, f, indent=True)
            except:
                pass
            print(path)
            return

trav(base)