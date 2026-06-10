#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 374d5f5c3a5dff429c14d9dce2e709ac52527f3e test/unit/module/template/transforms/test_language_extensions.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/module/template/transforms/test_language_extensions.py b/test/unit/module/template/transforms/test_language_extensions.py
index 7c9e31d26e..da4fa1871b 100644
--- a/test/unit/module/template/transforms/test_language_extensions.py
+++ b/test/unit/module/template/transforms/test_language_extensions.py
@@ -663,6 +663,168 @@ def test_bad_mapping(self):
         )
 
 
+class TestTransformValues(TestCase):
+    def setUp(self) -> None:
+        self.template_obj = convert_dict(
+            {
+                "Transform": ["AWS::LanguageExtensions"],
+                "Mappings": {
+                    "111111111111": {
+                        "A": {"AppName": "appa-dev"},
+                        "B": {"AppName": "appb-dev"},
+                    },
+                    "222222222222": {
+                        "A": {"AppName": "appa-qa"},
+                        "B": {"AppName": "appb-qa"},
+                    },
+                },
+                "Resources": {
+                    "Fn::ForEach::Regions": [
+                        "Region",
+                        ["A"],
+                        {
+                            "${Region}Role": {
+                                "Type": "AWS::IAM::Role",
+                                "Properties": {
+                                    "RoleName": {
+                                        "Fn::Sub": [
+                                            "${appname}",
+                                            {
+                                                "appname": {
+                                                    "Fn::FindInMap": [
+                                                        {"Ref": "AWS::AccountId"},
+                                                        {"Ref": "Region"},
+                                                        "AppName",
+                                                    ]
+                                                }
+                                            },
+                                        ]
+                                    },
+                                    "AssumeRolePolicyDocument": {
+                                        "Version": "2012-10-17",
+                                        "Statement": [
+                                            {
+                                                "Effect": "Allow",
+                                                "Principal": {
+                                                    "Service": ["ec2.amazonaws.com"]
+                                                },
+                                                "Action": ["sts:AssumeRole"],
+                                            }
+                                        ],
+                                    },
+                                    "Path": "/",
+                                },
+                            }
+                        },
+                    ],
+                    "Fn::ForEach::NewRegions": [
+                        "Region",
+                        ["B"],
+                        {
+                            "${Region}Role": {
+                                "Type": "AWS::IAM::Role",
+                                "Properties": {
+                                    "RoleName": {
+                                        "Fn::Sub": [
+                                            "${appname}",
+                                            {
+                                                "appname": {
+                                                    "Fn::FindInMap": [
+                                                        {"Ref": "AWS::AccountId"},
+                                                        {"Ref": "Region"},
+                                                        "AppName",
+                                                    ]
+                                                }
+                                            },
+                                        ]
+                                    },
+                                    "AssumeRolePolicyDocument": {
+                                        "Version": "2012-10-17",
+                                        "Statement": [
+                                            {
+                                                "Effect": "Allow",
+                                                "Principal": {
+                                                    "Service": ["ec2.amazonaws.com"]
+                                                },
+                                                "Action": ["sts:AssumeRole"],
+                                            }
+                                        ],
+                                    },
+                                    "Path": "/",
+                                },
+                            }
+                        },
+                    ],
+                },
+            }
+        )
+
+        self.result = {
+            "Mappings": {
+                "111111111111": {
+                    "A": {"AppName": "appa-dev"},
+                    "B": {"AppName": "appb-dev"},
+                },
+                "222222222222": {
+                    "A": {"AppName": "appa-qa"},
+                    "B": {"AppName": "appb-qa"},
+                },
+            },
+            "Resources": {
+                "ARole": {
+                    "Properties": {
+                        "AssumeRolePolicyDocument": {
+                            "Statement": [
+                                {
+                                    "Action": ["sts:AssumeRole"],
+                                    "Effect": "Allow",
+                                    "Principal": {"Service": ["ec2.amazonaws.com"]},
+                                }
+                            ],
+                            "Version": "2012-10-17",
+                        },
+                        "Path": "/",
+                        "RoleName": {
+                            "Fn::Sub": ["${appname}", {"appname": "appa-dev"}]
+                        },
+                    },
+                    "Type": "AWS::IAM::Role",
+                },
+                "BRole": {
+                    "Properties": {
+                        "AssumeRolePolicyDocument": {
+                            "Statement": [
+                                {
+                                    "Action": ["sts:AssumeRole"],
+                                    "Effect": "Allow",
+                                    "Principal": {"Service": ["ec2.amazonaws.com"]},
+                                }
+                            ],
+                            "Version": "2012-10-17",
+                        },
+                        "Path": "/",
+                        "RoleName": {
+                            "Fn::Sub": ["${appname}", {"appname": "appb-dev"}]
+                        },
+                    },
+                    "Type": "AWS::IAM::Role",
+                },
+            },
+            "Transform": ["AWS::LanguageExtensions"],
+        }
+
+    def test_transform(self):
+        self.maxDiff = None
+        cfn = Template(filename="", template=self.template_obj, regions=["us-east-1"])
+        matches, template = language_extension(cfn)
+        self.assertListEqual(matches, [])
+        self.assertDictEqual(
+            template,
+            self.result,
+            template,
+        )
+
+
 def nested_set(dic, keys, value):
     for key in keys[:-1]:
         if isinstance(key, str):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA -m "not data"
: '>>>>> End Test Output'
git checkout 374d5f5c3a5dff429c14d9dce2e709ac52527f3e test/unit/module/template/transforms/test_language_extensions.py
