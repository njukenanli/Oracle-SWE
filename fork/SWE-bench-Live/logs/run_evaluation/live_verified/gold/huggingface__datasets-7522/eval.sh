#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 491d8082e2f062a1cf4734c2b88940a496f9892e tests/test_iterable_dataset.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_iterable_dataset.py b/tests/test_iterable_dataset.py
index 25a3b244e9e..36d8590d61a 100644
--- a/tests/test_iterable_dataset.py
+++ b/tests/test_iterable_dataset.py
@@ -2127,6 +2127,18 @@ def test_concatenate_datasets_axis_1_with_different_lengths():
     assert list(concatenated_dataset) == [{**x, **y} for x, y in zip(extended_dataset2_list, dataset1)]
 
 
+@require_torch
+@require_tf
+@require_jax
+@pytest.mark.parametrize(
+    "format_type", [None, "torch", "python", "tf", "tensorflow", "np", "numpy", "jax", "arrow", "pd", "pandas"]
+)
+def test_concatenate_datasets_with_format(dataset: IterableDataset, format_type):
+    formatted_dataset = dataset.with_format(format_type)
+    concatenated_dataset = concatenate_datasets([formatted_dataset])
+    assert concatenated_dataset._formatting.format_type == get_format_type_from_alias(format_type)
+
+
 @pytest.mark.parametrize(
     "probas, seed, expected_length, stopping_strategy",
     [

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA -m "unit" -n 2 --dist loadfile -sv ./tests/
: '>>>>> End Test Output'
git checkout 491d8082e2f062a1cf4734c2b88940a496f9892e tests/test_iterable_dataset.py
