#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 31d403612ebfc36fea0e9e017e42595f9dac60e6 test/unit/module/conditions/test_rules.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/module/conditions/test_rules.py b/test/unit/module/conditions/test_rules.py
index 4b5becf6be..4a367eb44c 100644
--- a/test/unit/module/conditions/test_rules.py
+++ b/test/unit/module/conditions/test_rules.py
@@ -237,6 +237,71 @@ def test_conditions_with_multiple_rules(self):
             )
         )
 
+    def test_fn_equals_assertions_two(self):
+        template = decode_str(
+            """
+        Rules:
+          Rule1:
+            Assertions:
+            - Assert: !Equals ["A", "B"]
+          Rule2:
+            Assertions:
+            - Assert: !Equals ["A", "A"]
+        """
+        )[0]
+
+        cfn = Template("", template)
+        self.assertEqual(len(cfn.conditions._conditions), 0)
+        self.assertEqual(len(cfn.conditions._rules), 2)
+
+        self.assertListEqual(
+            [equal.hash for equal in cfn.conditions._rules[0].equals],
+            [
+                "e7e68477799682e53ecb09f476128abaeba0bdae",
+            ],
+        )
+        self.assertListEqual(
+            [equal.hash for equal in cfn.conditions._rules[1].equals],
+            [
+                "da2a95009a205d5caacd42c3c11ebd4c151b3409",
+            ],
+        )
+
+        self.assertFalse(
+            cfn.conditions.satisfiable(
+                {},
+                {},
+            )
+        )
+
+    def test_fn_equals_assertions_one(self):
+        template = decode_str(
+            """
+        Rules:
+          Rule1:
+            Assertions:
+            - Assert: !Equals ["A", "A"]
+        """
+        )[0]
+
+        cfn = Template("", template)
+        self.assertEqual(len(cfn.conditions._conditions), 0)
+        self.assertEqual(len(cfn.conditions._rules), 1)
+
+        self.assertListEqual(
+            [equal.hash for equal in cfn.conditions._rules[0].equals],
+            [
+                "da2a95009a205d5caacd42c3c11ebd4c151b3409",
+            ],
+        )
+
+        self.assertTrue(
+            cfn.conditions.satisfiable(
+                {},
+                {},
+            )
+        )
+
 
 class TestAssertion(TestCase):
     def test_assertion_errors(self):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 31d403612ebfc36fea0e9e017e42595f9dac60e6 test/unit/module/conditions/test_rules.py
