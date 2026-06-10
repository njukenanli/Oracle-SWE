#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 6376c63deba1abab6ac0087a77897f599c0e807a test/fixtures/templates/bad/hard_coded_arn_properties.yaml test/unit/rules/resources/test_hardcodedarnproperties.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/fixtures/templates/bad/hard_coded_arn_properties.yaml b/test/fixtures/templates/bad/hard_coded_arn_properties.yaml
index de51db2922..f57b35b6c7 100644
--- a/test/fixtures/templates/bad/hard_coded_arn_properties.yaml
+++ b/test/fixtures/templates/bad/hard_coded_arn_properties.yaml
@@ -77,3 +77,11 @@ Resources:
               - !Sub arn:${AWS::Partition}:sns:${AWS::Partition}:${AWS::AccountId}:TestTopic
       Roles:
         - !Ref SampleRole
+
+  Authorizer:
+    Type: AWS::ApiGateway::Authorizer
+    Properties:
+      AuthorizerUri: !Sub arn:${AWS::Partition}:apigateway:${AWS::Region}:lambda:path/2015-03-31/functions/arn:${AWS::Partition}:lambda:${AWS::Region}:${AWS::AccountId}:function:Name/invocations
+      RestApiId: RestApiId
+      Type: REQUEST
+      Name: !Sub arn:${AWS::Partition}:apigateway:${AWS::Region}:lambda:path/2015-03-31/functions/arn:${AWS::Partition}:lambda:${AWS::Region}:${AWS::AccountId}:function:Name/invocations
diff --git a/test/fixtures/templates/good/resources/properties/hard_coded_arn_properties.yaml b/test/fixtures/templates/good/resources/properties/hard_coded_arn_properties.yaml
new file mode 100644
index 0000000000..2ad971962a
--- /dev/null
+++ b/test/fixtures/templates/good/resources/properties/hard_coded_arn_properties.yaml
@@ -0,0 +1,8 @@
+Resources:
+  Authorizer:
+    Type: AWS::ApiGateway::Authorizer
+    Properties:
+      AuthorizerUri: !Sub arn:${AWS::Partition}:apigateway:${AWS::Region}:lambda:path/2015-03-31/functions/arn:${AWS::Partition}:lambda:${AWS::Region}:${AWS::AccountId}:function:Name/invocations
+      RestApiId: RestApiId
+      Type: REQUEST
+      Name: Name
diff --git a/test/unit/rules/resources/test_hardcodedarnproperties.py b/test/unit/rules/resources/test_hardcodedarnproperties.py
index ea8ad8a587..2b7b1fce92 100644
--- a/test/unit/rules/resources/test_hardcodedarnproperties.py
+++ b/test/unit/rules/resources/test_hardcodedarnproperties.py
@@ -19,6 +19,7 @@ def setUp(self):
         super(TestHardCodedArnProperties, self).setUp()
         self.collection.register(HardCodedArnProperties())
         self.success_templates = [
+            "test/fixtures/templates/good/resources/properties/hard_coded_arn_properties.yaml",
             "test/fixtures/templates/good/resources/properties/hard_coded_arn_properties_sam.yaml",
         ]
 
@@ -70,7 +71,7 @@ def test_file_negative_region(self):
     def test_file_negative_accountid(self):
         self.helper_file_negative(
             "test/fixtures/templates/bad/hard_coded_arn_properties.yaml",
-            1,
+            2,
             ConfigMixIn(
                 [],
                 include_experimental=True,

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 6376c63deba1abab6ac0087a77897f599c0e807a test/fixtures/templates/bad/hard_coded_arn_properties.yaml test/unit/rules/resources/test_hardcodedarnproperties.py
