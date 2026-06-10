#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 10a008fac10e2eb7dd343c128cbf2e0f971fa993 keras/src/layers/attention/multi_head_attention_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/keras/src/layers/attention/multi_head_attention_test.py b/keras/src/layers/attention/multi_head_attention_test.py
index 979f9cd78a3f..c4bcdc0fb04f 100644
--- a/keras/src/layers/attention/multi_head_attention_test.py
+++ b/keras/src/layers/attention/multi_head_attention_test.py
@@ -148,6 +148,10 @@ def test_shape_mismatch_error(self, query_shape, value_shape, key_shape):
         )
         with self.assertRaisesRegex(ValueError, r"must be equal"):
             layer.compute_output_shape(query_shape, value_shape, key_shape)
+        with self.assertRaisesRegex(ValueError, r"must be equal"):
+            layer(
+                np.ones(query_shape), np.ones(value_shape), np.ones(key_shape)
+            )
 
     def test_initializer(self):
         # Test with a specified initializer.

EOF_114329324912
: '>>>>> Start Test Output'
SKIP_APPLICATIONS_TESTS=True pytest keras -rA
: '>>>>> End Test Output'
git checkout 10a008fac10e2eb7dd343c128cbf2e0f971fa993 keras/src/layers/attention/multi_head_attention_test.py
