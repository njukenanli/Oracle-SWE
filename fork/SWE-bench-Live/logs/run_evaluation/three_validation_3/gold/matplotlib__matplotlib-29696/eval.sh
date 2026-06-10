#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 03b74eaa4b60a5a713e03cb22a5d863bc041750d lib/matplotlib/tests/test_axes.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_axes.py b/lib/matplotlib/tests/test_axes.py
index 0025781d4901..e834d21b2c74 100644
--- a/lib/matplotlib/tests/test_axes.py
+++ b/lib/matplotlib/tests/test_axes.py
@@ -8868,6 +8868,23 @@ def test_bar_label_nan_ydata_inverted():
     assert labels[0].get_verticalalignment() == 'bottom'
 
 
+def test_bar_label_padding():
+    """Test that bar_label accepts both float and array-like padding."""
+    ax = plt.gca()
+    xs, heights = [1, 2], [3, 4]
+    rects = ax.bar(xs, heights)
+    labels1 = ax.bar_label(rects, padding=5)  # test float value
+    assert labels1[0].xyann[1] == 5
+    assert labels1[1].xyann[1] == 5
+
+    labels2 = ax.bar_label(rects, padding=[2, 8])  # test array-like values
+    assert labels2[0].xyann[1] == 2
+    assert labels2[1].xyann[1] == 8
+
+    with pytest.raises(ValueError, match="padding must be of length"):
+        ax.bar_label(rects, padding=[1, 2, 3])
+
+
 def test_nan_barlabels():
     fig, ax = plt.subplots()
     bars = ax.bar([1, 2, 3], [np.nan, 1, 2], yerr=[0.2, 0.4, 0.6])

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 03b74eaa4b60a5a713e03cb22a5d863bc041750d lib/matplotlib/tests/test_axes.py
