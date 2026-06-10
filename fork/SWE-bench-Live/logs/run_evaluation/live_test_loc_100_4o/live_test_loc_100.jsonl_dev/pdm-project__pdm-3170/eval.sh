#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout ff9e871af1ee6ff55267342e1f6f3889ab55278b tests/test_utils.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_utils.py b/tests/test_utils.py
index 7461d71d35..a2122fb5a0 100644
--- a/tests/test_utils.py
+++ b/tests/test_utils.py
@@ -217,11 +217,11 @@ def test_expand_env_vars(given, expected, monkeypatch):
         ("https://example.org/path?arg=1", "https://example.org/path?arg=1"),
         (
             "https://${FOO}@example.org/path?arg=1",
-            "https://hello@example.org/path?arg=1",
+            "https://token%3Aoidc%2F1@example.org/path?arg=1",
         ),
         (
             "https://${FOO}:${BAR}@example.org/path?arg=1",
-            "https://hello:wo%3Arld@example.org/path?arg=1",
+            "https://token%3Aoidc%2F1:p%40ssword@example.org/path?arg=1",
         ),
         (
             "https://${FOOBAR}@example.org/path?arg=1",
@@ -230,8 +230,8 @@ def test_expand_env_vars(given, expected, monkeypatch):
     ],
 )
 def test_expand_env_vars_in_auth(given, expected, monkeypatch):
-    monkeypatch.setenv("FOO", "hello")
-    monkeypatch.setenv("BAR", "wo:rld")
+    monkeypatch.setenv("FOO", "token:oidc/1")
+    monkeypatch.setenv("BAR", "p@ssword")
     assert utils.expand_env_vars_in_auth(given) == expected
 
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout ff9e871af1ee6ff55267342e1f6f3889ab55278b tests/test_utils.py
