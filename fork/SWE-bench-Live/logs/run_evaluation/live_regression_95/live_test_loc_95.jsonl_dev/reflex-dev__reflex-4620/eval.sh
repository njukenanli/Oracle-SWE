#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 427d7c56abe33a300f211680edd22b90c6981ef7 tests/units/test_var.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/units/test_var.py b/tests/units/test_var.py
index bfa8aa35aa1..e5f5bbb2a2d 100644
--- a/tests/units/test_var.py
+++ b/tests/units/test_var.py
@@ -1004,7 +1004,7 @@ def test_all_number_operations():
 
     assert (
         str(even_more_complicated_number)
-        == "!(((Math.abs(Math.floor(((Math.floor(((-((-5.4 + 1)) * 2) / 3) / 2) % 3) ** 2))) || (2 && Math.round(((Math.floor(((-((-5.4 + 1)) * 2) / 3) / 2) % 3) ** 2)))) !== 0))"
+        == "!(isTrue((Math.abs(Math.floor(((Math.floor(((-((-5.4 + 1)) * 2) / 3) / 2) % 3) ** 2))) || (2 && Math.round(((Math.floor(((-((-5.4 + 1)) * 2) / 3) / 2) % 3) ** 2))))))"
     )
 
     assert str(LiteralNumberVar.create(5) > False) == "(5 > 0)"

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA tests/units
: '>>>>> End Test Output'
git checkout 427d7c56abe33a300f211680edd22b90c6981ef7 tests/units/test_var.py
