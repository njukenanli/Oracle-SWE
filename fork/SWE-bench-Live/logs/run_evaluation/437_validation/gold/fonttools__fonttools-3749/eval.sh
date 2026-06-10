#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 46cb2d078adebb0830d054052c1a489e699583b0 Tests/feaLib/builder_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/Tests/feaLib/builder_test.py b/Tests/feaLib/builder_test.py
index e6ecb3ebe8..fcff36d87d 100644
--- a/Tests/feaLib/builder_test.py
+++ b/Tests/feaLib/builder_test.py
@@ -86,6 +86,7 @@ class BuilderTest(unittest.TestCase):
         variable_mark_anchor duplicate_lookup_reference
         contextual_inline_multi_sub_format_2
         contextual_inline_format_4
+        duplicate_language_stmt
     """.split()
 
     VARFONT_AXES = [

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 46cb2d078adebb0830d054052c1a489e699583b0 Tests/feaLib/builder_test.py
