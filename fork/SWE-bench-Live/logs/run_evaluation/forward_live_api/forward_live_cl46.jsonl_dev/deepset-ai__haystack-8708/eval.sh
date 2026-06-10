#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 4f73b192f8bcab8077ef7adac7063b23c237f630 test/components/converters/test_pdfminer_to_document.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/components/converters/test_pdfminer_to_document.py b/test/components/converters/test_pdfminer_to_document.py
index 4b30f2819a..92aeb2dcd1 100644
--- a/test/components/converters/test_pdfminer_to_document.py
+++ b/test/components/converters/test_pdfminer_to_document.py
@@ -5,6 +5,7 @@
 
 import pytest
 
+from haystack import Document
 from haystack.dataclasses import ByteStream
 from haystack.components.converters.pdfminer import PDFMinerToDocument
 
@@ -150,3 +151,7 @@ def test_run_empty_document(self, caplog, test_files_path):
             results = converter.run(sources=sources)
             assert "PDFMinerToDocument could not extract text from the file" in caplog.text
             assert results["documents"][0].content == ""
+
+            # Check that not only content is used when the returned document is initialized and doc id is generated
+            assert results["documents"][0].meta["file_path"] == "non_text_searchable.pdf"
+            assert results["documents"][0].id != Document(content="").id

EOF_114329324912
: '>>>>> Start Test Output'
pytest --cov-report xml:coverage.xml --cov="haystack" -m "not integration" -rA
: '>>>>> End Test Output'
git checkout 4f73b192f8bcab8077ef7adac7063b23c237f630 test/components/converters/test_pdfminer_to_document.py
