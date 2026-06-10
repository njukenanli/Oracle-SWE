#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 95dfc70468fad48fc4647317b8aa91ce4f3cc43b test/fixtures/templates/good/parameters/default.yaml
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/fixtures/templates/good/parameters/default.yaml b/test/fixtures/templates/good/parameters/default.yaml
index 6c3c17b929..a9c042ab3d 100644
--- a/test/fixtures/templates/good/parameters/default.yaml
+++ b/test/fixtures/templates/good/parameters/default.yaml
@@ -75,5 +75,7 @@ Parameters:
       - three,four
   CDLWithoutDefault:
     Type: CommaDelimitedList
-
+  StringList:
+    Type: List<String>
+    Default: False
 Resources: {}

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 95dfc70468fad48fc4647317b8aa91ce4f3cc43b test/fixtures/templates/good/parameters/default.yaml
