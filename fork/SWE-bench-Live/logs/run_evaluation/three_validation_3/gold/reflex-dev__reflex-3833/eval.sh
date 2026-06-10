#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout ea15b184c008f06f3205884e85dd4fb2269158e8 tests/test_state.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_state.py b/tests/test_state.py
index d34e771cb80..1d1db1b3fb1 100644
--- a/tests/test_state.py
+++ b/tests/test_state.py
@@ -3148,6 +3148,15 @@ class MixinState(State, mixin=True):
     num: int = 0
     _backend: int = 0
 
+    @rx.var(cache=True)
+    def computed(self) -> str:
+        """A computed var on mixin state.
+
+        Returns:
+            A computed value.
+        """
+        return ""
+
 
 class UsesMixinState(MixinState, State):
     """A state that uses the mixin state."""
@@ -3155,8 +3164,26 @@ class UsesMixinState(MixinState, State):
     pass
 
 
+class ChildUsesMixinState(UsesMixinState):
+    """A child state that uses the mixin state."""
+
+    pass
+
+
 def test_mixin_state() -> None:
     """Test that a mixin state works correctly."""
     assert "num" in UsesMixinState.base_vars
     assert "num" in UsesMixinState.vars
     assert UsesMixinState.backend_vars == {"_backend": 0}
+
+    assert "computed" in UsesMixinState.computed_vars
+    assert "computed" in UsesMixinState.vars
+
+
+def test_child_mixin_state() -> None:
+    """Test that mixin vars are only applied to the highest state in the hierarchy."""
+    assert "num" in ChildUsesMixinState.inherited_vars
+    assert "num" not in ChildUsesMixinState.base_vars
+
+    assert "computed" in ChildUsesMixinState.inherited_vars
+    assert "computed" not in ChildUsesMixinState.computed_vars

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA tests
: '>>>>> End Test Output'
git checkout ea15b184c008f06f3205884e85dd4fb2269158e8 tests/test_state.py
