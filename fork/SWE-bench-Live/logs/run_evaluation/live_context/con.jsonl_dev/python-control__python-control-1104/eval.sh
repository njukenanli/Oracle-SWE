#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 71bd7319fe324f7b7ff14b8210420843bf06d7d2 control/tests/nyquist_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/control/tests/nyquist_test.py b/control/tests/nyquist_test.py
index 0d6907b64..8d6fd8561 100644
--- a/control/tests/nyquist_test.py
+++ b/control/tests/nyquist_test.py
@@ -517,6 +517,15 @@ def test_nyquist_frd():
     warnings.resetwarnings()
 
 
+def test_no_indent_pole():
+    s = ct.tf('s')
+    sys = ((1 + 5/s)/(1 + 0.5/s))**2   # Double-Lag-Compensator
+
+    with pytest.raises(RuntimeError, match="evaluate at a pole"):
+        resp = ct.nyquist_response(
+            sys, warn_encirclements=False, indent_direction='none')
+
+
 if __name__ == "__main__":
     #
     # Interactive mode: generate plots for manual viewing

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 71bd7319fe324f7b7ff14b8210420843bf06d7d2 control/tests/nyquist_test.py
