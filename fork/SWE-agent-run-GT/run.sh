#nohup sweagent run-batch     --config config/sampler/ablation_loc_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_loc_1.out 2>&1 &
#sleep 10
#nohup sweagent run-batch     --config config/sampler/ablation_loc_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_loc_2.out 2>&1 &
#sleep 60
nohup sweagent run-batch     --config config/sampler/ablation_loc_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_loc_3.out 2>&1 &
sleep 60


nohup sweagent run-batch     --config config/sampler/ablation_rep_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_rep_1.out 2>&1 &
sleep 120
nohup sweagent run-batch     --config config/sampler/ablation_rep_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_rep_2.out 2>&1 &
sleep 60
nohup sweagent run-batch     --config config/sampler/ablation_rep_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-run-GT/dataset/pro_test_loc_50.jsonl  > log_abl_pro_rep_3.out 2>&1 &
sleep 120

#==============================================================
nohup sweagent run-batch     --config config/sampler/forward_api_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_api_1.out 2>&1 &
sleep 60
nohup sweagent run-batch     --config config/sampler/forward_api_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_api_2.out 2>&1 &
sleep 120
nohup sweagent run-batch     --config config/sampler/forward_api_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_api_3.out 2>&1 &
sleep 120


nohup sweagent run-batch     --config config/sampler/forward_rep_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_rep_1.out 2>&1 &
sleep 60
nohup sweagent run-batch     --config config/sampler/forward_rep_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_rep_2.out 2>&1 &
sleep 120
nohup sweagent run-batch     --config config/sampler/forward_rep_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_cl46.jsonl  > log_for_pro_rep_3.out 2>&1 &

#==============================================================

nohup sweagent run-batch     --config config/sampler/forward_loc_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_loc_1.out 2>&1 &
sleep 120
nohup sweagent run-batch     --config config/sampler/forward_loc_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_loc_2.out 2>&1 &
sleep 120
nohup sweagent run-batch     --config config/sampler/forward_loc_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_loc_3.out 2>&1 &
sleep 60

nohup sweagent run-batch     --config config/sampler/forward_con_1.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_con_1.out 2>&1 &
sleep 180
nohup sweagent run-batch     --config config/sampler/forward_con_2.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_con_2.out 2>&1 &
sleep 180
nohup sweagent run-batch     --config config/sampler/forward_con_3.yaml     --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_live_cl46.jsonl  > log_for_live_con_3.out 2>&1 &
sleep 180

#====================================================

#nohup sweagent run-batch     --config config/forward/ablation_loc.yaml    --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_gpt5.jsonl  > log_for_pro_loc_gpt5_to_gpt5.out 2>&1 &
#sleep 180
nohup sweagent run-batch     --config config/forward/ablation_rep.yaml    --num_workers 1     --instances.type swe_bench     --instances.subset /home/v-kenanli/workspace/ablation/fork/SWE-agent-get-factor/dataset/forward_pro_pyt_gpt5.jsonl  > log_for_pro_rep_gpt5_to_gpt5.out 2>&1 &