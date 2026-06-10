#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 512c8bee6cd237a8e56ab5527ee2876d8070c0d6 tests/functional/u/used/used_before_assignment_typing.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/functional/u/used/used_before_assignment_typing.py b/tests/functional/u/used/used_before_assignment_typing.py
index 5229260d2f..2b306cea07 100644
--- a/tests/functional/u/used/used_before_assignment_typing.py
+++ b/tests/functional/u/used/used_before_assignment_typing.py
@@ -2,7 +2,7 @@
 # pylint: disable=missing-function-docstring,ungrouped-imports,invalid-name
 
 
-from typing import List, Optional, TYPE_CHECKING
+from typing import List, NamedTuple, Optional, TYPE_CHECKING
 
 if TYPE_CHECKING:
     if True:  # pylint: disable=using-constant-test
@@ -196,3 +196,18 @@ def defined_in_loops(self) -> json:  # [used-before-assignment]
     def defined_in_with(self) -> base64:  # [used-before-assignment]
         print(binascii)  # [used-before-assignment]
         return base64
+
+
+def outer() -> None:
+    def inner() -> MyNamedTuple:
+        return MyNamedTuple(1)
+
+    print(inner())
+
+
+class MyNamedTuple(NamedTuple):
+    """Note: current false negative if outer() called before this declaration."""
+    field: int
+
+
+outer()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 512c8bee6cd237a8e56ab5527ee2876d8070c0d6 tests/functional/u/used/used_before_assignment_typing.py
