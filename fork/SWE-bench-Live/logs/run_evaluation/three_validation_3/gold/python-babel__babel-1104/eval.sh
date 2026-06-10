#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 2f87363410f3c904e107e85ca10b9f84902db93f tests/test_dates.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_dates.py b/tests/test_dates.py
index fb9013143..0e0c97d89 100644
--- a/tests/test_dates.py
+++ b/tests/test_dates.py
@@ -751,3 +751,8 @@ def test_issue_892():
     assert dates.format_timedelta(timedelta(days=1), format='narrow', locale='pt_BR') == '1 dia'
     assert dates.format_timedelta(timedelta(days=30), format='narrow', locale='pt_BR') == '1 mês'
     assert dates.format_timedelta(timedelta(days=365), format='narrow', locale='pt_BR') == '1 ano'
+
+
+def test_issue_1089():
+    assert dates.format_datetime(datetime.utcnow(), locale="ja_JP@mod")
+    assert dates.format_datetime(datetime.utcnow(), locale=Locale.parse("ja_JP@mod"))

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 2f87363410f3c904e107e85ca10b9f84902db93f tests/test_dates.py
