#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
echo "No test files to reset"
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/functional/r/regression/regression_9875_enumerate.py b/tests/functional/r/regression/regression_9875_enumerate.py
new file mode 100644
index 0000000000..1eca3f7811
--- /dev/null
+++ b/tests/functional/r/regression/regression_9875_enumerate.py
@@ -0,0 +1,7 @@
+"""https://github.com/pylint-dev/pylint/issues/9875"""
+# value = 0
+for idx, value in enumerate(iterable=[1, 2, 3]):
+    print(f'{idx=} {value=}')
+# +1: [undefined-loop-variable, undefined-loop-variable]
+for idx, value in enumerate(iterable=[value-1, value-2*1]):
+    print(f'{idx=} {value=}')
diff --git a/tests/functional/r/regression/regression_9875_enumerate.txt b/tests/functional/r/regression/regression_9875_enumerate.txt
new file mode 100644
index 0000000000..dad9a0f0aa
--- /dev/null
+++ b/tests/functional/r/regression/regression_9875_enumerate.txt
@@ -0,0 +1,2 @@
+undefined-loop-variable:6:38:6:43::Using possibly undefined loop variable 'value':UNDEFINED
+undefined-loop-variable:6:47:6:52::Using possibly undefined loop variable 'value':UNDEFINED

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
echo "No test files to reset"
