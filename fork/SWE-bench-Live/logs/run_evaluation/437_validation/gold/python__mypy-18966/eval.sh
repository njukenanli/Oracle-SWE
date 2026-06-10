#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout b62957b992ec1da37c42ad37e8ed23fc51644b3e test-data/unit/fine-grained-suggest.test
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test-data/unit/fine-grained-suggest.test b/test-data/unit/fine-grained-suggest.test
index 0ed3be4055ea..d3c609510bf7 100644
--- a/test-data/unit/fine-grained-suggest.test
+++ b/test-data/unit/fine-grained-suggest.test
@@ -714,6 +714,26 @@ def bar(iany) -> None:
 (int) -> None
 ==
 
+[case testSuggestNewInit]
+# suggest: foo.F.__init__
+# suggest: foo.F.__new__
+[file foo.py]
+class F:
+    def __new__(cls, t):
+        return super().__new__(cls)
+
+    def __init__(self, t):
+        self.t = t
+
+[file bar.py]
+from foo import F
+def bar(iany) -> None:
+    F(0)
+[out]
+(int) -> None
+(int) -> Any
+==
+
 [case testSuggestColonBasic]
 # suggest: tmp/foo.py:1
 # suggest: tmp/bar/baz.py:2

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout b62957b992ec1da37c42ad37e8ed23fc51644b3e test-data/unit/fine-grained-suggest.test
