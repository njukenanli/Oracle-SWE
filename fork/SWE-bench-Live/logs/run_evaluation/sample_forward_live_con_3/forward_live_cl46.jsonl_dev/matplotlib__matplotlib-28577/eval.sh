#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout c51103a068db018bad1152f78141d6c7360c29ff lib/matplotlib/tests/test_axes.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_axes.py b/lib/matplotlib/tests/test_axes.py
index e5ae14c6e66b..2c10a93796fa 100644
--- a/lib/matplotlib/tests/test_axes.py
+++ b/lib/matplotlib/tests/test_axes.py
@@ -5741,6 +5741,28 @@ def test_reset_ticks(fig_test, fig_ref):
         ax.yaxis.reset_ticks()
 
 
+@mpl.style.context('mpl20')
+def test_context_ticks():
+    with plt.rc_context({
+            'xtick.direction': 'in', 'xtick.major.size': 30, 'xtick.major.width': 5,
+            'xtick.color': 'C0', 'xtick.major.pad': 12,
+            'xtick.bottom': True, 'xtick.top': True,
+            'xtick.labelsize': 14, 'xtick.labelcolor': 'C1'}):
+        fig, ax = plt.subplots()
+    # Draw outside the context so that all-but-first tick are generated with the normal
+    # mpl20 style in place.
+    fig.draw_without_rendering()
+
+    first_tick = ax.xaxis.majorTicks[0]
+    for tick in ax.xaxis.majorTicks[1:]:
+        assert tick._size == first_tick._size
+        assert tick._width == first_tick._width
+        assert tick._base_pad == first_tick._base_pad
+        assert tick._labelrotation == first_tick._labelrotation
+        assert tick._zorder == first_tick._zorder
+        assert tick._tickdir == first_tick._tickdir
+
+
 def test_vline_limit():
     fig = plt.figure()
     ax = fig.gca()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout c51103a068db018bad1152f78141d6c7360c29ff lib/matplotlib/tests/test_axes.py
