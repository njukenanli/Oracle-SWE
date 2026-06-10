#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 6e33a336c6be430b231d7d5d99cdadc94ed6b906 tests/parser/test_base.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/parser/test_base.py b/tests/parser/test_base.py
index 83fdb46ea..a36951f1b 100644
--- a/tests/parser/test_base.py
+++ b/tests/parser/test_base.py
@@ -7,6 +7,7 @@
 from datamodel_code_generator.model.pydantic import BaseModel, DataModelField
 from datamodel_code_generator.parser.base import (
     Parser,
+    escape_characters,
     exact_import,
     relative,
     sort_data_models,
@@ -284,3 +285,34 @@ def test_no_additional_imports():
 def test_postprocess_result_modules(input_data, expected):
     result = Parser._Parser__postprocess_result_modules(input_data)
     assert result == expected
+
+
+@pytest.fixture
+def escape_map() -> Dict[str, str]:
+    return {
+        '\u0000': r'\x00',  # Null byte
+        "'": r'\'',
+        '\b': r'\b',
+        '\f': r'\f',
+        '\n': r'\n',
+        '\r': r'\r',
+        '\t': r'\t',
+        '\\': r'\\',
+    }
+
+
+@pytest.mark.parametrize(
+    'input_str,expected',
+    [
+        ('\u0000', r'\x00'),  # Test null byte
+        ("'", r'\''),  # Test single quote
+        ('\b', r'\b'),  # Test backspace
+        ('\f', r'\f'),  # Test form feed
+        ('\n', r'\n'),  # Test newline
+        ('\r', r'\r'),  # Test carriage return
+        ('\t', r'\t'),  # Test tab
+        ('\\', r'\\'),  # Test backslash
+    ],
+)
+def test_character_escaping(input_str: str, expected: str) -> None:
+    assert input_str.translate(escape_characters) == expected

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -n auto --cov=datamodel_code_generator --cov-report xml --cov-report term-missing -rA tests
: '>>>>> End Test Output'
git checkout 6e33a336c6be430b231d7d5d99cdadc94ed6b906 tests/parser/test_base.py
