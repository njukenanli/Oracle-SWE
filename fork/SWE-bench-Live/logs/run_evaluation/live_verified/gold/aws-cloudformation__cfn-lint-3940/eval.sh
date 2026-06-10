#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a589da356d6bd75e059505b2a91e9e044148ac50 test/fixtures/results/integration/formats.json test/unit/rules/formats/test_schema_comparer.py test/unit/rules/functions/test_getatt_format.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/fixtures/results/integration/formats.json b/test/fixtures/results/integration/formats.json
index bd700aae0b..d61daa5354 100644
--- a/test/fixtures/results/integration/formats.json
+++ b/test/fixtures/results/integration/formats.json
@@ -33,7 +33,7 @@
     },
     {
         "Filename": "test/fixtures/templates/integration/formats.yaml",
-        "Id": "f76fa81f-837e-7502-0be7-3d8ff34024e1",
+        "Id": "59600b0e-7e76-75f0-2c77-abc7279e2d4b",
         "Level": "Error",
         "Location": {
             "End": {
@@ -54,7 +54,7 @@
                 "LineNumber": 44
             }
         },
-        "Message": "{'Fn::GetAtt': ['SecurityGroup', 'GroupName']} with format 'AWS::EC2::SecurityGroup.Name' does not match destination format of 'AWS::EC2::SecurityGroup.Id'",
+        "Message": "{'Fn::GetAtt': ['SecurityGroup', 'GroupName']} with formats ['AWS::EC2::SecurityGroup.Name'] does not match destination format of 'AWS::EC2::SecurityGroup.Id'",
         "ParentId": null,
         "Rule": {
             "Description": "Validate that if source and destination format exists that they match",
diff --git a/test/unit/rules/formats/test_schema_comparer.py b/test/unit/rules/formats/test_schema_comparer.py
index c41b1447f6..b9d6ac0546 100644
--- a/test/unit/rules/formats/test_schema_comparer.py
+++ b/test/unit/rules/formats/test_schema_comparer.py
@@ -34,6 +34,12 @@
                 "'foo' format is incompatible",
             ),
         ),
+        (
+            "backwards compatibility",
+            {"format": "AWS::EC2::SecurityGroup.GroupId"},
+            {"format": "AWS::EC2::SecurityGroup.Id"},
+            None,
+        ),
         (
             "basic valid with anyOf source",
             {"anyOf": [{"format": "foo"}, {"format": "bar"}]},
diff --git a/test/unit/rules/functions/test_getatt_format.py b/test/unit/rules/functions/test_getatt_format.py
index 78d283e40c..8a590eb7d3 100644
--- a/test/unit/rules/functions/test_getatt_format.py
+++ b/test/unit/rules/functions/test_getatt_format.py
@@ -94,7 +94,7 @@ def template():
                 ValidationError(
                     (
                         "{'Fn::GetAtt': ['MyBucket', 'WebsiteURL']} "
-                        "with format 'uri' does not match "
+                        "with formats ['uri'] does not match "
                         "destination format of 'AWS::EC2::VPC.Id'"
                     ),
                     rule=GetAttFormat(),

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a589da356d6bd75e059505b2a91e9e044148ac50 test/fixtures/results/integration/formats.json test/unit/rules/formats/test_schema_comparer.py test/unit/rules/functions/test_getatt_format.py
