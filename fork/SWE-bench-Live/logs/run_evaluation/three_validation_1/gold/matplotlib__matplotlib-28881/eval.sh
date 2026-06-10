#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 13380e100200db3a04cb43be968d6962d51d0a28 lib/matplotlib/tests/test_lines.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_lines.py b/lib/matplotlib/tests/test_lines.py
index 531237b2ba28..902b7aa2c02d 100644
--- a/lib/matplotlib/tests/test_lines.py
+++ b/lib/matplotlib/tests/test_lines.py
@@ -436,3 +436,14 @@ def test_axline_setters():
     with pytest.raises(ValueError,
                        match="Cannot set a 'slope' value while 'xy2' is set"):
         line2.set_slope(3)
+
+
+def test_axline_small_slope():
+    """Test that small slopes are not coerced to zero in the transform."""
+    line = plt.axline((0, 0), slope=1e-14)
+    p1 = line.get_transform().transform_point((0, 0))
+    p2 = line.get_transform().transform_point((1, 1))
+    # y-values must be slightly different
+    dy = p2[1] - p1[1]
+    assert dy > 0
+    assert dy < 4e-12

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 13380e100200db3a04cb43be968d6962d51d0a28 lib/matplotlib/tests/test_lines.py
