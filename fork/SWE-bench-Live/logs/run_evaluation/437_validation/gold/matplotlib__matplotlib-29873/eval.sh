#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 3274d6a65d8a6e911ef3fd7d180e34c41c132bec lib/matplotlib/tests/test_axes.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_axes.py b/lib/matplotlib/tests/test_axes.py
index 70d1671cafa3..9c13ce76b2e2 100644
--- a/lib/matplotlib/tests/test_axes.py
+++ b/lib/matplotlib/tests/test_axes.py
@@ -9720,3 +9720,11 @@ def test_bar_shape_mismatch():
     )
     with pytest.raises(ValueError, match=error_message):
         plt.bar(x, height)
+
+
+def test_pie_non_finite_values():
+    fig, ax = plt.subplots()
+    df = [5, float('nan'), float('inf')]
+
+    with pytest.raises(ValueError, match='Wedge sizes must be finite numbers'):
+        ax.pie(df, labels=['A', 'B', 'C'])

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 3274d6a65d8a6e911ef3fd7d180e34c41c132bec lib/matplotlib/tests/test_axes.py
