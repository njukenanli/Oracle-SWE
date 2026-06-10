#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a896807eac70aa5723f0bba07ede9302f35f3fac test/unit/module/conditions/test_conditions.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/module/conditions/test_conditions.py b/test/unit/module/conditions/test_conditions.py
index b5752811dd..4012a69fa2 100644
--- a/test/unit/module/conditions/test_conditions.py
+++ b/test/unit/module/conditions/test_conditions.py
@@ -216,47 +216,43 @@ def test_check_condition_region(self):
         cfn = Template("", template)
         self.assertEqual(len(cfn.conditions._conditions), 3)
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("IsUsEast1", "us-east-1")),
+            cfn.conditions.build_scenerios_on_region("IsUsEast1", "us-east-1"),
             [
                 True,
             ],
         )
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("IsUsEast1", "us-west-2")),
+            cfn.conditions.build_scenerios_on_region("IsUsEast1", "us-west-2"),
             [
                 False,
             ],
         )
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("IsUsWest2", "us-west-2")),
+            cfn.conditions.build_scenerios_on_region("IsUsWest2", "us-west-2"),
             [
                 True,
             ],
         )
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("IsUsWest2", "us-east-1")),
+            cfn.conditions.build_scenerios_on_region("IsUsWest2", "us-east-1"),
             [
                 False,
             ],
         )
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("IsProd", "us-east-1")),
+            cfn.conditions.build_scenerios_on_region("IsProd", "us-east-1"),
             [
                 True,
                 False,
             ],
         )
         self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region("Foo", "us-east-1")),
+            cfn.conditions.build_scenerios_on_region("Foo", "us-east-1"),
             [
                 True,
                 False,
             ],
         )
-        self.assertListEqual(
-            list(cfn.conditions.build_scenerios_on_region(1, "us-east-1")),
-            [],
-        )
 
     def test_test_condition(self):
         """Get condition and test"""

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a896807eac70aa5723f0bba07ede9302f35f3fac test/unit/module/conditions/test_conditions.py
