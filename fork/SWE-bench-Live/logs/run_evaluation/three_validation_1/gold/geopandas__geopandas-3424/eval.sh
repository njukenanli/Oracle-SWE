#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 3d0ff15aaa0c7e5165aecc4f33bdb3171f04d7b0 geopandas/tests/test_overlay.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/geopandas/tests/test_overlay.py b/geopandas/tests/test_overlay.py
index d810e22aa8..aac53abff9 100644
--- a/geopandas/tests/test_overlay.py
+++ b/geopandas/tests/test_overlay.py
@@ -815,6 +815,26 @@ def test_no_intersection():
     assert_geodataframe_equal(result, expected, check_index_type=False)
 
 
+def test_zero_len():
+    # https://github.com/geopandas/geopandas/issues/3422
+    gdf1 = GeoDataFrame(
+        {
+            "geometry": [
+                Polygon([[0.0, 0.0], [2.0, 0.0], [2.0, 2.0], [0.0, 2.0], [0.0, 0.0]])
+            ]
+        },
+        crs=4326,
+    )
+    # overlay with empty geodataframe shouldn't throw
+    gdf2 = GeoDataFrame({"geometry": []}, crs=4326)
+    res = gdf1.overlay(gdf2, how="union")
+    assert_geodataframe_equal(res, gdf1)
+
+    gdf2 = GeoDataFrame(geometry=[], crs=4326)
+    res = gdf1.overlay(gdf2, how="union")
+    assert_geodataframe_equal(res, gdf1)
+
+
 class TestOverlayWikiExample:
     def setup_method(self):
         self.layer_a = GeoDataFrame(geometry=[box(0, 2, 6, 6)])

EOF_114329324912
: '>>>>> Start Test Output'
pytest -v -rA geopandas/
: '>>>>> End Test Output'
git checkout 3d0ff15aaa0c7e5165aecc4f33bdb3171f04d7b0 geopandas/tests/test_overlay.py
