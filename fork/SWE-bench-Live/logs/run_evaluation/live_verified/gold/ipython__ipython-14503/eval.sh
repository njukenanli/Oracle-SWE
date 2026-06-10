#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 78fea5f8d7bf6ca55796e82ed341e7fd291878f0 IPython/core/tests/test_ultratb.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/IPython/core/tests/test_ultratb.py b/IPython/core/tests/test_ultratb.py
index e167d99506a..8ed73873aa1 100644
--- a/IPython/core/tests/test_ultratb.py
+++ b/IPython/core/tests/test_ultratb.py
@@ -298,6 +298,13 @@ class Python3ChainedExceptionsTest(unittest.TestCase):
     raise ValueError("Yikes") from None
     """
 
+    SYS_EXIT_WITH_CONTEXT_CODE = """
+try:
+    1/0
+except Exception as e:
+    raise SystemExit(1)
+    """
+
     def test_direct_cause_error(self):
         with tt.AssertPrints(["KeyError", "NameError", "direct cause"]):
             ip.run_cell(self.DIRECT_CAUSE_ERROR_CODE)
@@ -306,6 +313,11 @@ def test_exception_during_handling_error(self):
         with tt.AssertPrints(["KeyError", "NameError", "During handling"]):
             ip.run_cell(self.EXCEPTION_DURING_HANDLING_CODE)
 
+    def test_sysexit_while_handling_error(self):
+        with tt.AssertPrints(["SystemExit", "to see the full traceback"]):
+            with tt.AssertNotPrints(["another exception"], suppress=False):
+                ip.run_cell(self.SYS_EXIT_WITH_CONTEXT_CODE)
+
     def test_suppress_exception_chaining(self):
         with tt.AssertNotPrints("ZeroDivisionError"), \
              tt.AssertPrints("ValueError", suppress=False):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 78fea5f8d7bf6ca55796e82ed341e7fd291878f0 IPython/core/tests/test_ultratb.py
