#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f1b98cf1241e5d31eff6deefa1419507221d0c2f shapely/tests/geometry/test_point.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/shapely/tests/geometry/test_point.py b/shapely/tests/geometry/test_point.py
index b8af1407f..9995c89ad 100644
--- a/shapely/tests/geometry/test_point.py
+++ b/shapely/tests/geometry/test_point.py
@@ -151,6 +151,8 @@ def test_point_empty(self):
         assert p_null.coords[:] == []
         assert p_null.area == 0.0
 
+        assert p_null.__geo_interface__ == {"type": "Point", "coordinates": ()}
+
     def test_coords(self):
         # From Array.txt
         p = Point(0.0, 0.0, 1.0)

EOF_114329324912
: '>>>>> Start Test Output'
pytest --pyargs shapely.tests -rA
: '>>>>> End Test Output'
git checkout f1b98cf1241e5d31eff6deefa1419507221d0c2f shapely/tests/geometry/test_point.py
