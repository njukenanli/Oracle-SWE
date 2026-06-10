#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 036016004c5a2805b977b268af39313d6e7d5700 tests/config/test_omegaconf_config.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/config/test_omegaconf_config.py b/tests/config/test_omegaconf_config.py
index 1eb4d70cb8..b227da461e 100644
--- a/tests/config/test_omegaconf_config.py
+++ b/tests/config/test_omegaconf_config.py
@@ -352,6 +352,39 @@ def test_same_key_in_same_dir(self, tmp_path, base_config):
         with pytest.raises(ValueError, match=pattern):
             OmegaConfigLoader(str(tmp_path))["catalog"]
 
+    @use_config_dir
+    def test_same_namespace_different_key_in_same_dir(self, tmp_path):
+        """Check no error if 2 files in the same config dir contain
+        the same top-level key but different subkeys"""
+
+        dup_yaml_1 = tmp_path / _BASE_ENV / "parameters_1.yml"
+        dup_yaml_2 = tmp_path / _BASE_ENV / "parameters_2.yml"
+        config_1 = {"namespace1": {"class1": {"key1": "value1_1", "key2": "value1_2"}}}
+        config_2 = {"namespace1": {"class2": {"key1": "value2_1", "key2": "value2_2"}}}
+
+        _write_yaml(dup_yaml_1, config_1)
+        _write_yaml(dup_yaml_2, config_2)
+
+        conf = OmegaConfigLoader(
+            str(tmp_path), base_env=_BASE_ENV, default_run_env=_DEFAULT_RUN_ENV
+        )["parameters"]
+        assert (
+            OmegaConf.select(OmegaConf.create(conf), ".namespace1.class1.key1")
+            == "value1_1"
+        )
+        assert (
+            OmegaConf.select(OmegaConf.create(conf), ".namespace1.class1.key2")
+            == "value1_2"
+        )
+        assert (
+            OmegaConf.select(OmegaConf.create(conf), ".namespace1.class2.key1")
+            == "value2_1"
+        )
+        assert (
+            OmegaConf.select(OmegaConf.create(conf), ".namespace1.class2.key2")
+            == "value2_2"
+        )
+
     @use_config_dir
     def test_pattern_key_not_found(self, tmp_path):
         """Check the error if no config files satisfy a given pattern"""

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA --numprocesses 4 --dist loadfile
: '>>>>> End Test Output'
git checkout 036016004c5a2805b977b268af39313d6e7d5700 tests/config/test_omegaconf_config.py
