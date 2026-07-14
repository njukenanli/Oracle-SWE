import json
import os
from utils.cloudgpt_aoai import get_chat_completion
from utils.runtime import SetupRuntime

forward_files = [
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_verified_gpt5.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl",
    "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_go_cl46.jsonl",
]
oracle_files = [
    "/home/v-kenanli/workspace/ablation/data/verified/3_verified_test_cmd_content.jsonl",
    "/home/v-kenanli/workspace/ablation/data/live/3_verified_test_loc.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/pyt/3_test_loc.jsonl",
    "/home/v-kenanli/workspace/ablation/data/pro/go/3_test_loc.jsonl",
]

def valid(desc, oracle_test, pred_test, out):
    prompt = f"""
Given a GitHub issue description:
{desc}

Given the ground truth test case to reproduce the issue or test whether the requirements in the description is met:
{oracle_test}

-----------------------------------------------------------

Given the model-predicted test case to reproduce the issue or test whether the requirements in the description is met:
{pred_test}

Given the execution output of the model-written test case:
{out}

===========================================================

Do you think the model-written test case successfully reproduce the issue or successfully test the unsatisfied requirements in the issue description?
Do you think the model-written test cases have tested all the corner cases / scenarios that ground truth test cases include? (The input values of the test cases do not need to be the same for the ground truth and the model prediction. You should judge from the meaning of the ground truth test and the model-predited test to see if the model-predited test involve all corner cases / scenarios that ground truth tests include.)
Your answer should be one of:
`failed`: The model-written test case failed to reproduce the issue or failed to test the unsatisfied requirements in the issue description, when compared to the issue description and ground truth test case implementation. Or the model-predicted test fails to cover even one case / scenario included in the ground truth test.
`partial`: The model-written test case can successfully reproduce the issue, but the model-predicted test fails to cover some of the corner cases / scenarios included in the ground truth test.
`success`: The model-written test case can successfully reproduce the issue and the model-predicted test successfully covers all corner cases / scenarios included in the ground truth test.
You should answer with one of `failed`, `partial` or `success`. Your answer should be ONLY one word. Now answer:
"""
    #input(prompt)
    try:
        response = get_chat_completion(model="gpt-5.6-sol-20260709", messages=[{"role": "user", "content": prompt}])
        tag = response.choices[0].message.content.lower()
    except Exception as e:
        print(e, flush=True)
        return None
    if 'failed' in tag:
        return 'failed'
    if 'partial' in tag:
        return 'partial'
    if 'success' in tag:
        return 'success'
    return None

forward = {}
oracle = {}
for filename in forward_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            instance["task_type"] = "pro" if "pro" in filename else ("live" if "live" in filename else "verified")
            forward[instance["instance_id"]] = instance
for filename in oracle_files:
    with open(filename) as f:
        for line in f:
            instance = json.loads(line)
            instance["task_type"] = "pro" if "pro" in filename else ("live" if "live" in filename else "verified")
            oracle[instance["instance_id"]] = instance

res = {}
for instance_id, pred in forward.items():
    output = None
    if os.path.exists(f"logs/{instance_id}"):
        with open(f"logs/{instance_id}") as f:
            output = f.read()
    else:
        if pred["task_type"] == "pro":
            image = oracle[instance_id]["image"]
        elif pred["task_type"] == "live":
            image = f"starryzhang/sweb.eval.x86_64.{instance_id}".replace("__", "_1776_").lower()
        else:
            image = f"swebench/sweb.eval.x86_64.{instance_id}".replace("__", "_1776_")
        if pred["task_type"] == "pro":
            container = SetupRuntime.from_launch_image(image, instance_id, "linux", None, "/app")
        else:
            container = SetupRuntime.from_launch_image(image, instance_id, "linux", "/bin/bash", "/testbed")
        container.send_command(f"""git apply - <<'NEW_PATCH'\n{pred["test_patch"]}\nNEW_PATCH""")
        output = container.send_command(pred["f2p_cmd"]).output
        container.cleanup()
        with open(f"logs/{instance_id}", "w") as f:
            f.write(output)
    assert output is not None
    val = valid(oracle[instance_id]["problem_statement"], oracle[instance_id]["F2P_content"], pred["test_patch"], output)
    if val is None:
        continue
    elif val == 'failed':
        res[instance_id] = 'failed'
    elif val == 'partial':
        res[instance_id] = 'partial'
    elif val == 'success':
        res[instance_id] = 'success'
    print(res[instance_id], flush=True)

with open("analysis/rep.json", "w") as f:
    json.dump(res, f, indent=True)
