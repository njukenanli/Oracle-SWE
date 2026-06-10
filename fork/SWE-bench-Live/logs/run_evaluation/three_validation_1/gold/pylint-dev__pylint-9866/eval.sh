#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
echo "No test files to reset"
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/functional/r/regression/regression_9865_calling_bound_lambda.py b/tests/functional/r/regression/regression_9865_calling_bound_lambda.py
new file mode 100644
index 0000000000..2a8dae1b0b
--- /dev/null
+++ b/tests/functional/r/regression/regression_9865_calling_bound_lambda.py
@@ -0,0 +1,8 @@
+"""Regression for https://github.com/pylint-dev/pylint/issues/9865."""
+# pylint: disable=missing-docstring,too-few-public-methods,unnecessary-lambda-assignment
+class C:
+    eq = lambda self, y: self == y
+
+def test_lambda_method():
+    ret = C().eq(1)
+    return ret

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
echo "No test files to reset"
