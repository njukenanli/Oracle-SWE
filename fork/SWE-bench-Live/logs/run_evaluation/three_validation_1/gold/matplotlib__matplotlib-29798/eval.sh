#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a9dc9acc2dd1bab761b45e48c8d63aa108811a82 lib/matplotlib/tests/test_polar.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_polar.py b/lib/matplotlib/tests/test_polar.py
index ff2ad6433e6b..27bcd3fa11a8 100644
--- a/lib/matplotlib/tests/test_polar.py
+++ b/lib/matplotlib/tests/test_polar.py
@@ -506,3 +506,23 @@ def test_polar_errorbar(order):
         ax.errorbar(theta, r, xerr=0.1, yerr=0.1, capsize=7, fmt="o", c="seagreen")
         ax.set_theta_zero_location("N")
         ax.set_theta_direction(-1)
+
+
+def test_radial_limits_behavior():
+    # r=0 is kept as limit if positive data and ticks are used
+    # negative ticks or data result in negative limits
+    fig = plt.figure()
+    ax = fig.add_subplot(projection='polar')
+    assert ax.get_ylim() == (0, 1)
+    # upper limit is expanded to include the ticks, but lower limit stays at 0
+    ax.set_rticks([1, 2, 3, 4])
+    assert ax.get_ylim() == (0, 4)
+    # upper limit is autoscaled to data, but lower limit limit stays 0
+    ax.plot([1, 2], [1, 2])
+    assert ax.get_ylim() == (0, 2)
+    # negative ticks also expand the negative limit
+    ax.set_rticks([-1, 0, 1, 2])
+    assert ax.get_ylim() == (-1, 2)
+    # negative data also autoscales to negative limits
+    ax.plot([1, 2], [-1, -2])
+    assert ax.get_ylim() == (-2, 2)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a9dc9acc2dd1bab761b45e48c8d63aa108811a82 lib/matplotlib/tests/test_polar.py
