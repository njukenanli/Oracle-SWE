#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout ccb62f766a03e3e3bee8a7439d056936d0fd7f3a tests/kubernetes/parser/test_k8_yaml.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/kubernetes/parser/examples/yaml/not_helm_configmap.yaml b/tests/kubernetes/parser/examples/yaml/not_helm_configmap.yaml
new file mode 100644
index 0000000000..1f2408fd1c
--- /dev/null
+++ b/tests/kubernetes/parser/examples/yaml/not_helm_configmap.yaml
@@ -0,0 +1,8 @@
+apiVersion: v1
+kind: ConfigMap
+metadata:
+  name: application-properties
+data:
+  application.properties: |
+    setting = {{ not_a_helm_template }}  
+    env = test
\ No newline at end of file
diff --git a/tests/kubernetes/parser/test_k8_yaml.py b/tests/kubernetes/parser/test_k8_yaml.py
index a00aed9fbf..e2b84324e4 100644
--- a/tests/kubernetes/parser/test_k8_yaml.py
+++ b/tests/kubernetes/parser/test_k8_yaml.py
@@ -68,6 +68,18 @@ def test_load_utf8_bom_file(self):
         assert template[0]["kind"] == "Pod"
         assert len(file_lines) == 28
 
+    def test_load_templating_configmap(self):
+        # given
+        file_path = EXAMPLES_DIR / "yaml/not_helm_configmap.yaml"
+
+        # when
+        template, file_lines = load(file_path)
+
+        # then
+        assert len(template) == 1
+        assert template[0]["apiVersion"] == "v1"
+        assert template[0]["kind"] == "ConfigMap"
+        assert len(file_lines) == 8
 
 if __name__ == '__main__':
     unittest.main()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA tests
: '>>>>> End Test Output'
git checkout ccb62f766a03e3e3bee8a7439d056936d0fd7f3a tests/kubernetes/parser/test_k8_yaml.py
