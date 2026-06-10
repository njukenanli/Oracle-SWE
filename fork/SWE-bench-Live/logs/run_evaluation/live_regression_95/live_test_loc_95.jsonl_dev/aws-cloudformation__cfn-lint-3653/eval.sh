#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 5a3b04540efe1559fe807f99b6305222bbe294bc test/unit/module/jsonschema/test_resolvers_cfn.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/module/jsonschema/test_resolvers_cfn.py b/test/unit/module/jsonschema/test_resolvers_cfn.py
index ec98e2bcfe..f61793784c 100644
--- a/test/unit/module/jsonschema/test_resolvers_cfn.py
+++ b/test/unit/module/jsonschema/test_resolvers_cfn.py
@@ -290,6 +290,21 @@ def test_invalid_functions(name, instance, response):
             {"Fn::FindInMap": ["foo", "second", "first", {"DefaultValue": "default"}]},
             [("default", deque([4, "DefaultValue"]), None)],
         ),
+        (
+            "Valid FindInMap with a map name that is a Ref to pseudo param",
+            {"Fn::FindInMap": [{"Ref": "AWS::StackName"}, "first", "second"]},
+            [],
+        ),
+        (
+            "Valid FindInMap with an top level key that is a Ref to pseudo param",
+            {"Fn::FindInMap": ["foo", {"Ref": "AWS::AccountId"}, "second"]},
+            [],
+        ),
+        (
+            "Valid FindInMap with a second level key that is a Ref to pseudo param",
+            {"Fn::FindInMap": ["foo", "first", {"Ref": "AWS::AccountId"}]},
+            [],
+        ),
         (
             "Valid FindInMap with a bad third key",
             {"Fn::FindInMap": ["foo", "first", "third"]},

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 5a3b04540efe1559fe807f99b6305222bbe294bc test/unit/module/jsonschema/test_resolvers_cfn.py
