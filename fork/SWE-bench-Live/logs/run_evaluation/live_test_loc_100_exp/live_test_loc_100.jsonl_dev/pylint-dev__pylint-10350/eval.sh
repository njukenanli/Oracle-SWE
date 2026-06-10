#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
echo "No test files to reset"
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/functional/r/regression_02/regression_10334.py b/tests/functional/r/regression_02/regression_10334.py
new file mode 100644
index 0000000000..772860846e
--- /dev/null
+++ b/tests/functional/r/regression_02/regression_10334.py
@@ -0,0 +1,6 @@
+"""Test for slice object used as a decorator."""
+# pylint: disable=too-few-public-methods
+s = slice(-2)
+@s()  # [not-callable]
+class A:
+    """Class with a slice decorator."""
diff --git a/tests/functional/r/regression_02/regression_10334.txt b/tests/functional/r/regression_02/regression_10334.txt
new file mode 100644
index 0000000000..d2baba926e
--- /dev/null
+++ b/tests/functional/r/regression_02/regression_10334.txt
@@ -0,0 +1,1 @@
+not-callable:4:1:4:4:A:s is not callable:UNDEFINED

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
echo "No test files to reset"
