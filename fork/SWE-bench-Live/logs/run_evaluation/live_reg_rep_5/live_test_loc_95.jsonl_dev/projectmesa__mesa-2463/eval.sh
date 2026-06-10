#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout ef383c4edef8b2e13f40bfd28e9d149386577ff3 tests/test_solara_viz.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_solara_viz.py b/tests/test_solara_viz.py
index 680577570e8..67a72dcba9b 100644
--- a/tests/test_solara_viz.py
+++ b/tests/test_solara_viz.py
@@ -176,6 +176,10 @@ class ModelWithOnlyRequired:
         def __init__(self, param1, param2):
             pass
 
+    class ModelWithKwargs:
+        def __init__(self, **kwargs):
+            pass
+
     # Test that optional params can be omitted
     _check_model_params(ModelWithOptionalParams.__init__, {"required_param": 1})
 
@@ -184,6 +188,12 @@ def __init__(self, param1, param2):
         ModelWithOptionalParams.__init__, {"required_param": 1, "optional_param": 5}
     )
 
+    # Test that model_params are accepted if model uses **kwargs
+    _check_model_params(ModelWithKwargs.__init__, {"another_kwarg": 6})
+
+    # test hat kwargs are accepted even if no model_params are specified
+    _check_model_params(ModelWithKwargs.__init__, {})
+
     # Test invalid parameter name raises ValueError
     with pytest.raises(ValueError, match="Invalid model parameter: invalid_param"):
         _check_model_params(

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout ef383c4edef8b2e13f40bfd28e9d149386577ff3 tests/test_solara_viz.py
