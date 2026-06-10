#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout efe911f61a8d9ccd258b1c24bb9094fdce5d177d test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py b/test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py
index 3b27e1cc8a..eeb2e3cb72 100644
--- a/test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py
+++ b/test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py
@@ -74,7 +74,7 @@ def rule():
             },
             [
                 ValidationError(
-                    ("'origin-id' is not one of " "['foo', 'bar']"),
+                    ("'origin-id' is not one of ['foo', 'bar']"),
                     rule=DistributionTargetOriginId(),
                     path=deque([]),
                     validator="enum",
@@ -117,6 +117,95 @@ def rule():
             },
             [],
         ),
+        (
+            {
+                "DefaultCacheBehavior": {
+                    "TargetOriginId": "origin-id",
+                },
+                "Origins": [
+                    {
+                        "Id": "foo",
+                    },
+                    {
+                        "Id": "bar",
+                    },
+                ],
+                "OriginGroups": {
+                    "Items": [
+                        {
+                            "Id": "group-1",
+                        },
+                        {
+                            "Id": "group-2",
+                        },
+                    ]
+                },
+            },
+            [
+                ValidationError(
+                    (
+                        "'origin-id' is not one of "
+                        "['foo', 'bar', 'group-1', 'group-2']"
+                    ),
+                    rule=DistributionTargetOriginId(),
+                    path=deque([]),
+                    validator="enum",
+                    path_override=deque(["DefaultCacheBehavior", "TargetOriginId"]),
+                )
+            ],
+        ),
+        (
+            {
+                "DefaultCacheBehavior": {
+                    "TargetOriginId": "origin-id",
+                },
+                "Origins": [
+                    {
+                        "Id": "foo",
+                    },
+                    {
+                        "Id": "bar",
+                    },
+                ],
+                "OriginGroups": {
+                    "Items": [
+                        {
+                            "Id": "group-1",
+                        },
+                        {
+                            "Id": "origin-id",
+                        },
+                    ]
+                },
+            },
+            [],
+        ),
+        (
+            {
+                "DefaultCacheBehavior": {
+                    "TargetOriginId": "origin-id",
+                },
+                "Origins": [
+                    {
+                        "Id": "foo",
+                    },
+                    {
+                        "Id": "bar",
+                    },
+                ],
+                "OriginGroups": {
+                    "Items": [
+                        {
+                            "Id": "group-1",
+                        },
+                        {
+                            "Id": {"Ref": "MyParameter"},
+                        },
+                    ]
+                },
+            },
+            [],
+        ),
     ],
 )
 def test_validate(instance, expected, rule, validator):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout efe911f61a8d9ccd258b1c24bb9094fdce5d177d test/unit/rules/resources/cloudfront/test_distribution_target_origin_id.py
