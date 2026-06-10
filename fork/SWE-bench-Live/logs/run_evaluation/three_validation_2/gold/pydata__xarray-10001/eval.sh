#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e28f1714bc81d180a128a7b17794c586cb8fafb1 xarray/tests/test_groupby.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/xarray/tests/test_groupby.py b/xarray/tests/test_groupby.py
index 2287130ebe2..d42f86f5ea6 100644
--- a/xarray/tests/test_groupby.py
+++ b/xarray/tests/test_groupby.py
@@ -1618,8 +1618,6 @@ def test_groupby_first_and_last(self) -> None:
         expected = array  # should be a no-op
         assert_identical(expected, actual)
 
-        # TODO: groupby_bins too
-
     def make_groupby_multidim_example_array(self) -> DataArray:
         return DataArray(
             [[[0, 1], [2, 3]], [[5, 10], [15, 20]]],

EOF_114329324912
: '>>>>> Start Test Output'
pytest -n 4 --timeout 180 --cov=xarray --cov-report=xml --junitxml=pytest.xml -rA
: '>>>>> End Test Output'
git checkout e28f1714bc81d180a128a7b17794c586cb8fafb1 xarray/tests/test_groupby.py
