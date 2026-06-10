#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 832ebf0f1cec31d294b12a67b6a7e199ed22882e tests/testdata/default_config.yaml
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/testdata/default_config.yaml b/tests/testdata/default_config.yaml
index b50ca4c2e6..6af3d2aa50 100644
--- a/tests/testdata/default_config.yaml
+++ b/tests/testdata/default_config.yaml
@@ -332,6 +332,9 @@ train:
   # Number of samples the model should see before saving a checkpoint.
   # Default: 250000
   save_samples: 250000
+  # Optional path to a yaml file that tracks the progress of multiphase training.
+  # Default: None
+  training_journal:
 # Configuration file structure version.
 # Default: 1.0.0
 version: 1.0.0

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 832ebf0f1cec31d294b12a67b6a7e199ed22882e tests/testdata/default_config.yaml
