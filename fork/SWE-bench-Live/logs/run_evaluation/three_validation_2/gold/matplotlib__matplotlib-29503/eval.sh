#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f39bf4d2585746fce3ba39decba62693c82f194e lib/matplotlib/tests/test_axes.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_axes.py b/lib/matplotlib/tests/test_axes.py
index 97abc750b9ef..62bdef8b35e3 100644
--- a/lib/matplotlib/tests/test_axes.py
+++ b/lib/matplotlib/tests/test_axes.py
@@ -9635,3 +9635,13 @@ def test_axes_set_position_external_bbox_unchanged(fig_test, fig_ref):
     ax_test.set_position([0.25, 0.25, 0.5, 0.5])
     assert (bbox.x0, bbox.y0, bbox.width, bbox.height) == (0.0, 0.0, 1.0, 1.0)
     ax_ref = fig_ref.add_axes([0.25, 0.25, 0.5, 0.5])
+
+
+def test_bar_shape_mismatch():
+    x = ["foo", "bar"]
+    height = [1, 2, 3]
+    error_message = (
+        r"Mismatch is between 'x' with shape \(2,\) and 'height' with shape \(3,\)"
+    )
+    with pytest.raises(ValueError, match=error_message):
+        plt.bar(x, height)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout f39bf4d2585746fce3ba39decba62693c82f194e lib/matplotlib/tests/test_axes.py
