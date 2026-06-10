#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 1b0684bd6cc1272f4ddcb6d93f987228d6e492b7 bookmarks/tests/test_bookmarks_list_template.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/bookmarks/tests/test_bookmarks_list_template.py b/bookmarks/tests/test_bookmarks_list_template.py
index 46ed2903..802ae456 100644
--- a/bookmarks/tests/test_bookmarks_list_template.py
+++ b/bookmarks/tests/test_bookmarks_list_template.py
@@ -884,6 +884,21 @@ def test_note_renders_markdown(self):
         )
         self.assertNotes(html, note_html, 1)
 
+    def test_note_renders_markdown_with_linkify(self):
+        # Should linkify plain URL
+        self.setup_bookmark(notes="Example: https://example.com")
+        html = self.render_template()
+
+        note_html = '<p>Example: <a href="https://example.com" rel="nofollow">https://example.com</a></p>'
+        self.assertNotes(html, note_html, 1)
+
+        # Should not linkify URL in markdown link
+        self.setup_bookmark(notes="[https://example.com](https://example.com)")
+        html = self.render_template()
+
+        note_html = '<p><a href="https://example.com" rel="nofollow">https://example.com</a></p>'
+        self.assertNotes(html, note_html, 1)
+
     def test_note_cleans_html(self):
         self.setup_bookmark(notes='<script>alert("test")</script>')
         self.setup_bookmark(

EOF_114329324912
: '>>>>> Start Test Output'
pytest -n auto -rA
: '>>>>> End Test Output'
git checkout 1b0684bd6cc1272f4ddcb6d93f987228d6e492b7 bookmarks/tests/test_bookmarks_list_template.py
