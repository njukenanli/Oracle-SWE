#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 9316764e90aea8d193cd8f03b0caccdf02af3ba0 test/test_http2_connection.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/test_http2_connection.py b/test/test_http2_connection.py
index 9a8b59deaf..52c754ee83 100644
--- a/test/test_http2_connection.py
+++ b/test/test_http2_connection.py
@@ -325,3 +325,36 @@ def test_close(self) -> None:
         sendall.assert_called_with(b"foo")
         assert conn._h2_stream is None
         assert conn._headers == []
+
+    def test_request_ignore_chunked(self) -> None:
+        conn = HTTP2Connection("example.com")
+        conn.sock = mock.MagicMock(
+            sendall=mock.Mock(return_value=None),
+        )
+        sendall = conn.sock.sendall
+        data_to_send = conn._h2_conn._obj.data_to_send = mock.Mock(return_value=b"foo")
+        send_headers = conn._h2_conn._obj.send_headers = mock.Mock(return_value=None)
+        conn._h2_conn._obj.send_data = mock.Mock(return_value=None)
+        conn._h2_conn._obj.get_next_available_stream_id = mock.Mock(return_value=1)
+        close_connection = conn._h2_conn._obj.close_connection = mock.Mock(
+            return_value=None
+        )
+
+        conn.request("GET", "/", headers={"Transfer-Encoding": "chunked"}, chunked=True)
+        conn.close()
+
+        data_to_send.assert_called_with()
+        sendall.assert_called_with(b"foo")
+        send_headers.assert_called_with(
+            stream_id=1,
+            headers=[
+                (b":scheme", b"https"),
+                (b":method", b"GET"),
+                (b":authority", b"example.com:443"),
+                (b":path", b"/"),
+                (b"user-agent", _get_default_user_agent().encode()),
+            ],
+            end_stream=True,
+        )
+
+        close_connection.assert_called_with()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -v -rA
: '>>>>> End Test Output'
git checkout 9316764e90aea8d193cd8f03b0caccdf02af3ba0 test/test_http2_connection.py
