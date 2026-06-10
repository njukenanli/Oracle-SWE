#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 4107cc489eba9c25a1ddbfd1314be4a3a80de197 tests/torchtune/_cli/test_download.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/torchtune/_cli/test_download.py b/tests/torchtune/_cli/test_download.py
index 5dbd695226..8a6d6ba0ab 100644
--- a/tests/torchtune/_cli/test_download.py
+++ b/tests/torchtune/_cli/test_download.py
@@ -65,3 +65,44 @@ def test_download_calls_snapshot(self, capsys, monkeypatch, snapshot_download):
 
         # Make sure it was called twice
         assert snapshot_download.call_count == 3
+
+    # GatedRepoError without --hf-token (expect prompt for token)
+    def test_gated_repo_error_no_token(self, capsys, monkeypatch, snapshot_download):
+        model = "meta-llama/Llama-2-7b"
+        testargs = f"tune download {model}".split()
+        monkeypatch.setattr(sys, "argv", testargs)
+
+        # Expect GatedRepoError without --hf-token provided
+        with pytest.raises(SystemExit, match="2"):
+            runpy.run_path(TUNE_PATH, run_name="__main__")
+
+        out_err = capsys.readouterr()
+        # Check that error message prompts for --hf-token
+        assert (
+            "It looks like you are trying to access a gated repository." in out_err.err
+        )
+        assert (
+            "Please ensure you have access to the repository and have provided the proper Hugging Face API token"
+            in out_err.err
+        )
+
+    # GatedRepoError with --hf-token (should not ask for token)
+    def test_gated_repo_error_with_token(self, capsys, monkeypatch, snapshot_download):
+        model = "meta-llama/Llama-2-7b"
+        testargs = f"tune download {model} --hf-token valid_token".split()
+        monkeypatch.setattr(sys, "argv", testargs)
+
+        # Expect GatedRepoError with --hf-token provided
+        with pytest.raises(SystemExit, match="2"):
+            runpy.run_path(TUNE_PATH, run_name="__main__")
+
+        out_err = capsys.readouterr()
+        # Check that error message does not prompt for --hf-token again
+        assert (
+            "It looks like you are trying to access a gated repository." in out_err.err
+        )
+        assert "Please ensure you have access to the repository." in out_err.err
+        assert (
+            "Please ensure you have access to the repository and have provided the proper Hugging Face API token"
+            not in out_err.err
+        )

EOF_114329324912
: '>>>>> Start Test Output'
pytest tests --cov=. --cov-report=xml --durations=20 -vv -rA
: '>>>>> End Test Output'
git checkout 4107cc489eba9c25a1ddbfd1314be4a3a80de197 tests/torchtune/_cli/test_download.py
