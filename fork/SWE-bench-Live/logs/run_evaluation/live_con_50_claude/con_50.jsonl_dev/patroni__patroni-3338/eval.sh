#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 8f22fd255efc5710e4fd1853f12c34abf893abe6 tests/test_etcd3.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_etcd3.py b/tests/test_etcd3.py
index ee4a446f6..a201c3bed 100644
--- a/tests/test_etcd3.py
+++ b/tests/test_etcd3.py
@@ -1,4 +1,5 @@
 import json
+import socket
 import unittest
 
 from threading import Thread
@@ -184,6 +185,8 @@ def test__handle_server_response(self):
         self.assertRaises(etcd.EtcdException, self.client._handle_server_response, response)
         response.status_code = 400
         self.assertRaises(Unknown, self.client._handle_server_response, response)
+        response.content = '{"error":{"grpc_code":14,"message":"","http_code":400}}'
+        self.assertRaises(socket.timeout, self.client._handle_server_response, response)
         response.content = '{"error":{"grpc_code":0,"message":"","http_code":400}}'
         try:
             self.client._handle_server_response(response)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 8f22fd255efc5710e4fd1853f12c34abf893abe6 tests/test_etcd3.py
