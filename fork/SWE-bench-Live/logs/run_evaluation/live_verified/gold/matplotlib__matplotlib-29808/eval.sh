#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout bfbd0b56d7abf639101fb79ed684642ac41d3277 lib/matplotlib/tests/test_rcparams.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/lib/matplotlib/tests/test_rcparams.py b/lib/matplotlib/tests/test_rcparams.py
index 334bb42ea12f..1bc148a83a7e 100644
--- a/lib/matplotlib/tests/test_rcparams.py
+++ b/lib/matplotlib/tests/test_rcparams.py
@@ -257,6 +257,8 @@ def generate_validator_testcases(valid):
         {'validator': validate_cycler,
          'success': (('cycler("color", "rgb")',
                       cycler("color", 'rgb')),
+                     ('cycler("color", "Dark2")',
+                      cycler("color", mpl.color_sequences["Dark2"])),
                      (cycler('linestyle', ['-', '--']),
                       cycler('linestyle', ['-', '--'])),
                      ("""(cycler("color", ["r", "g", "b"]) +
@@ -455,6 +457,12 @@ def test_validator_invalid(validator, arg, exception_type):
         validator(arg)
 
 
+def test_validate_cycler_bad_color_string():
+    msg = "'foo' is neither a color sequence name nor can it be interpreted as a list"
+    with pytest.raises(ValueError, match=msg):
+        validate_cycler("cycler('color', 'foo')")
+
+
 @pytest.mark.parametrize('weight, parsed_weight', [
     ('bold', 'bold'),
     ('BOLD', ValueError),  # weight is case-sensitive

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout bfbd0b56d7abf639101fb79ed684642ac41d3277 lib/matplotlib/tests/test_rcparams.py
