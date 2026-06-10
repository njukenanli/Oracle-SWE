#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 1c6e5902db227517e452cfd55fe977c5f9c3fb0a bookmarks/tests/test_bookmark_new_view.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/bookmarks/tests/test_bookmark_new_view.py b/bookmarks/tests/test_bookmark_new_view.py
index cef1812f..7980bcaa 100644
--- a/bookmarks/tests/test_bookmark_new_view.py
+++ b/bookmarks/tests/test_bookmark_new_view.py
@@ -100,6 +100,29 @@ def test_should_prefill_description_from_url_parameter(self):
             html,
         )
 
+    def test_should_prefill_notes_from_url_parameter(self):
+        response = self.client.get(
+            reverse("bookmarks:new")
+            + "?notes=%2A%2AFind%2A%2A%20more%20info%20%5Bhere%5D%28http%3A%2F%2Fexample.com%29"
+        )
+        html = response.content.decode()
+
+        self.assertInHTML(
+            """
+            <details class="notes" open="">
+                <summary>
+                    <span class="form-label d-inline-block">Notes</span>
+                </summary>
+                <label for="id_notes" class="text-assistive">Notes</label>
+                <textarea name="notes" cols="40" rows="8" class="form-input" id="id_notes">**Find** more info [here](http://example.com)</textarea>
+                <div class="form-input-hint">
+                Additional notes, supports Markdown.
+                </div>
+            </details>
+            """,
+            html,
+        )
+
     def test_should_enable_auto_close_when_specified_in_url_parameter(self):
         response = self.client.get(reverse("bookmarks:new") + "?auto_close")
         html = response.content.decode()

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 1c6e5902db227517e452cfd55fe977c5f9c3fb0a bookmarks/tests/test_bookmark_new_view.py
