#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout c07eb2a6a04e0694d27e6b5e256cc219ac68af0c tests/units/test_state.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/units/test_state.py b/tests/units/test_state.py
index 271f2e7941e..3ff8d453cc5 100644
--- a/tests/units/test_state.py
+++ b/tests/units/test_state.py
@@ -3404,3 +3404,10 @@ class DillState(BaseState):
     state3._g = (i for i in range(10))
     pk3 = state3._serialize()
     assert len(pk3) == 0
+
+
+def test_typed_state() -> None:
+    class TypedState(rx.State):
+        field: rx.Field[str] = rx.field("")
+
+    _ = TypedState(field="str")

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA tests/units
: '>>>>> End Test Output'
git checkout c07eb2a6a04e0694d27e6b5e256cc219ac68af0c tests/units/test_state.py
