#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 0caf09628011f9790d6e8df62fe92c485c7382ae xarray/tests/test_dataset.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/xarray/tests/test_dataset.py b/xarray/tests/test_dataset.py
index c3302dd6c9d..7be2d13f9dd 100644
--- a/xarray/tests/test_dataset.py
+++ b/xarray/tests/test_dataset.py
@@ -1593,6 +1593,40 @@ def test_isel_fancy_convert_index_variable(self) -> None:
         assert "x" not in actual.xindexes
         assert not isinstance(actual.x.variable, IndexVariable)
 
+    def test_isel_multicoord_index(self) -> None:
+        # regression test https://github.com/pydata/xarray/issues/10063
+        # isel on a multi-coordinate index should return a unique index associated
+        # to each coordinate
+        class MultiCoordIndex(xr.Index):
+            def __init__(self, idx1, idx2):
+                self.idx1 = idx1
+                self.idx2 = idx2
+
+            @classmethod
+            def from_variables(cls, variables, *, options=None):
+                idx1 = PandasIndex.from_variables(
+                    {"x": variables["x"]}, options=options
+                )
+                idx2 = PandasIndex.from_variables(
+                    {"y": variables["y"]}, options=options
+                )
+
+                return cls(idx1, idx2)
+
+            def create_variables(self, variables=None):
+                return {**self.idx1.create_variables(), **self.idx2.create_variables()}
+
+            def isel(self, indexers):
+                idx1 = self.idx1.isel({"x": indexers.get("x", slice(None))})
+                idx2 = self.idx2.isel({"y": indexers.get("y", slice(None))})
+                return MultiCoordIndex(idx1, idx2)
+
+        coords = xr.Coordinates(coords={"x": [0, 1], "y": [1, 2]}, indexes={})
+        ds = xr.Dataset(coords=coords).set_xindex(["x", "y"], MultiCoordIndex)
+
+        ds2 = ds.isel(x=slice(None), y=slice(None))
+        assert ds2.xindexes["x"] is ds2.xindexes["y"]
+
     def test_sel(self) -> None:
         data = create_test_data()
         int_slicers = {"dim1": slice(None, None, 2), "dim2": slice(2), "dim3": slice(3)}

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 0caf09628011f9790d6e8df62fe92c485c7382ae xarray/tests/test_dataset.py
