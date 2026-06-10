#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 2c4310d9ff4136416bbfe7e255a3d7ab610ccac7 tests/test_style.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_style.py b/tests/test_style.py
index 19106df7565..e1d65279834 100644
--- a/tests/test_style.py
+++ b/tests/test_style.py
@@ -15,9 +15,9 @@
     ({"a": 1}, {"a": 1}),
     ({"a": LiteralVar.create("abc")}, {"a": "abc"}),
     ({"test_case": 1}, {"testCase": 1}),
-    ({"test_case": {"a": 1}}, {"testCase": {"a": 1}}),
-    ({":test_case": {"a": 1}}, {":testCase": {"a": 1}}),
-    ({"::test_case": {"a": 1}}, {"::testCase": {"a": 1}}),
+    ({"test_case": {"a": 1}}, {"test_case": {"a": 1}}),
+    ({":test_case": {"a": 1}}, {":test_case": {"a": 1}}),
+    ({"::test_case": {"a": 1}}, {"::test_case": {"a": 1}}),
     (
         {"::-webkit-scrollbar": {"display": "none"}},
         {"::-webkit-scrollbar": {"display": "none"}},

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA tests
: '>>>>> End Test Output'
git checkout 2c4310d9ff4136416bbfe7e255a3d7ab610ccac7 tests/test_style.py
