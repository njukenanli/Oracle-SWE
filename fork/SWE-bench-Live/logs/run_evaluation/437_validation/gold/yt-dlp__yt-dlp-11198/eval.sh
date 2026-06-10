#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 983c58fb7a809d827b5821d493819da954f2c00b test/test_utils.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/test_utils.py b/test/test_utils.py
index 4f5fa1e100af..d4b846f56fba 100644
--- a/test/test_utils.py
+++ b/test/test_utils.py
@@ -221,9 +221,10 @@ def test_sanitize_ids(self):
         self.assertEqual(sanitize_filename('N0Y__7-UOdI', is_id=True), 'N0Y__7-UOdI')
 
     def test_sanitize_path(self):
-        if sys.platform != 'win32':
-            return
+        with unittest.mock.patch('sys.platform', 'win32'):
+            self._test_sanitize_path()
 
+    def _test_sanitize_path(self):
         self.assertEqual(sanitize_path('abc'), 'abc')
         self.assertEqual(sanitize_path('abc/def'), 'abc\\def')
         self.assertEqual(sanitize_path('abc\\def'), 'abc\\def')
@@ -256,6 +257,11 @@ def test_sanitize_path(self):
         self.assertEqual(sanitize_path('./abc'), 'abc')
         self.assertEqual(sanitize_path('./../abc'), '..\\abc')
 
+        self.assertEqual(sanitize_path('\\abc'), '\\abc')
+        self.assertEqual(sanitize_path('C:abc'), 'C:abc')
+        self.assertEqual(sanitize_path('C:abc\\..\\'), 'C:..')
+        self.assertEqual(sanitize_path('C:\\abc:%(title)s.%(ext)s'), 'C:\\abc#%(title)s.%(ext)s')
+
     def test_sanitize_url(self):
         self.assertEqual(sanitize_url('//foo.bar'), 'http://foo.bar')
         self.assertEqual(sanitize_url('httpss://foo.bar'), 'https://foo.bar')

EOF_114329324912
: '>>>>> Start Test Output'
python3 devscripts/run_tests.py --pytest-args="-rA"
: '>>>>> End Test Output'
git checkout 983c58fb7a809d827b5821d493819da954f2c00b test/test_utils.py
