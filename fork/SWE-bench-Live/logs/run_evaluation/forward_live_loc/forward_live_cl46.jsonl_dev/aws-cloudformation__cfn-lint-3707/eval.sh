#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout cf66b46cf9fdbb050a6e29438ca226757359af7d test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py b/test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py
index fcaaebf714..1186a2f6fc 100644
--- a/test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py
+++ b/test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py
@@ -42,6 +42,12 @@ def context(cfn):
             ["Resources", "MyResource", "Properties", "LoginProfile", "Password"],
             [],
         ),
+        (
+            "Valid secrets manager",
+            "{{resolve:secretsmanager:Parameter}}",
+            ["Parameters", "MyParameter", "Default"],
+            [],
+        ),
         (
             "Short list",
             "{{resolve:secretsmanager:Parameter}}",

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout cf66b46cf9fdbb050a6e29438ca226757359af7d test/unit/rules/functions/test_dynamic_reference_secrets_manager_path.py
