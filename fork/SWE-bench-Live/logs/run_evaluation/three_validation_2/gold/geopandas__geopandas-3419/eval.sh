#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 0910a7b10ee32005239dd8ca3d392afc0cf02ffc geopandas/tests/test_geodataframe.py geopandas/tests/test_pandas_methods.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/geopandas/tests/test_geodataframe.py b/geopandas/tests/test_geodataframe.py
index a123f66d54..383cb1b3b7 100644
--- a/geopandas/tests/test_geodataframe.py
+++ b/geopandas/tests/test_geodataframe.py
@@ -602,6 +602,14 @@ def test_no_geom_copy(self):
         assert type(df) is GeoDataFrame
         assert type(df.copy()) is GeoDataFrame
 
+    def test_empty(self):
+        df = GeoDataFrame({"geometry": []})
+        assert df.geometry.dtype == "geometry"
+        df = GeoDataFrame({"a": []}, geometry="a")
+        assert df.geometry.dtype == "geometry"
+        df = GeoDataFrame(geometry=[])
+        assert df.geometry.dtype == "geometry"
+
     def test_bool_index(self):
         # Find boros with 'B' in their name
         df = self.df[self.df["BoroName"].str.contains("B")]
diff --git a/geopandas/tests/test_pandas_methods.py b/geopandas/tests/test_pandas_methods.py
index 83d4c76703..d43f12752d 100644
--- a/geopandas/tests/test_pandas_methods.py
+++ b/geopandas/tests/test_pandas_methods.py
@@ -841,6 +841,19 @@ def test_pivot(df):
     assert_geodataframe_equal(result, expected)
 
 
+def test_isna_empty_dtypes():
+    # https://github.com/geopandas/geopandas/issues/3417
+    # should not auto coerce isna to geometry dtype
+    expected = pd.DataFrame({"geometry": []}).isna()
+    actual = GeoDataFrame({"geometry": []}).isna()
+    assert_frame_equal(expected, actual)
+
+    # different geometry col name
+    expected = pd.DataFrame({"a": []}).isna()
+    actual = GeoDataFrame({"a": []}, geometry="a").isna()
+    assert_frame_equal(expected, actual)
+
+
 def test_preserve_attrs(df):
     # https://github.com/geopandas/geopandas/issues/1654
     df.attrs["name"] = "my_name"

EOF_114329324912
: '>>>>> Start Test Output'
pytest -v -rA geopandas/
: '>>>>> End Test Output'
git checkout 0910a7b10ee32005239dd8ca3d392afc0cf02ffc geopandas/tests/test_geodataframe.py geopandas/tests/test_pandas_methods.py
