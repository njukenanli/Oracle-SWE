#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout fd7538f0e23a49ec34b636484de2d1b4b690c7fb tests/test_functional.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_functional.py b/tests/test_functional.py
index 712e6ed18..05a9aace9 100644
--- a/tests/test_functional.py
+++ b/tests/test_functional.py
@@ -4,7 +4,6 @@
 End-to-end tests.
 """
 
-
 import inspect
 import pickle
 
@@ -744,3 +743,21 @@ class Hashable:
             pass
 
         assert hash(Hashable())
+
+    def test_init_subclass(self, slots):
+        """
+        __attrs_init_subclass__ is called on subclasses.
+        """
+        REGISTRY = []
+
+        @attr.s(slots=slots)
+        class Base:
+            @classmethod
+            def __attrs_init_subclass__(cls):
+                REGISTRY.append(cls)
+
+        @attr.s(slots=slots)
+        class ToRegister(Base):
+            pass
+
+        assert [ToRegister] == REGISTRY

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout fd7538f0e23a49ec34b636484de2d1b4b690c7fb tests/test_functional.py
