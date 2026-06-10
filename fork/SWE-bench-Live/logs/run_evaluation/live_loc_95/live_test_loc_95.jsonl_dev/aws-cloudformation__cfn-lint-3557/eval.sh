#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 70c71ebfe2f08ab54a5c21bc3d44c3479a362b27 test/unit/module/jsonschema/test_keywords_cfn.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/module/jsonschema/test_keywords_cfn.py b/test/unit/module/jsonschema/test_keywords_cfn.py
index 312f196f9d..6d088e848c 100644
--- a/test/unit/module/jsonschema/test_keywords_cfn.py
+++ b/test/unit/module/jsonschema/test_keywords_cfn.py
@@ -101,6 +101,32 @@ def test_standard_values(self):
         self.build_execute_tests(True, ["string", "boolean"])
         self.build_execute_tests("true", ["string", "boolean"])
 
+    def test_null_values(self):
+        self.message_errors(
+            "Null value with string type",
+            None,
+            ["None is not of type 'string'"],
+            {"type": "string"},
+        )
+        self.message_errors(
+            "String value with null type",
+            "foo",
+            ["'foo' is not of type 'null'"],
+            {"type": "null"},
+        )
+        self.message_errors(
+            "Object value with null type",
+            {},
+            ["{} is not of type 'null'"],
+            {"type": "null"},
+        )
+        self.message_errors(
+            "None value with multiple types",
+            None,
+            [],
+            {"type": ["string", "null"]},
+        )
+
 
 class TestMultiCfnTypes(Base):
     def build_execute_tests(self, instance, supported_types, unsupported_type) -> None:

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 70c71ebfe2f08ab54a5c21bc3d44c3479a362b27 test/unit/module/jsonschema/test_keywords_cfn.py
