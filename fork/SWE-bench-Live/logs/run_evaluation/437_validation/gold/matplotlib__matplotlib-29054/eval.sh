#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f8900ead0d9381a7652568768b065324f929734e lib/matplotlib/tests/test_ticker.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_ticker.py b/lib/matplotlib/tests/test_ticker.py
index 222a0d7e11b0..dc697803da3a 100644
--- a/lib/matplotlib/tests/test_ticker.py
+++ b/lib/matplotlib/tests/test_ticker.py
@@ -1235,11 +1235,16 @@ def test_sublabel(self):
         ax.set_xlim(1, 80)
         self._sub_labels(ax.xaxis, subs=[])
 
-        # axis range at 0.4 to 1 decades, label subs 2, 3, 4, 6
+        # axis range slightly more than 1 decade, but spanning a single major
+        # tick, label subs 2, 3, 4, 6
+        ax.set_xlim(.8, 9)
+        self._sub_labels(ax.xaxis, subs=[2, 3, 4, 6])
+
+        # axis range at 0.4 to 1 decade, label subs 2, 3, 4, 6
         ax.set_xlim(1, 8)
         self._sub_labels(ax.xaxis, subs=[2, 3, 4, 6])
 
-        # axis range at 0 to 0.4 decades, label all
+        # axis range at 0 to 0.4 decade, label all
         ax.set_xlim(0.5, 0.9)
         self._sub_labels(ax.xaxis, subs=np.arange(2, 10, dtype=int))
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout f8900ead0d9381a7652568768b065324f929734e lib/matplotlib/tests/test_ticker.py
