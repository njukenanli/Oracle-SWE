#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 689a0e64012d1e576ebd99e786a254bc537582c6 tests/test_make.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_make.py b/tests/test_make.py
index 7a568bf9c..e1ad1501d 100644
--- a/tests/test_make.py
+++ b/tests/test_make.py
@@ -694,6 +694,25 @@ def __attrs_pre_init__(self2, y):
 
         assert 12 == getattr(c, "z", None)
 
+    @pytest.mark.usefixtures("with_and_without_validation")
+    def test_pre_init_kw_only_work_with_defaults(self):
+        """
+        Default values together with kw_only don't break __attrs__pre_init__.
+        """
+        val = None
+
+        @attr.define
+        class KWOnlyAndDefault:
+            kw_and_default: int = attr.field(kw_only=True, default=3)
+
+            def __attrs_pre_init__(self, *, kw_and_default):
+                nonlocal val
+                val = kw_and_default
+
+        inst = KWOnlyAndDefault()
+
+        assert 3 == val == inst.kw_and_default
+
     @pytest.mark.usefixtures("with_and_without_validation")
     def test_post_init(self):
         """

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 689a0e64012d1e576ebd99e786a254bc537582c6 tests/test_make.py
