#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout fb462618190e87b4f0dec0bb677bcdea40b448a7 tests/test_api.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_api.py b/tests/test_api.py
index e0cba1d02..4fc256582 100644
--- a/tests/test_api.py
+++ b/tests/test_api.py
@@ -550,6 +550,15 @@ def test_cmap():
         assert int(match) <= 100
 
 
+def test_cmap_rtl():
+    # Regression test for #378.
+    stdout = _run(
+        '--uncompressed-pdf -e utf-8 - -',
+        '<div style="font-family: weasyprint">اب'.encode())
+    assert b'<00cf> <0627>' in stdout
+    assert b'<00d0> <0628>' in stdout
+
+
 @pytest.mark.parametrize('html, fields', (
     ('<input>', ['/Tx', '/V ()']),
     ('<input value="">', ['/Tx', '/V ()']),

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout fb462618190e87b4f0dec0bb677bcdea40b448a7 tests/test_api.py
