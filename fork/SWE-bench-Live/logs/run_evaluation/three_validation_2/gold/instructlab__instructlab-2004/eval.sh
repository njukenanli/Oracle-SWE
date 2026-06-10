#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e8097167e0f70e887cc7aa8b9eaeabacbff6ed6a tests/testdata/default_config.yaml
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/testdata/default_config.yaml b/tests/testdata/default_config.yaml
index 30a7d4503d..32e04275b0 100644
--- a/tests/testdata/default_config.yaml
+++ b/tests/testdata/default_config.yaml
@@ -48,9 +48,9 @@ generate:
       max_ctx_size: 4096
     model_path: /cache/instructlab/models/merlinite-7b-lab-Q4_K_M.gguf
     vllm:
+      gpus: null
       llm_family: ''
       max_startup_attempts: 300
-      gpus: null
       vllm_args: []
 serve:
   backend: null
@@ -62,12 +62,13 @@ serve:
     max_ctx_size: 4096
   model_path: /cache/instructlab/models/merlinite-7b-lab-Q4_K_M.gguf
   vllm:
+    gpus: null
     llm_family: ''
     max_startup_attempts: 300
-    gpus: null
     vllm_args: []
 train:
   additional_args: {}
+  checkpoint_at_epoch: false
   ckpt_output_dir: /data/instructlab/checkpoints
   data_output_dir: /data/instructlab/internal
   data_path: /data/instructlab/datasets

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout e8097167e0f70e887cc7aa8b9eaeabacbff6ed6a tests/testdata/default_config.yaml
