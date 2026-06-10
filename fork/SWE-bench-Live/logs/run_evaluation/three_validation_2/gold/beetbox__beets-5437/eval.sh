#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 88d3f040e158703ae0c6499bb3b217a1e4c455a4 test/plugins/test_ftintitle.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/plugins/test_ftintitle.py b/test/plugins/test_ftintitle.py
index 45146b42b7..9e8f14fe1a 100644
--- a/test/plugins/test_ftintitle.py
+++ b/test/plugins/test_ftintitle.py
@@ -183,5 +183,10 @@ def test_contains_feat(self):
         assert ftintitle.contains_feat("Alice & Bob")
         assert ftintitle.contains_feat("Alice and Bob")
         assert ftintitle.contains_feat("Alice With Bob")
+        assert ftintitle.contains_feat("Alice (ft. Bob)")
+        assert ftintitle.contains_feat("Alice (feat. Bob)")
+        assert ftintitle.contains_feat("Alice [ft. Bob]")
+        assert ftintitle.contains_feat("Alice [feat. Bob]")
         assert not ftintitle.contains_feat("Alice defeat Bob")
         assert not ftintitle.contains_feat("Aliceft.Bob")
+        assert not ftintitle.contains_feat("Alice (defeat Bob)")

EOF_114329324912
: '>>>>> Start Test Output'
poetry run pytest -rA
: '>>>>> End Test Output'
git checkout 88d3f040e158703ae0c6499bb3b217a1e4c455a4 test/plugins/test_ftintitle.py
