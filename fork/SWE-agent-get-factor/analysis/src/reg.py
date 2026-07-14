import json
from utils.cloudgpt_aoai import get_chat_completion

forward_file = "/home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/trajectories/v-kenanli/ablation_reg_4o__gpt-4o-20241120__t-0.00__p-1.00__c-0.00___swe_bench_dataset/verified_50.jsonl_dev/preds.json"
oracle_file = "/home/v-kenanli/workspace/ablation/data/verified/4_verified_test_loc.jsonl"

def judge(f2p_cmd, f2p_list, pred_cmd, pred_list):
    prompt = f"""
Given ground truth test command to run required tests:
{f2p_cmd}

Given ground truth list of tests that should be run:
{f2p_list}

------------------------------------------

Given the model-predicted test command:
{pred_cmd}

Given the tests executed by the model-predicted test command:
{pred_list}

==========================================

Classify the model-predicted test command in to three categories:
`invalid`: the model-predicted test command is not the same way to run tests in the repo as the ground truth test command does. (You can tolerate minor difference like parameter or argument difference.)
`miss`: the model-predicted test command can execute, but misses all required ground truth tests.
`partial`: the model-predicted test command can execute, but only selects part of the required ground truth tests.
`correct`: the model-predicted test command can execute, and selects all the required ground truth tests -- the test command can select more tests than required, but cannot miss any required test.

Your answer should be one of `invalid`, `miss`, `partial`, `correct`. Output only one word. Now answer:
"""
    #input(prompt)
    try:
        response = get_chat_completion(model="gpt-5.6-sol-20260709", messages=[{"role": "user", "content": prompt}])
        tag = response.choices[0].message.content.lower()
    except Exception as e:
        print(e, flush=True)
        return None
    if 'invalid' in tag:
        return 'invalid'
    if 'miss' in tag:
        return 'miss'
    if 'partial' in tag:
        return 'partial'
    if 'correct' in tag:
        return 'correct'
    return None

with open(forward_file) as f:
    forward = json.load(f)

with open(oracle_file) as f:
    ds = [json.loads(i) for i in f if i.strip()]
    oracle = {i["instance_id"]: i for i in ds}


res = {}
for instance_id, instance in forward.items():
    try:
        info = json.loads(instance["model_patch"])
        assert "command" in info.keys()
        assert "pass" in info.keys()
    except:
        continue
    tag = judge(
            oracle[instance_id]["test_cmd"], 
            oracle[instance_id]["PASS_TO_PASS"],
            info["command"],
            info["pass"] + info.get("fail", []),
        )
    if tag is not None:
        print(tag, flush=True)
        res[instance_id] = tag


with open("analysis/reg-4o.json", "w") as f:
    json.dump(res, f, indent=True)