#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout cdc53cae78d080d67ecaa184ff16a83dba13a010 test/core/super_component/test_super_component.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/core/super_component/test_super_component.py b/test/core/super_component/test_super_component.py
index 825e57fdcc..6f0dbed87d 100644
--- a/test/core/super_component/test_super_component.py
+++ b/test/core/super_component/test_super_component.py
@@ -278,3 +278,13 @@ def from_dict(cls, data):
 
         assert custom_serialized["type"] == "test_super_component.CustomSuperComponent"
         assert custom_super_component._to_super_component_dict() == serialized
+
+    def test_super_component_non_leaf_output(self, rag_pipeline):
+        # 'retriever' is not a leaf, but should now be allowed
+        output_mapping = {"retriever.documents": "retrieved_docs", "answer_builder.answers": "final_answers"}
+        wrapper = SuperComponent(pipeline=rag_pipeline, output_mapping=output_mapping)
+        wrapper.warm_up()
+        result = wrapper.run(query="What is the capital of France?")
+        assert "final_answers" in result  # leaf output
+        assert "retrieved_docs" in result  # non-leaf output
+        assert isinstance(result["retrieved_docs"][0], Document)

EOF_114329324912
: '>>>>> Start Test Output'
pytest --cov-report xml:coverage.xml --cov="haystack" -m "not integration" -rA
: '>>>>> End Test Output'
git checkout cdc53cae78d080d67ecaa184ff16a83dba13a010 test/core/super_component/test_super_component.py
