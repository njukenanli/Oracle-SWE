#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 2dbc249b7d5def49aecaf8ab23d147e15ca6c63e tests/evaluate/test_evaluate.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/evaluate/test_evaluate.py b/tests/evaluate/test_evaluate.py
index faa50953d6..c8034f53a0 100644
--- a/tests/evaluate/test_evaluate.py
+++ b/tests/evaluate/test_evaluate.py
@@ -1,5 +1,6 @@
 import signal
 import threading
+from unittest.mock import patch
 
 import pytest
 
@@ -112,10 +113,9 @@ def test_evaluate_call_bad():
     assert score == 0.0
 
 
-@pytest.mark.parametrize(
-    "display_table", [True, False, 1]
-)
-def test_evaluate_display_table(display_table):
+@pytest.mark.parametrize("display_table", [True, False, 1])
+@pytest.mark.parametrize("is_in_ipython_notebook_environment", [True, False])
+def test_evaluate_display_table(display_table, is_in_ipython_notebook_environment, capfd):
     devset = [new_example("What is 1+1?", "2")]
     program = Predict("question -> answer")
     ev = Evaluate(
@@ -125,4 +125,12 @@ def test_evaluate_display_table(display_table):
     )
     assert ev.display_table == display_table
 
-    ev(program)
+    with patch(
+        "dspy.evaluate.evaluate.is_in_ipython_notebook_environment", return_value=is_in_ipython_notebook_environment
+    ):
+        ev(program)
+        out, _ = capfd.readouterr()
+        if not is_in_ipython_notebook_environment and display_table:
+            # In console environments where IPython is not available, the table should be printed
+            # to the console
+            assert "What is 1+1?" in out

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA tests/
: '>>>>> End Test Output'
git checkout 2dbc249b7d5def49aecaf8ab23d147e15ca6c63e tests/evaluate/test_evaluate.py
