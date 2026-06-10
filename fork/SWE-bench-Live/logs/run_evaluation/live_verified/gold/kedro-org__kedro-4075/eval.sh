#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 5ec27a365963afd3f8910434ab21ddbb7463adc6 tests/framework/cli/test_cli.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/framework/cli/test_cli.py b/tests/framework/cli/test_cli.py
index cd83c9bf21..9aa2606587 100644
--- a/tests/framework/cli/test_cli.py
+++ b/tests/framework/cli/test_cli.py
@@ -520,7 +520,7 @@ def test_main_hook_exception_handling(self, fake_metadata):
             project_metadata=kedro_cli._metadata, command_args=[], exit_code=1
         )
 
-        assert "An error has occurred: Test Exception" in result.output
+        assert result.exit_code == 1
 
     @patch("sys.exit")
     def test_main_hook_finally_block(self, fake_metadata):
@@ -535,7 +535,7 @@ def test_main_hook_finally_block(self, fake_metadata):
             project_metadata=kedro_cli._metadata, command_args=[], exit_code=0
         )
 
-        assert "An error has occurred:" not in result.output
+        assert result.exit_code == 0
 
 
 @mark.usefixtures("chdir_to_dummy_project")

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA --numprocesses 4 --dist loadfile
: '>>>>> End Test Output'
git checkout 5ec27a365963afd3f8910434ab21ddbb7463adc6 tests/framework/cli/test_cli.py
