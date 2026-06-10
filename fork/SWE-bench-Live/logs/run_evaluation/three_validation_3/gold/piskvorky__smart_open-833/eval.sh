#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 8a58abe5e751af5b72e219e1bf3a90bb54e13b12 smart_open/tests/test_smart_open.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/smart_open/tests/test_smart_open.py b/smart_open/tests/test_smart_open.py
index e31f48b7..789f44c6 100644
--- a/smart_open/tests/test_smart_open.py
+++ b/smart_open/tests/test_smart_open.py
@@ -607,6 +607,22 @@ def test_atplus(self):
         self.assertEqual(text, SAMPLE_TEXT * 2)
 
 
+class CompressionRealFileSystemTests(RealFileSystemTests):
+    """Same as RealFileSystemTests but with a compressed file."""
+
+    def setUp(self):
+        with named_temporary_file(prefix='test', suffix='.zst', delete=False) as fout:
+            self.temp_file = fout.name
+        with smart_open.open(self.temp_file, 'wb') as fout:
+            fout.write(SAMPLE_BYTES)
+
+    def test_aplus(self):
+        pass  # transparent (de)compression unsupported for mode 'ab+'
+
+    def test_atplus(self):
+        pass  # transparent (de)compression unsupported for mode 'ab+'
+
+
 #
 # What exactly to patch here differs on _how_ we're opening the file.
 # See the _shortcut_open function for details.

EOF_114329324912
: '>>>>> Start Test Output'
pytest -v -rA smart_open
: '>>>>> End Test Output'
git checkout 8a58abe5e751af5b72e219e1bf3a90bb54e13b12 smart_open/tests/test_smart_open.py
