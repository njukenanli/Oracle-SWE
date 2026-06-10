#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout c516d3fe48e7ca469ca94a293f12df56f7964fe3 test/integration/command/test_remote_users.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/integration/command/test_remote_users.py b/test/integration/command/test_remote_users.py
index 46b21945c3c..a1f4106a112 100644
--- a/test/integration/command/test_remote_users.py
+++ b/test/integration/command/test_remote_users.py
@@ -93,6 +93,7 @@ def test_command_user_with_password_spaces(self):
         servers = {"default": test_server}
         client = TestClient(servers=servers, inputs=["lasote", "mypass"])
         client.run(r'remote login default lasote -p="my \"password"')
+        assert "Connecting to remote" not in client.out
         assert "Changed user of remote 'default' from 'None' (anonymous) to 'lasote'" in client.out
         client.run('remote logout default')
         client.run(r'remote login default lasote -p "my \"password"')

EOF_114329324912
: '>>>>> Start Test Output'
python -m pytest -rA .
: '>>>>> End Test Output'
git checkout c516d3fe48e7ca469ca94a293f12df56f7964fe3 test/integration/command/test_remote_users.py
