#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 41be3a05797a7827fb4e27d7c1edda4a22a6036a lib/matplotlib/tests/test_figure.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_figure.py b/lib/matplotlib/tests/test_figure.py
index 61fd71875e2a..edf5ea05f119 100644
--- a/lib/matplotlib/tests/test_figure.py
+++ b/lib/matplotlib/tests/test_figure.py
@@ -496,6 +496,20 @@ def test_autofmt_xdate(which):
             assert int(label.get_rotation()) == angle
 
 
+def test_autofmt_xdate_colorbar_constrained():
+    # check works with a colorbar.
+    # with constrained layout, colorbars do not have a gridspec,
+    # but autofmt_xdate checks if all axes have a gridspec before being
+    # applied.
+    fig, ax = plt.subplots(layout="constrained")
+    im = ax.imshow([[1, 4, 6], [2, 3, 5]])
+    plt.colorbar(im)
+    fig.autofmt_xdate()
+    fig.draw_without_rendering()
+    label = ax.get_xticklabels(which='major')[1]
+    assert label.get_rotation() == 30.0
+
+
 @mpl.style.context('default')
 def test_change_dpi():
     fig = plt.figure(figsize=(4, 4))

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 41be3a05797a7827fb4e27d7c1edda4a22a6036a lib/matplotlib/tests/test_figure.py
