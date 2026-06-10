#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout aa59dacddcafc531915dc983e3da6e8937558f9e test/test_images.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/test_images.py b/test/test_images.py
index 53997da57f..8b612e3644 100644
--- a/test/test_images.py
+++ b/test/test_images.py
@@ -122,18 +122,15 @@ def test_pattern(self, path_n_bytes_image):
         img = images.Img(bytes_image)
         assert isinstance(img.pattern, cairocffi.SurfacePattern)
 
-    def test_pattern_resize(self, path_n_bytes_image_pngs):
+    def test_surface_resize(self, path_n_bytes_image_pngs):
         path, bytes_image = path_n_bytes_image_pngs
         img = images.Img.from_path(path)
-        assert isinstance(img.pattern, cairocffi.SurfacePattern)
-        t_matrix = img.pattern.get_matrix().as_tuple()
-        assert_approx_equal(t_matrix, (1.0, 0.0, 0.0, 1.0))
+        original_width = img.width
+        original_height = img.height
         img.width = 2.0 * img.default_size.width
-        t_matrix = img.pattern.get_matrix().as_tuple()
-        assert_approx_equal(t_matrix, (0.5, 0.0, 0.0, 1.0))
+        assert img.surface.get_width() == 2 * original_width
         img.height = 3.0 * img.default_size.height
-        t_matrix = img.pattern.get_matrix().as_tuple()
-        assert_approx_equal(t_matrix, (0.5, 0.0, 0.0, 1.0 / 3.0))
+        assert img.surface.get_height() == 3 * original_height
 
     def test_pattern_rotate(self, path_n_bytes_image):
         path, bytes_image = path_n_bytes_image

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout aa59dacddcafc531915dc983e3da6e8937558f9e test/test_images.py
