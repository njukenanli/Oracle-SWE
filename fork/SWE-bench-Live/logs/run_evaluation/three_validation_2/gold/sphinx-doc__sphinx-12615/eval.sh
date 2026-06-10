#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e61f56950d624f5fa540a1c8d4e3baedd2889bd0 tests/test_util/test_util_inventory.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_util/test_util_inventory.py b/tests/test_util/test_util_inventory.py
index d01785fda24..211dc17e7a6 100644
--- a/tests/test_util/test_util_inventory.py
+++ b/tests/test_util/test_util_inventory.py
@@ -49,12 +49,22 @@ def test_read_inventory_v2_not_having_version():
         ('foo', '', '/util/foo.html#module-module1', 'Long Module desc')
 
 
-def test_ambiguous_definition_warning(warning):
+def test_ambiguous_definition_warning(warning, status):
     f = BytesIO(INVENTORY_V2_AMBIGUOUS_TERMS)
     InventoryFile.load(f, '/util', posixpath.join)
 
-    assert 'contains multiple definitions for std:term:a' not in warning.getvalue().lower()
-    assert 'contains multiple definitions for std:term:b' in warning.getvalue().lower()
+    def _multiple_defs_notice_for(entity: str) -> str:
+        return f'contains multiple definitions for {entity}'
+
+    # was warning-level; reduced to info-level - see https://github.com/sphinx-doc/sphinx/issues/12613
+    mult_defs_a, mult_defs_b = (
+        _multiple_defs_notice_for('std:term:a'),
+        _multiple_defs_notice_for('std:term:b'),
+    )
+    assert mult_defs_a not in warning.getvalue().lower()
+    assert mult_defs_a not in status.getvalue().lower()
+    assert mult_defs_b not in warning.getvalue().lower()
+    assert mult_defs_b in status.getvalue().lower()
 
 
 def _write_appconfig(dir, language, prefix=None):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -v -rA
: '>>>>> End Test Output'
git checkout e61f56950d624f5fa540a1c8d4e3baedd2889bd0 tests/test_util/test_util_inventory.py
