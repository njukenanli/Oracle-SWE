#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 25b5930c6e6a1a44670ebc77d34f0cd7d441f623 test/integration/test_integration_templates.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/fixtures/results/integration/aws-dynamodb-table.json b/test/fixtures/results/integration/aws-dynamodb-table.json
new file mode 100644
index 0000000000..4fb8762a8e
--- /dev/null
+++ b/test/fixtures/results/integration/aws-dynamodb-table.json
@@ -0,0 +1,61 @@
+[
+    {
+        "Filename": "test/fixtures/templates/integration/aws-dynamodb-table.yaml",
+        "Id": "9853e961-d150-10b3-4728-32a621c7fbf6",
+        "Level": "Error",
+        "Location": {
+            "End": {
+                "ColumnNumber": 23,
+                "LineNumber": 22
+            },
+            "Path": [
+                "Resources",
+                "Table1",
+                "Properties",
+                "SSESpecification"
+            ],
+            "Start": {
+                "ColumnNumber": 7,
+                "LineNumber": 22
+            }
+        },
+        "Message": "'SSEType' is a dependency of 'KMSMasterKeyId'",
+        "ParentId": null,
+        "Rule": {
+            "Description": "When certain properties are specified it results in other properties to be required",
+            "Id": "E3021",
+            "ShortDescription": "Validate that when a property is specified that other properties should be included",
+            "Source": "https://github.com/aws-cloudformation/cfn-lint/blob/main/docs/cfn-schema-specification.md#dependentrequired"
+        }
+    },
+    {
+        "Filename": "test/fixtures/templates/integration/aws-dynamodb-table.yaml",
+        "Id": "ecae4565-1f41-0f11-949a-c27038ed5a02",
+        "Level": "Error",
+        "Location": {
+            "End": {
+                "ColumnNumber": 16,
+                "LineNumber": 44
+            },
+            "Path": [
+                "Resources",
+                "Table2",
+                "Properties",
+                "SSESpecification",
+                "SSEType"
+            ],
+            "Start": {
+                "ColumnNumber": 9,
+                "LineNumber": 44
+            }
+        },
+        "Message": "'AES256' is not one of ['KMS']",
+        "ParentId": null,
+        "Rule": {
+            "Description": "Check if properties have a valid value in case of an enumator",
+            "Id": "E3030",
+            "ShortDescription": "Check if properties have a valid value",
+            "Source": "https://github.com/aws-cloudformation/cfn-lint/blob/main/docs/cfn-schema-specification.md#enum"
+        }
+    }
+]
diff --git a/test/fixtures/templates/integration/aws-dynamodb-table.yaml b/test/fixtures/templates/integration/aws-dynamodb-table.yaml
new file mode 100644
index 0000000000..41af2bff0b
--- /dev/null
+++ b/test/fixtures/templates/integration/aws-dynamodb-table.yaml
@@ -0,0 +1,44 @@
+
+Resources:
+  KMS:
+    Type: AWS::KMS::Key
+    UpdateReplacePolicy: Retain
+    DeletionPolicy: Retain
+  Table1:
+    UpdateReplacePolicy: Retain
+    DeletionPolicy: Retain
+    Type: AWS::DynamoDB::Table
+    Properties:
+      TableName: table1
+      AttributeDefinitions:
+        - AttributeName: id
+          AttributeType: S
+      KeySchema:
+        - AttributeName: id
+          KeyType: HASH
+      ProvisionedThroughput:
+        ReadCapacityUnits: 1
+        WriteCapacityUnits: 1
+      SSESpecification:
+        KMSMasterKeyId: !GetAtt KMS.Arn
+        SSEEnabled: true
+        # SSEType: KMS # to provide an error
+  Table2:
+    UpdateReplacePolicy: Retain
+    DeletionPolicy: Retain
+    Type: AWS::DynamoDB::Table
+    Properties:
+      TableName: table2
+      AttributeDefinitions:
+        - AttributeName: id
+          AttributeType: S
+      KeySchema:
+        - AttributeName: id
+          KeyType: HASH
+      ProvisionedThroughput:
+        ReadCapacityUnits: 1
+        WriteCapacityUnits: 1
+      SSESpecification:
+        KMSMasterKeyId: !GetAtt KMS.Arn
+        SSEEnabled: true
+        SSEType: AES256
diff --git a/test/integration/test_integration_templates.py b/test/integration/test_integration_templates.py
index 4f81f123c2..99131501c7 100644
--- a/test/integration/test_integration_templates.py
+++ b/test/integration/test_integration_templates.py
@@ -72,6 +72,13 @@ class TestQuickStartTemplates(BaseCliTestCase):
             ),
             "exit_code": 2,
         },
+        {
+            "filename": ("test/fixtures/templates/integration/aws-dynamodb-table.yaml"),
+            "results_filename": (
+                "test/fixtures/results/integration/aws-dynamodb-table.json"
+            ),
+            "exit_code": 2,
+        },
     ]
 
     def test_templates(self):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 25b5930c6e6a1a44670ebc77d34f0cd7d441f623 test/integration/test_integration_templates.py
