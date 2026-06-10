#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 37f44eda5555ffed3b4c581925650fb939e55b94 tests/test_ansimarkup_basic.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_ansimarkup_basic.py b/tests/test_ansimarkup_basic.py
index 008aa1d87..5c0f114e2 100644
--- a/tests/test_ansimarkup_basic.py
+++ b/tests/test_ansimarkup_basic.py
@@ -140,10 +140,15 @@ def test_autoclose(text, expected):
 @pytest.mark.parametrize(
     "text, expected",
     [
+        (r"\<red>foobar\</red>", "<red>foobar</red>"),
+        (r"\\<red>foobar\\</red>", "\\" + Fore.RED + "foobar\\" + Style.RESET_ALL),
+        (r"\\\<red>foobar\\\</red>", "\\<red>foobar\\</red>"),
+        (r"\\\\<red>foobar\\\\</red>", "\\\\" + Fore.RED + "foobar\\\\" + Style.RESET_ALL),
         (r"<red>foo\</red>bar</red>", Fore.RED + "foo</red>bar" + Style.RESET_ALL),
         (r"<red>foo\<red>bar</red>", Fore.RED + "foo<red>bar" + Style.RESET_ALL),
         (r"\<red>\</red>", "<red></red>"),
         (r"foo\</>bar\</>baz", "foo</>bar</>baz"),
+        (r"\a \\b \\\c \\\\d", "\\a \\\\b \\\\\\c \\\\\\\\d"),
     ],
 )
 def test_escaping(text, expected):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -vv -rA
: '>>>>> End Test Output'
git checkout 37f44eda5555ffed3b4c581925650fb939e55b94 tests/test_ansimarkup_basic.py
