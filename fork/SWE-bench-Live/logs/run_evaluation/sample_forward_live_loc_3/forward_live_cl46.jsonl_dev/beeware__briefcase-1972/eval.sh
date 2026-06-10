#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout f366e9cc11d9f8196454356af8d4bd40f0d1d6f1 tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py b/tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py
index 9a7c145c5..7f8088572 100644
--- a/tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py
+++ b/tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py
@@ -37,6 +37,17 @@ def test_find_binary_packages(dummy_command, tmp_path):
         "binary-package-2",
         version="3.4.6",
         tag="macOS_13_arm64",
+        extra_content=[
+            # A vendored, but incomplete .dist-info folder. See #1970
+            ("vendored/nested-incomplete.dist-info/LICENSE", "Nested License", 0o644),
+        ],
+    )
+    # A vendored .dist-info folder. This *isn't* found and processed.
+    create_installed_package(
+        tmp_path / "app-packages/binary-package-2/vendored",
+        "nested-package",
+        version="9.9.9",
+        tag="macOS_13_arm64",
     )
 
     binary_packages = dummy_command.find_binary_packages(

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout f366e9cc11d9f8196454356af8d4bd40f0d1d6f1 tests/platforms/macOS/test_AppPackagesMergeMixin__find_binary_packages.py
