#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout fdfc2fb5ea7df6664c35b7d8188caa4551f3be5d tests/cli/conftest.py tests/cli/test_config.py tests/conftest.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/cli/conftest.py b/tests/cli/conftest.py
index 80ed147dac..cb253d3e19 100644
--- a/tests/cli/conftest.py
+++ b/tests/cli/conftest.py
@@ -113,6 +113,9 @@ def get_auth_info(self, url: str, username: str | None) -> AuthInfo | None:
                 return next(iter(d.items()))
             return None
 
+        def delete_auth_info(self, url: str, username: str) -> None:
+            self._store.get(url, {}).pop(username, None)
+
     provider = MockKeyringProvider()
     mocker.patch("unearth.auth.get_keyring_provider", return_value=provider)
     monkeypatch.setattr(keyring, "provider", provider)
diff --git a/tests/cli/test_config.py b/tests/cli/test_config.py
index 140136d6f5..a60ca30e11 100644
--- a/tests/cli/test_config.py
+++ b/tests/cli/test_config.py
@@ -200,11 +200,18 @@ def test_config_password_save_into_keyring(project, keyring):
 
     assert project.global_config["pypi.extra.password"] == "barbaz"
     assert project.global_config["repository.pypi.password"] == "password"
+    for key in ("pypi.extra", "repository.pypi"):
+        assert "password" not in project.global_config._file_data[key]
 
     assert keyring.enabled
     assert keyring.get_auth_info("pdm-pypi-extra", "foo") == ("foo", "barbaz")
     assert keyring.get_auth_info("pdm-repository-pypi", None) == ("frost", "password")
 
+    del project.global_config["pypi.extra"]
+    del project.global_config["repository.pypi.password"]
+    assert keyring.get_auth_info("pdm-pypi-extra", "foo") is None
+    assert keyring.get_auth_info("pdm-repository-pypi", None) is None
+
 
 def test_keyring_operation_error_disables_itself(project, keyring, mocker):
     saver = mocker.patch.object(keyring.provider, "save_auth_info", side_effect=RuntimeError())
diff --git a/tests/conftest.py b/tests/conftest.py
index fc18f6cb0e..f4b1138624 100644
--- a/tests/conftest.py
+++ b/tests/conftest.py
@@ -9,6 +9,7 @@
 import pytest
 from unearth.vcs import Git, vcs_support
 
+from pdm.models.auth import keyring
 from pdm.project import Project
 from pdm.utils import path_to_url
 from tests import FIXTURES
@@ -29,6 +30,11 @@ def index() -> dict[str, bytes]:
     return {}
 
 
+@pytest.fixture(scope="session", autouse=True)
+def disable_keyring():
+    keyring.enabled = False
+
+
 @pytest.fixture
 def pypi_indexes(index) -> IndexesDefinition:
     return {

EOF_114329324912
: '>>>>> Start Test Output'
pdm run pytest -rA
: '>>>>> End Test Output'
git checkout fdfc2fb5ea7df6664c35b7d8188caa4551f3be5d tests/cli/conftest.py tests/cli/test_config.py tests/conftest.py
