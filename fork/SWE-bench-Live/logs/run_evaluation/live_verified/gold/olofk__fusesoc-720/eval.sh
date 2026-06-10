#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout d3aa7910a1e3e20c7b3489811aa649fc9ff80c19 tests/test_libraries.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_libraries.py b/tests/test_libraries.py
index b277e77b..90971f12 100644
--- a/tests/test_libraries.py
+++ b/tests/test_libraries.py
@@ -214,3 +214,36 @@ def test_library_update(caplog):
         fs.update_libraries([])
 
     assert "test_lib : sync-type is local. Ignoring update" in caplog.text
+
+
+def test_library_update_with_initialize(caplog):
+    with tempfile.TemporaryDirectory() as library:
+
+        with tempfile.NamedTemporaryFile(mode="w+") as tcf:
+            tcf.write(
+                f"""[main]
+library_root = {library}
+
+[library.vlog_tb_utils]
+location = fusesoc_libraries/vlog_tb_utils
+sync-uri = https://github.com/fusesoc/vlog_tb_utils
+sync-type = git
+auto-sync = true
+
+"""
+            )
+            tcf.flush()
+
+            conf = Config(tcf.name)
+
+        args = Namespace()
+
+        Fusesoc.init_logging(False, False)
+        fs = Fusesoc(conf)
+
+        with caplog.at_level(logging.INFO):
+            fs.update_libraries([])
+
+        assert "vlog_tb_utils does not exist. Trying a checkout" in caplog.text
+        assert "Cloning library into fusesoc_libraries/vlog_tb_utils" in caplog.text
+        assert "Updating..." in caplog.text

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout d3aa7910a1e3e20c7b3489811aa649fc9ff80c19 tests/test_libraries.py
