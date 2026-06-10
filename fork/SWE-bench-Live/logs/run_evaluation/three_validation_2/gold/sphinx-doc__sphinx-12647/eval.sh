#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 9e3f4521db37f3216e1b256f6227ed852f54b879 tests/roots/test-util-copyasset_overwrite/myext.py tests/test_util/test_util_fileutil.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/roots/test-util-copyasset_overwrite/myext.py b/tests/roots/test-util-copyasset_overwrite/myext.py
index 544057c1fc3..3f961fb8758 100644
--- a/tests/roots/test-util-copyasset_overwrite/myext.py
+++ b/tests/roots/test-util-copyasset_overwrite/myext.py
@@ -12,8 +12,8 @@ def _copy_asset_overwrite_hook(app):
         Path(__file__).parent.joinpath('myext_static', 'custom-styles.css'),
         app.outdir / '_static',
     )
-    # This demonstrates the overwriting
-    assert css.read_text() == '/* extension styles */\n', 'overwriting failed'
+    # This demonstrates that no overwriting occurs
+    assert css.read_text() == '/* html_static_path */\n', 'file overwritten!'
     return []
 
 
diff --git a/tests/test_util/test_util_fileutil.py b/tests/test_util/test_util_fileutil.py
index 2071fc3fade..2ba21a41e8e 100644
--- a/tests/test_util/test_util_fileutil.py
+++ b/tests/test_util/test_util_fileutil.py
@@ -46,7 +46,7 @@ def test_copy_asset_file(tmp_path):
     subdir1 = (tmp_path / 'subdir')
     subdir1.mkdir(parents=True, exist_ok=True)
 
-    copy_asset_file(src, subdir1, {'var1': 'template'}, renderer)
+    copy_asset_file(src, subdir1, context={'var1': 'template'}, renderer=renderer)
     assert (subdir1 / 'asset.txt').exists()
     assert (subdir1 / 'asset.txt').read_text(encoding='utf8') == '# template data'
 
@@ -111,11 +111,11 @@ def test_copy_asset_overwrite(app):
     app.build()
     src = app.srcdir / 'myext_static' / 'custom-styles.css'
     dst = app.outdir / '_static' / 'custom-styles.css'
-    assert (
-        f'Copying the source path {src} to {dst} will overwrite data, '
-        'as a file already exists at the destination path '
-        'and the content does not match.\n'
-    ) in strip_colors(app.status.getvalue())
+    assert strip_colors(app.warning.getvalue()) == (
+        f'WARNING: Aborted attempted copy from {src} to {dst} '
+        '(the destination path has existing data). '
+        '[misc.copy_overwrite]\n'
+    )
 
 
 def test_template_basename():

EOF_114329324912
: '>>>>> Start Test Output'
pytest -vv -rA --durations 25
: '>>>>> End Test Output'
git checkout 9e3f4521db37f3216e1b256f6227ed852f54b879 tests/roots/test-util-copyasset_overwrite/myext.py tests/test_util/test_util_fileutil.py
