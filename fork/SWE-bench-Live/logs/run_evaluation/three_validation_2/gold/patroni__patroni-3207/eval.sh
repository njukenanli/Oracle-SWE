#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e1faa38e9024eadebc9274041887276164c215fd tests/test_postgresql.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_postgresql.py b/tests/test_postgresql.py
index bd271e59f..19ab29680 100644
--- a/tests/test_postgresql.py
+++ b/tests/test_postgresql.py
@@ -1182,3 +1182,26 @@ def test_load_current_server_parameters(self):
         self.assertEqual(dict(self.p.config._recovery_params),
                          {'primary_conninfo': {'host': 'a', 'port': '5433', 'passfile': '/blabla', 'sslmode': 'prefer',
                           'gssencmode': 'prefer', 'channel_binding': 'prefer', 'sslnegotiation': 'postgres'}})
+
+    def test_format_dsn(self):
+        params = {'host': '1', 'port': 2, 'target_session_attrs': 'read-write', 'gssencmode': 'prefer',
+                  'channel_binding': 'prefer', 'sslpassword': 'pwd', 'sslcrldir': '/', 'sslnegotiation': 'postgres'}
+        self.p._major_version = 90600
+        self.assertEqual(self.p.config.format_dsn(params), 'host=1 port=2')
+        self.p._major_version = 100000
+        self.assertEqual(self.p.config.format_dsn(params), 'host=1 port=2 target_session_attrs=read-write')
+        self.p._major_version = 120000
+        self.assertEqual(self.p.config.format_dsn(params),
+                         'host=1 port=2 gssencmode=prefer target_session_attrs=read-write')
+        self.p._major_version = 130000
+        self.assertEqual(self.p.config.format_dsn(params),
+                         'host=1 port=2 sslpassword=pwd gssencmode=prefer '
+                         'channel_binding=prefer target_session_attrs=read-write')
+        self.p._major_version = 140000
+        self.assertEqual(self.p.config.format_dsn(params),
+                         'host=1 port=2 sslpassword=pwd sslcrldir=/ gssencmode=prefer '
+                         'channel_binding=prefer target_session_attrs=read-write')
+        self.p._major_version = 170000
+        self.assertEqual(self.p.config.format_dsn(params),
+                         'host=1 port=2 sslpassword=pwd sslcrldir=/ gssencmode=prefer channel_binding=prefer '
+                         'target_session_attrs=read-write sslnegotiation=postgres')

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout e1faa38e9024eadebc9274041887276164c215fd tests/test_postgresql.py
