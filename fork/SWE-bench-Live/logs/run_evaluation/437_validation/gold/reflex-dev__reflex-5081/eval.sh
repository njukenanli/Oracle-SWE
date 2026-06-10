#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 6afcaf60bde184258b79d3bba8eb35046a87a073 tests/units/utils/test_utils.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/units/utils/test_utils.py b/tests/units/utils/test_utils.py
index 8128d69840..751906d4df 100644
--- a/tests/units/utils/test_utils.py
+++ b/tests/units/utils/test_utils.py
@@ -103,6 +103,10 @@ def test_is_generic_alias(cls: type, expected: bool):
         (str, Literal["test", "value", 2, 3], True),
         (int, Literal["test", "value"], False),
         (int, Literal["test", "value", 2, 3], True),
+        (Literal["test", "value"], str, True),
+        (Literal["test", "value", 2, 3], str, False),
+        (Literal["test", "value"], int, False),
+        (Literal["test", "value", 2, 3], int, False),
         *[
             (NoReturn, super_class, True)
             for super_class in [int, float, str, bool, list, dict, object, Any]

EOF_114329324912
: '>>>>> Start Test Output'
.venv/bin/pytest -rA
: '>>>>> End Test Output'
git checkout 6afcaf60bde184258b79d3bba8eb35046a87a073 tests/units/utils/test_utils.py
