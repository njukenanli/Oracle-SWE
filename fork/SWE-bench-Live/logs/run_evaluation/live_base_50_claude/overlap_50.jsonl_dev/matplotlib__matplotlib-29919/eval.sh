#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 126515a81f2e981894095dc9e76c4634f85dc2ca lib/matplotlib/tests/test_path.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_path.py b/lib/matplotlib/tests/test_path.py
index 5424160dad93..21f4c33794af 100644
--- a/lib/matplotlib/tests/test_path.py
+++ b/lib/matplotlib/tests/test_path.py
@@ -541,3 +541,84 @@ def test_cleanup_closepoly():
         cleaned = p.cleaned(remove_nans=True)
         assert len(cleaned) == 1
         assert cleaned.codes[0] == Path.STOP
+
+
+def test_interpolated_moveto():
+    # Initial path has two subpaths with two LINETOs each
+    vertices = np.array([[0, 0],
+                         [0, 1],
+                         [1, 2],
+                         [4, 4],
+                         [4, 5],
+                         [5, 5]])
+    codes = [Path.MOVETO, Path.LINETO, Path.LINETO] * 2
+
+    path = Path(vertices, codes)
+    result = path.interpolated(3)
+
+    # Result should have two subpaths with six LINETOs each
+    expected_subpath_codes = [Path.MOVETO] + [Path.LINETO] * 6
+    np.testing.assert_array_equal(result.codes, expected_subpath_codes * 2)
+
+
+def test_interpolated_closepoly():
+    codes = [Path.MOVETO] + [Path.LINETO]*2 + [Path.CLOSEPOLY]
+    vertices = [(4, 3), (5, 4), (5, 3), (0, 0)]
+
+    path = Path(vertices, codes)
+    result = path.interpolated(2)
+
+    expected_vertices = np.array([[4, 3],
+                                  [4.5, 3.5],
+                                  [5, 4],
+                                  [5, 3.5],
+                                  [5, 3],
+                                  [4.5, 3],
+                                  [4, 3]])
+    expected_codes = [Path.MOVETO] + [Path.LINETO]*5 + [Path.CLOSEPOLY]
+
+    np.testing.assert_allclose(result.vertices, expected_vertices)
+    np.testing.assert_array_equal(result.codes, expected_codes)
+
+    # Usually closepoly is the last vertex but does not have to be.
+    codes += [Path.LINETO]
+    vertices += [(2, 1)]
+
+    path = Path(vertices, codes)
+    result = path.interpolated(2)
+
+    extra_expected_vertices = np.array([[3, 2],
+                                        [2, 1]])
+    expected_vertices = np.concatenate([expected_vertices, extra_expected_vertices])
+
+    expected_codes += [Path.LINETO] * 2
+
+    np.testing.assert_allclose(result.vertices, expected_vertices)
+    np.testing.assert_array_equal(result.codes, expected_codes)
+
+
+def test_interpolated_moveto_closepoly():
+    # Initial path has two closed subpaths
+    codes = ([Path.MOVETO] + [Path.LINETO]*2 + [Path.CLOSEPOLY]) * 2
+    vertices = [(4, 3), (5, 4), (5, 3), (0, 0), (8, 6), (10, 8), (10, 6), (0, 0)]
+
+    path = Path(vertices, codes)
+    result = path.interpolated(2)
+
+    expected_vertices1 = np.array([[4, 3],
+                                   [4.5, 3.5],
+                                   [5, 4],
+                                   [5, 3.5],
+                                   [5, 3],
+                                   [4.5, 3],
+                                   [4, 3]])
+    expected_vertices = np.concatenate([expected_vertices1, expected_vertices1 * 2])
+    expected_codes = ([Path.MOVETO] + [Path.LINETO]*5 + [Path.CLOSEPOLY]) * 2
+
+    np.testing.assert_allclose(result.vertices, expected_vertices)
+    np.testing.assert_array_equal(result.codes, expected_codes)
+
+
+def test_interpolated_empty_path():
+    path = Path(np.zeros((0, 2)))
+    assert path.interpolated(42) is path

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 126515a81f2e981894095dc9e76c4634f85dc2ca lib/matplotlib/tests/test_path.py
