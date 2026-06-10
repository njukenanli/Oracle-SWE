#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 2e0c41f66ee7a9fddbc517a3ca75a2ce0cf2efd1 tests/pyreverse/test_main.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/pyreverse/test_main.py b/tests/pyreverse/test_main.py
index e8e46df2c1..59fcab16f4 100644
--- a/tests/pyreverse/test_main.py
+++ b/tests/pyreverse/test_main.py
@@ -65,6 +65,42 @@ def test_project_root_in_sys_path() -> None:
         assert sys.path == [PROJECT_ROOT_DIR]
 
 
+def test_discover_package_path_source_root_as_parent(tmp_path: Any) -> None:
+    """Test discover_package_path when source root is a parent of the module."""
+    # Create this temporary structure:
+    # /tmp_path/
+    # └── project/
+    #     └── my-package/
+    #         └── __init__.py
+    project_dir = tmp_path / "project"
+    package_dir = project_dir / "mypackage"
+    package_dir.mkdir(parents=True)
+    (package_dir / "__init__.py").touch()
+
+    # Test with project_dir as source root (parent of package)
+    result = discover_package_path(str(package_dir), [str(project_dir)])
+    assert result == str(project_dir)
+
+
+def test_discover_package_path_source_root_as_child(tmp_path: Any) -> None:
+    """Test discover_package_path when source root is a child of the module."""
+    # Create this temporary structure:
+    # /tmp_path/
+    # └── project/
+    #     └── src/
+    #         └── my-package/
+    #             └── __init__.py
+    project_dir = tmp_path / "project"
+    src_dir = project_dir / "src"
+    package_dir = src_dir / "mypackage"
+    package_dir.mkdir(parents=True)
+    (package_dir / "__init__.py").touch()
+
+    # Test with src_dir as source root (child of project)
+    result = discover_package_path(str(project_dir), [str(src_dir)])
+    assert result == str(src_dir)
+
+
 @mock.patch("pylint.pyreverse.main.Linker", new=mock.MagicMock())
 @mock.patch("pylint.pyreverse.main.DiadefsHandler", new=mock.MagicMock())
 @mock.patch("pylint.pyreverse.main.writer")

EOF_114329324912
: '>>>>> Start Test Output'
pytest --benchmark-disable -rA tests/
: '>>>>> End Test Output'
git checkout 2e0c41f66ee7a9fddbc517a3ca75a2ce0cf2efd1 tests/pyreverse/test_main.py
