#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 816d219c04b2bdb7de81081fa14eac63000dac30 keras/src/ops/linalg_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/keras/src/ops/linalg_test.py b/keras/src/ops/linalg_test.py
index bc04ab0b0d26..8e722dd4125b 100644
--- a/keras/src/ops/linalg_test.py
+++ b/keras/src/ops/linalg_test.py
@@ -534,6 +534,10 @@ def test_svd(self):
         # High tolerance due to numerical instability
         self.assertAllClose(x_reconstructed, x, atol=1e-3)
 
+        # Test `compute_uv=False`
+        s_no_uv = linalg.svd(x, compute_uv=False)
+        self.assertAllClose(s_no_uv, s)
+
     @parameterized.named_parameters(
         ("b_rank_1", 1, None),
         ("b_rank_2", 2, None),

EOF_114329324912
: '>>>>> Start Test Output'
SKIP_APPLICATIONS_TESTS=True pytest -rA keras
: '>>>>> End Test Output'
git checkout 816d219c04b2bdb7de81081fa14eac63000dac30 keras/src/ops/linalg_test.py
