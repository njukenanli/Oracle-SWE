#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 313277af993cebfbae49d385327fc7f45e32f737 tests/test_dates.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_dates.py b/tests/test_dates.py
index fef68ae73..8992bedcf 100644
--- a/tests/test_dates.py
+++ b/tests/test_dates.py
@@ -656,6 +656,13 @@ def test_parse_date():
     assert dates.parse_date('2004-04-01', locale='sv_SE', format='short') == date(2004, 4, 1)
 
 
+def test_parse_date_custom_format():
+    assert dates.parse_date('1.4.2024', format='dd.mm.yyyy') == date(2024, 4, 1)
+    assert dates.parse_date('2024.4.1', format='yyyy.mm.dd') == date(2024, 4, 1)
+    # Dates that look like ISO 8601 should use the custom format as well:
+    assert dates.parse_date('2024-04-01', format='yyyy.dd.mm') == date(2024, 1, 4)
+
+
 @pytest.mark.parametrize('input, expected', [
     # base case, fully qualified time
     ('15:30:00', time(15, 30)),
@@ -705,6 +712,11 @@ def get_date_format(*args, **kwargs):
     assert dates.parse_date('2024-10-20') == date(2024, 10, 20)
 
 
+def test_parse_time_custom_format():
+    assert dates.parse_time('15:30:00', format='HH:mm:ss') == time(15, 30)
+    assert dates.parse_time('00:30:15', format='ss:mm:HH') == time(15, 30)
+
+
 @pytest.mark.parametrize('case', ['', 'a', 'aaa'])
 @pytest.mark.parametrize('func', [dates.parse_date, dates.parse_time])
 def test_parse_errors(case, func):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 313277af993cebfbae49d385327fc7f45e32f737 tests/test_dates.py
