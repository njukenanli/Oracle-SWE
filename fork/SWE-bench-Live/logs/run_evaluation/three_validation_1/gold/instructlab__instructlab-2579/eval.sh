#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a30b177e0c7f022f3ea63323dbd427401b371d92 tests/test_lab_init.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_lab_init.py b/tests/test_lab_init.py
index cf0107b5f3..05d442289b 100644
--- a/tests/test_lab_init.py
+++ b/tests/test_lab_init.py
@@ -59,6 +59,21 @@ def test_ilab_config_init_auto_detection_cpu(
             in result.stdout
         )
 
+    @patch(
+        "instructlab.config.init.get_gpu_or_cpu",
+        return_value=("intel gaudi 3", False, True),
+    )
+    def test_ilab_config_init_auto_detection_gaudi(
+        self, convert_bytes_to_proper_mag_mock, cli_runner: CliRunner
+    ):
+        result = cli_runner.invoke(lab.ilab, ["config", "init", "--interactive"])
+        assert result.exit_code == 0, result.stdout
+        convert_bytes_to_proper_mag_mock.assert_called_once()
+        assert (
+            "We have detected the INTEL GAUDI 3 profile as an exact match for your system."
+            in result.stdout
+        )
+
     # When using `from X import Y` you need to understand that Y becomes part
     # of your module, so you should use `my_module.Y`` to patch.
     # When using `import X`, you should use `X.Y` to patch.

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a30b177e0c7f022f3ea63323dbd427401b371d92 tests/test_lab_init.py
