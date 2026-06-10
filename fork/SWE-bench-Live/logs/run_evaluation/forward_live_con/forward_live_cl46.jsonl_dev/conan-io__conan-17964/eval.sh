#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f31a78f057c05c20482965cbdf21a79a9db04c45 test/unittests/model/build_info/test_deduce_locations.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unittests/model/build_info/test_deduce_locations.py b/test/unittests/model/build_info/test_deduce_locations.py
index 1fd6349b7e4..3a8169e6a8c 100644
--- a/test/unittests/model/build_info/test_deduce_locations.py
+++ b/test/unittests/model/build_info/test_deduce_locations.py
@@ -169,21 +169,31 @@ def test_windows_several_shared_link_locations(lib_info, conanfile):
 @pytest.mark.skipif(platform.system() == "Windows", reason="Can't apply symlink on Windows")
 def test_shared_link_locations_symlinks(lib, symlinks, conanfile):
     """
-    Tests auto deduce location is able to find the real path of
-    any symlink created in the libs folder
+    Tests auto deduce location is not resolving symlinks by default. For instance:
+        .
+        ├── libpng.so -> libpng16.so  (exact match)
+        ├── libpng16.so -> libpng16.so.16
+        ├── libpng16.so.16 -> libpng16.so.16.44.0
+        └── libpng16.so.16.44.0  (real one)
+
+
+    Issues related:
+        - https://github.com/conan-io/conan/issues/17417
+        - https://github.com/conan-io/conan/issues/17721
     """
     folder = temp_folder()
     all_files = symlinks.split(" <- ")  # [real_one, sym1, sym2, ...]
-    # forcing a folder that it's not going to be analysed by the deduce_location() function
-    real_location = os.path.join(folder, "other", all_files.pop(0))
+    # Real one (first item from list)
+    real_location = os.path.join(folder, "libdir", all_files.pop(0))
     save(real_location, "")
     # Symlinks
-    os.makedirs(os.path.join(folder, "libdir"))
     prev_path = real_location
     for file in all_files:
         sym = os.path.join(folder, "libdir", file)
         os.symlink(prev_path, sym)
         prev_path = sym
+    # Exact match and symlink (latest item from list)
+    exact_match = os.path.join(folder, "libdir", all_files[-1])
 
     cppinfo = CppInfo()
     cppinfo.libdirs = ["libdir"]
@@ -191,7 +201,7 @@ def test_shared_link_locations_symlinks(lib, symlinks, conanfile):
     cppinfo.set_relative_base_folder(folder)
 
     result = cppinfo.deduce_full_cpp_info(conanfile)
-    assert result.location == real_location
+    assert result.location == exact_match
     assert result.type == "shared-library"
 
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout f31a78f057c05c20482965cbdf21a79a9db04c45 test/unittests/model/build_info/test_deduce_locations.py
