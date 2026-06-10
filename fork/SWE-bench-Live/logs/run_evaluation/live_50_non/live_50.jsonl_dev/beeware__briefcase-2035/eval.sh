#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout ad3b3354e4e57bc0ac4d8cd9b7748adb1d2034ed tests/commands/base/test_verify_requires_python.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/commands/base/test_verify_requires_python.py b/tests/commands/base/test_verify_requires_python.py
index 33a1ced52..b47c80c36 100644
--- a/tests/commands/base/test_verify_requires_python.py
+++ b/tests/commands/base/test_verify_requires_python.py
@@ -1,4 +1,5 @@
 import platform
+from unittest import mock
 
 import pytest
 
@@ -74,3 +75,12 @@ def test_requires_python_invalid_specifier(base_command, my_app):
 
     with pytest.raises(BriefcaseConfigError, match="Invalid requires-python"):
         base_command.verify_required_python(my_app)
+
+
+@mock.patch("platform.python_version")
+def test_requires_python_prerelease(python_version_mock, base_command, my_app):
+    """Verify that pre-release Python versions are included in matches."""
+    python_version_mock.return_value = "3.14.0a0"
+
+    base_command.global_config = _get_global_config(requires_python=">=3.12")
+    base_command.verify_required_python(my_app)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout ad3b3354e4e57bc0ac4d8cd9b7748adb1d2034ed tests/commands/base/test_verify_requires_python.py
