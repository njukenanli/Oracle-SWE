```bash
pip install .

python -m swebench.harness.run_evaluation     --dataset_name /home/v-kenanli/workspace/ablation/data/verified/3_verified_test_cmd_content.jsonl     --split test     --namespace swebench     --predictions_path ...     --max_workers 8     --run_id  ... > log_.out 2>&1

python -m swebench.harness.run_evaluation     --dataset_name /home/v-kenanli/workspace/ablation/data/live/3_verified_test_loc.jsonl     --split test     --namespace starryzhang     --predictions_path logs/preds/live_con_50_claude.json      --max_workers 4     --run_id live_con_50_claude > log_live_con_50_claude.out 2>&1

```