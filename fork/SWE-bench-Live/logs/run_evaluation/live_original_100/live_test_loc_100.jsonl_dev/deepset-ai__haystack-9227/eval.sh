#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 662f184ce70c296019fad360c38a937031b2dd53 test/dataclasses/test_document.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/dataclasses/test_document.py b/test/dataclasses/test_document.py
index 724513cc2b..9e705b6e41 100644
--- a/test/dataclasses/test_document.py
+++ b/test/dataclasses/test_document.py
@@ -185,6 +185,23 @@ def test_to_dict_with_custom_parameters_without_flattening():
     }
 
 
+def test_to_dict_field_precedence():
+    """
+    Test that Document's first-level fields take precedence over meta fields
+    when flattening the dictionary representation.
+    """
+
+    doc = Document(content="from-content", score=0.9, meta={"content": "from-meta", "score": 0.5, "source": "web"})
+
+    flat_dict = doc.to_dict(flatten=True)
+
+    # First-level fields should take precedence
+    assert flat_dict["content"] == "from-content"
+    assert flat_dict["score"] == 0.9
+    # Meta-only fields should be preserved
+    assert flat_dict["source"] == "web"
+
+
 def test_from_dict():
     assert Document.from_dict({}) == Document()
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA --cov-report xml:coverage.xml --cov="haystack" -m "not integration"
: '>>>>> End Test Output'
git checkout 662f184ce70c296019fad360c38a937031b2dd53 test/dataclasses/test_document.py
