#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
echo "No test files to reset"
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/cli/main/test_output_stream_passthrough.py b/tests/cli/main/test_output_stream_passthrough.py
new file mode 100644
index 00000000000..9c7a03be156
--- /dev/null
+++ b/tests/cli/main/test_output_stream_passthrough.py
@@ -0,0 +1,31 @@
+import re
+from pathlib import Path
+
+import pytest
+
+import streamlink_cli.main
+import tests
+from streamlink.session import Streamlink
+
+
+@pytest.fixture(autouse=True)
+def session(session: Streamlink):
+    session.plugins.load_path(Path(tests.__path__[0]) / "plugin")
+
+    return session
+
+
+@pytest.mark.parametrize(
+    "argv",
+    [pytest.param(["--player-passthrough=hls", "http://test.se", "hls"], id="no-player")],
+    indirect=["argv"],
+)
+def test_no_player(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], argv: list):
+    monkeypatch.setattr("streamlink_cli.argparser.find_default_player", lambda *_, **__: None)
+
+    with pytest.raises(SystemExit) as exc_info:
+        streamlink_cli.main.main()
+    assert exc_info.value.code == 1
+
+    out, _err = capsys.readouterr()
+    assert re.search(r"error: The default player \(\w+\) does not seem to be installed\.", out)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
echo "No test files to reset"
