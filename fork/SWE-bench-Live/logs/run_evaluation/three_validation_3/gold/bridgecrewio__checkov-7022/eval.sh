#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 8b0f288ae10065b5f40673d904f2204c5a3ec770 tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/cloudformation/checks/resource/aws/example_ParameterStoreCredentials/no_crash.yaml b/tests/cloudformation/checks/resource/aws/example_ParameterStoreCredentials/no_crash.yaml
new file mode 100644
index 0000000000..416fb2a5fc
--- /dev/null
+++ b/tests/cloudformation/checks/resource/aws/example_ParameterStoreCredentials/no_crash.yaml
@@ -0,0 +1,35 @@
+AWSTemplateFormatVersion: '2010-09-09'
+Description: CloudFormation template to create an SSM Parameter for holding the DynamoDb Table Name.
+
+Parameters:
+  TableName:
+    Type: String
+    Description: The name of the DynamoDB table
+
+Resources:
+  AccountInfoTable:
+    Type: AWS::DynamoDB::Table
+    Properties:
+      TableName: !Ref TableName
+      AttributeDefinitions:
+        - AttributeName: id
+          AttributeType: S
+      KeySchema:
+        - AttributeName: id
+          KeyType: HASH
+      ProvisionedThroughput:
+        ReadCapacityUnits: 5
+        WriteCapacityUnits: 5
+
+  DynamoDbParameter:
+    Type: AWS::SSM::Parameter
+    Properties:
+      Name: !Sub /AccountInfoService/${AWS::StackName}/TableName
+      Type: String
+      Value: !Ref AccountInfoTable
+      Description: SSM Parameter for holding the DynamoDb Table Name.
+
+Outputs:
+  DynamoDbParameterOutput:
+    Description: SSM Parameter for holding the DynamoDb Table Name.
+    Value: !Ref DynamoDbParameter
diff --git a/tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py b/tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py
index 83cf077ac1..baa03edf7c 100644
--- a/tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py
+++ b/tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py
@@ -20,6 +20,7 @@ def test_summary(self):
             "AWS::SSM::Parameter.GoodRef",
             "AWS::SSM::Parameter.PassTestName",
             "AWS::SSM::Parameter.PassTestVALUE",
+            "AWS::SSM::Parameter.DynamoDbParameter",
         }
         failing_resources = {
             "AWS::SSM::Parameter.FailAPIKey",

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 8b0f288ae10065b5f40673d904f2204c5a3ec770 tests/cloudformation/checks/resource/aws/test_ParameterStoreCredentials.py
