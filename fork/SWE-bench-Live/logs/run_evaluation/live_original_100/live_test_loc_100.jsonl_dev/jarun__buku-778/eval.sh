#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e757c8e5490673f7a682a481699cf6276036111c tests/test_views.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_views.py b/tests/test_views.py
index 9e843656..440f538b 100644
--- a/tests/test_views.py
+++ b/tests/test_views.py
@@ -3,6 +3,7 @@
 resources: https://flask.palletsprojects.com/en/2.2.x/testing/
 """
 from argparse import Namespace
+from unittest import mock
 
 import pytest
 from flask import request
@@ -11,7 +12,7 @@
 
 from buku import BukuDb
 from bukuserver import server
-from bukuserver.views import BookmarkModelView, TagModelView
+from bukuserver.views import BookmarkModelView, TagModelView, filter_key
 from tests.util import mock_fetch, _add_rec
 
 
@@ -61,6 +62,12 @@ def bmv_instance(bukudb):
     return BookmarkModelView(bukudb)
 
 
+@pytest.mark.parametrize('idx, char', [('', ''), (0, '0'), (9, '9'), (10, 'A'), (35, 'Z'), (36, 'a'), (61, 'z')])
+def test_filter_key(idx, char):
+    with mock.patch('bukuserver.views.BookmarkModelView._filter_arg', return_value='filter_name'):
+        assert filter_key(None, idx) == f'flt{char}_filter_name'
+
+
 @pytest.mark.parametrize('disable_favicon', [False, True])
 def test_bookmark_model_view(bukudb, disable_favicon, app):
     inst = BookmarkModelView(bukudb)

EOF_114329324912
: '>>>>> Start Test Output'
pytest --cov buku -vv -rA -m "not non_tox"
: '>>>>> End Test Output'
git checkout e757c8e5490673f7a682a481699cf6276036111c tests/test_views.py
