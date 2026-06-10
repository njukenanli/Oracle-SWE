#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 690c55f736bbb285ef9e2a7e9f1634fdc53a5542 lib/matplotlib/tests/test_axes.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_axes.py b/lib/matplotlib/tests/test_axes.py
index 62eb491aa4bb..f952eaa90af1 100644
--- a/lib/matplotlib/tests/test_axes.py
+++ b/lib/matplotlib/tests/test_axes.py
@@ -1499,6 +1499,20 @@ def test_pcolormesh_rgba(fig_test, fig_ref, dims, alpha):
     ax.pcolormesh(c[..., 0], cmap="gray", vmin=0, vmax=1, alpha=alpha)
 
 
+@check_figures_equal(extensions=["png"])
+def test_pcolormesh_nearest_noargs(fig_test, fig_ref):
+    x = np.arange(4)
+    y = np.arange(7)
+    X, Y = np.meshgrid(x, y)
+    C = X + Y
+
+    ax = fig_test.subplots()
+    ax.pcolormesh(C, shading="nearest")
+
+    ax = fig_ref.subplots()
+    ax.pcolormesh(x, y, C, shading="nearest")
+
+
 @image_comparison(['pcolormesh_datetime_axis.png'], style='mpl20')
 def test_pcolormesh_datetime_axis():
     # Remove this line when this test image is regenerated.

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 690c55f736bbb285ef9e2a7e9f1634fdc53a5542 lib/matplotlib/tests/test_axes.py
