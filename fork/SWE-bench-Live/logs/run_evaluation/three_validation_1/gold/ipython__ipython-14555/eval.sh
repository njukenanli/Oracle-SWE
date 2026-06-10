#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 02545e95585fa222f9e83b83161e6af4065fd6f7 IPython/core/tests/test_prefilter.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/IPython/core/tests/test_prefilter.py b/IPython/core/tests/test_prefilter.py
index 999cd43e6e8..379a530e8e5 100644
--- a/IPython/core/tests/test_prefilter.py
+++ b/IPython/core/tests/test_prefilter.py
@@ -137,3 +137,13 @@ def test_autocall_should_support_unicode():
     finally:
         ip.run_line_magic("autocall", "0")
         del ip.user_ns["π"]
+
+
+def test_autocall_regression_gh_14513():
+    ip.run_line_magic("autocall", "2")
+    ip.user_ns["foo"] = dict()
+    try:
+        assert ip.prefilter("foo") == "foo"
+    finally:
+        ip.run_line_magic("autocall", "0")
+        del ip.user_ns["foo"]

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 02545e95585fa222f9e83b83161e6af4065fd6f7 IPython/core/tests/test_prefilter.py
