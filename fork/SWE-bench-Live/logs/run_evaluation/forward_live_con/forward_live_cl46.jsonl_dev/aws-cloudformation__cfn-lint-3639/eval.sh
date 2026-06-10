#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout eeb12087fb278a67f263fb9f3cc495959112ef8c test/unit/rules/functions/test_getatt.py test/unit/rules/functions/test_sub.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/rules/functions/test_getatt.py b/test/unit/rules/functions/test_getatt.py
index e1c54f0dfa..14ce2aec19 100644
--- a/test/unit/rules/functions/test_getatt.py
+++ b/test/unit/rules/functions/test_getatt.py
@@ -134,8 +134,8 @@ def validate(self, validator, s, instance, schema):
             [
                 ValidationError(
                     "{'Fn::GetAtt': 'MyBucket.Arn'} is not of type 'array'",
-                    path=deque(["Fn::GetAtt"]),
-                    schema_path=deque(["type"]),
+                    path=deque([]),
+                    schema_path=deque([]),
                     validator="fn_getatt",
                 ),
             ],
@@ -149,8 +149,8 @@ def validate(self, validator, s, instance, schema):
             [
                 ValidationError(
                     "{'Fn::GetAtt': 'MyBucket.Arn'} is not of type 'array', 'object'",
-                    path=deque(["Fn::GetAtt"]),
-                    schema_path=deque(["type"]),
+                    path=deque([]),
+                    schema_path=deque([]),
                     validator="fn_getatt",
                 ),
             ],
diff --git a/test/unit/rules/functions/test_sub.py b/test/unit/rules/functions/test_sub.py
index 7cb09eca60..ca9a465670 100644
--- a/test/unit/rules/functions/test_sub.py
+++ b/test/unit/rules/functions/test_sub.py
@@ -274,15 +274,7 @@ def context(cfn):
             "Invalid Fn::Sub with a GetAtt to an array of attributes",
             {"Fn::Sub": "${MySimpleAd.DnsIpAddresses}"},
             {"type": "string"},
-            [
-                ValidationError(
-                    ("'MySimpleAd.DnsIpAddresses' is not of type 'string'"),
-                    instance="MySimpleAd.DnsIpAddresses",
-                    path=deque(["Fn::Sub"]),
-                    schema_path=deque([]),
-                    validator="fn_sub",
-                ),
-            ],
+            [],
         ),
         (
             "Invalid Fn::Sub with a GetAtt to an integer",

EOF_114329324912
: '>>>>> Start Test Output'
pytest -m "not data" -rA
: '>>>>> End Test Output'
git checkout eeb12087fb278a67f263fb9f3cc495959112ef8c test/unit/rules/functions/test_getatt.py test/unit/rules/functions/test_sub.py
