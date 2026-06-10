#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 8928c785301526674cb949d38b583d02a499b0a4 bookmarks/tests/test_auto_tagging.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/bookmarks/tests/test_auto_tagging.py b/bookmarks/tests/test_auto_tagging.py
index b4213a1c..12732648 100644
--- a/bookmarks/tests/test_auto_tagging.py
+++ b/bookmarks/tests/test_auto_tagging.py
@@ -202,3 +202,44 @@ def test_auto_tag_by_domain_path_and_qs_works_with_encoded_url(self):
         tags = auto_tagging.get_tags(script, url)
 
         self.assertEqual(tags, {"tag1", "tag2"})
+
+    def test_auto_tag_with_url_fragment(self):
+        script = """
+            example.com/#/section/1 section1
+            example.com/#/section/2 section2
+        """
+        url = "https://example.com/#/section/1"
+
+        tags = auto_tagging.get_tags(script, url)
+
+        self.assertEqual(tags, {"section1"})
+
+    def test_auto_tag_with_url_fragment_partial_match(self):
+        script = """
+            example.com/#/section section
+        """
+        url = "https://example.com/#/section/1"
+
+        tags = auto_tagging.get_tags(script, url)
+
+        self.assertEqual(tags, {"section"})
+
+    def test_auto_tag_with_url_fragment_ignores_case(self):
+        script = """
+            example.com/#SECTION section
+        """
+        url = "https://example.com/#section"
+
+        tags = auto_tagging.get_tags(script, url)
+
+        self.assertEqual(tags, {"section"})
+
+    def test_auto_tag_with_url_fragment_and_comment(self):
+        script = """
+            example.com/#section1 section1 #This is a comment
+        """
+        url = "https://example.com/#section1"
+
+        tags = auto_tagging.get_tags(script, url)
+
+        self.assertEqual(tags, {"section1"})

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 8928c785301526674cb949d38b583d02a499b0a4 bookmarks/tests/test_auto_tagging.py
