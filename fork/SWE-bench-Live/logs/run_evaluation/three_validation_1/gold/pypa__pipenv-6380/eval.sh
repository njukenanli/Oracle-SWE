#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 1cf036a08541801d6e24fb46dd6d3f592f9e40a6 tests/integration/test_install_markers.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/integration/test_install_markers.py b/tests/integration/test_install_markers.py
index d3ffd7925..30c22b806 100644
--- a/tests/integration/test_install_markers.py
+++ b/tests/integration/test_install_markers.py
@@ -159,6 +159,25 @@ def test_resolver_unique_markers(pipenv_instance_pypi):
         assert yarl["markers"] == "python_version >= '3.9'"
 
 
+@pytest.mark.markers
+@pytest.mark.install
+@pytest.mark.needs_internet
+@pytest.mark.skipif(
+    os.name == "nt",
+    reason="This dependency is not available on Windows",
+)
+def test_install_package_with_invalid_python_version_specifier(pipenv_instance_pypi):
+    """Test that installing a package with an invalid Python version specifier
+    doesn't raise a KeyError. This test verifies the fix for issue #6370.
+    """
+    with pipenv_instance_pypi() as p:
+        # typedb-driver 3.0.5 has an invalid Python version specifier that was causing a KeyError
+        c = p.pipenv("install typedb-driver==3.0.5")
+        assert c.returncode == 0
+        assert "typedb-driver" in p.pipfile["packages"]
+        assert "typedb-driver" in p.lockfile["default"]
+
+
 @flaky
 @pytest.mark.project
 @pytest.mark.needs_internet

EOF_114329324912
: '>>>>> Start Test Output'
pipenv run pytest -rA -n auto -v --fulltrace tests
: '>>>>> End Test Output'
git checkout 1cf036a08541801d6e24fb46dd6d3f592f9e40a6 tests/integration/test_install_markers.py
