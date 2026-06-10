#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a3e5bef359ae1d5359fe8649aba9f12f8e3fd5c8 tests/functional/c/consider/consider_using_f_string.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/functional/c/consider/consider_using_f_string.py b/tests/functional/c/consider/consider_using_f_string.py
index 086fb3f875..d40b417400 100644
--- a/tests/functional/c/consider/consider_using_f_string.py
+++ b/tests/functional/c/consider/consider_using_f_string.py
@@ -128,3 +128,11 @@ def wrap_print(value):
         print(value)
 
     wrap_print(value="{}".format)
+
+
+def invalid_format_string_good():
+    """Should not raise message when `.format` is called with an invalid format string."""
+    # pylint: disable=bad-format-string
+    print("{a[0] + a[1]}".format(a=[0, 1]))
+    print("{".format(a=1))
+    print("{".format(1))

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a3e5bef359ae1d5359fe8649aba9f12f8e3fd5c8 tests/functional/c/consider/consider_using_f_string.py
