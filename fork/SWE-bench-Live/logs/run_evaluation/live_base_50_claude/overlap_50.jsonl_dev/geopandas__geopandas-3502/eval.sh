#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 99d5cc98b19d4e1d70a0fd81d68d1f5f453a48d9 geopandas/tests/test_geodataframe.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/geopandas/tests/test_geodataframe.py b/geopandas/tests/test_geodataframe.py
index 0b5584100b..ecbedf2ea6 100644
--- a/geopandas/tests/test_geodataframe.py
+++ b/geopandas/tests/test_geodataframe.py
@@ -1572,6 +1572,22 @@ def test_geodataframe_crs_colname():
     assert gdf["crs"].iloc[0] == 1
     assert getattr(gdf, "crs") is None
 
+    # https://github.com/geopandas/geopandas/issues/3501
+    gdf = GeoDataFrame({"crs": [1]}, geometry=[Point(1, 1)])
+    assert gdf.crs is None
+    assert gdf["crs"].iloc[0] == 1
+    assert getattr(gdf, "crs") is None
+
+    # test multiindex handling
+    df = pd.DataFrame([[1, 0], [0, 1]], columns=[["crs", "crs"], ["x", "y"]])
+    x_col = df["crs", "x"]
+    y_col = df["crs", "y"]
+
+    gdf = GeoDataFrame(df, geometry=points_from_xy(x_col, y_col))
+    assert gdf.crs is None
+    assert gdf["crs"].iloc[0].to_list() == [1, 0]
+    assert getattr(gdf, "crs") is None
+
 
 @pytest.mark.parametrize("geo_col_name", ["geometry", "polygons"])
 def test_set_geometry_supply_colname(dfs, geo_col_name):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 99d5cc98b19d4e1d70a0fd81d68d1f5f453a48d9 geopandas/tests/test_geodataframe.py
