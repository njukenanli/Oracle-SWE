#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 01b90b5dcdb472345e4508846e6f949544388d58 tests/providers/test_python.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/providers/test_python.py b/tests/providers/test_python.py
index 4b89ebc377..5af45bf245 100644
--- a/tests/providers/test_python.py
+++ b/tests/providers/test_python.py
@@ -506,6 +506,16 @@ def test_min_value_10_pow_1000_return_greater_number(self):
         result = self.fake.pydecimal(min_value=10**1000)
         self.assertGreater(result, 10**1000)
 
+    def test_min_value_float_returns_correct_digit_number(self):
+        Faker.seed("6")
+        result = self.fake.pydecimal(left_digits=1, right_digits=1, min_value=0.2, max_value=0.3)
+        self.assertEqual(decimal.Decimal("0.2"), result)
+
+    def test_max_value_float_returns_correct_digit_number(self):
+        Faker.seed("3")
+        result = self.fake.pydecimal(left_digits=1, right_digits=1, min_value=0.2, max_value=0.3)
+        self.assertEqual(decimal.Decimal("0.3"), result)
+
 
 class TestPystr(unittest.TestCase):
     def setUp(self):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 01b90b5dcdb472345e4508846e6f949544388d58 tests/providers/test_python.py
