#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f17bd4bfcab07d10a35a7e9c47920dbc43623e5b tests/layout/test_flex.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/layout/test_flex.py b/tests/layout/test_flex.py
index 30577aa99..3700c398f 100644
--- a/tests/layout/test_flex.py
+++ b/tests/layout/test_flex.py
@@ -455,9 +455,9 @@ def test_flex_item_min_height():
 @assert_no_logs
 def test_flex_auto_margin():
     # Regression test for https://github.com/Kozea/WeasyPrint/issues/800
-    page, = render_pages('<div style="display: flex; margin: auto">')
+    page, = render_pages('<div id="div1" style="display: flex; margin: auto">')
     page, = render_pages(
-        '<div style="display: flex; flex-direction: column; margin: auto">')
+        '<div id="div2" style="display: flex; flex-direction: column; margin: auto">')
 
 
 @assert_no_logs
@@ -615,3 +615,31 @@ def test_flex_absolute_content():
     assert h1.position_y == 0
     assert p.position_x == 0
     assert p.position_y == 0
+
+
+@assert_no_logs
+def test_flex_auto_margin2():
+    # Regression test for https://github.com/Kozea/WeasyPrint/issues/2054
+    page, = render_pages('''
+<style>
+  #outer {
+    background: red;
+  }
+  #inner {
+    margin: auto;
+    display: flex;
+    width: 160px;
+    height: 160px;
+    background: black;
+  }
+</style>
+
+<div id="outer">
+  <div id="inner"></div>
+</div>
+''')
+    html, = page.children
+    body, = html.children
+    outer, = body.children
+    inner, = outer.children
+    assert inner.margin_left != 0

EOF_114329324912
: '>>>>> Start Test Output'
python -m pytest -rA
: '>>>>> End Test Output'
git checkout f17bd4bfcab07d10a35a7e9c47920dbc43623e5b tests/layout/test_flex.py
