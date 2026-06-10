#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout bb070a7d912866805fad67482b1a029908e0eab4 tests/webbrowser/test_chromium.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/webbrowser/test_chromium.py b/tests/webbrowser/test_chromium.py
index cacece5828e..e516c813fec 100644
--- a/tests/webbrowser/test_chromium.py
+++ b/tests/webbrowser/test_chromium.py
@@ -11,6 +11,7 @@
 from streamlink.compat import is_win32
 from streamlink.exceptions import PluginError
 from streamlink.session import Streamlink
+from streamlink.session.http_useragents import CHROME
 from streamlink.webbrowser.chromium import ChromiumWebbrowser
 from streamlink.webbrowser.exceptions import WebbrowserError
 
@@ -107,6 +108,7 @@ def test_launch_args(self):
     def test_headless(self, headless: bool):
         webbrowser = ChromiumWebbrowser(headless=headless)
         assert ("--headless=new" in webbrowser.arguments) is headless
+        assert (f"--user-agent={CHROME}" in webbrowser.arguments) is headless
 
 
 @pytest.mark.trio()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout bb070a7d912866805fad67482b1a029908e0eab4 tests/webbrowser/test_chromium.py
