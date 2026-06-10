#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f01096fef402485092c7132dfd042cc8f467ed09 xarray/tests/test_dataset.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/xarray/tests/test_dataset.py b/xarray/tests/test_dataset.py
index c6c32f85d10..1178498de19 100644
--- a/xarray/tests/test_dataset.py
+++ b/xarray/tests/test_dataset.py
@@ -6694,6 +6694,24 @@ def test_polyfit_weighted(self) -> None:
         ds.polyfit("dim2", 2, w=np.arange(ds.sizes["dim2"]))
         xr.testing.assert_identical(ds, ds_copy)
 
+    def test_polyfit_coord(self) -> None:
+        # Make sure polyfit works when given a non-dimension coordinate.
+        ds = create_test_data(seed=1)
+
+        out = ds.polyfit("numbers", 2, full=False)
+        assert "var3_polyfit_coefficients" in out
+        assert "dim1" in out
+        assert "dim2" not in out
+        assert "dim3" not in out
+
+    def test_polyfit_coord_output(self) -> None:
+        da = xr.DataArray(
+            [1, 3, 2], dims=["x"], coords=dict(x=["a", "b", "c"], y=("x", [0, 1, 2]))
+        )
+        out = da.polyfit("y", deg=1)["polyfit_coefficients"]
+        assert out.sel(degree=0).item() == pytest.approx(1.5)
+        assert out.sel(degree=1).item() == pytest.approx(0.5)
+
     def test_polyfit_warnings(self) -> None:
         ds = create_test_data(seed=1)
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -n 4 --timeout 180 --cov=xarray --cov-report=xml -rA
pytest -rA
: '>>>>> End Test Output'
git checkout f01096fef402485092c7132dfd042cc8f467ed09 xarray/tests/test_dataset.py
