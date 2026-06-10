#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout a4ec1e5be3fb553b45af5f38f134f7be26d3a274 tests/test_agents.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_agents.py b/tests/test_agents.py
index 1cd0a6750..4a031374b 100644
--- a/tests/test_agents.py
+++ b/tests/test_agents.py
@@ -35,6 +35,7 @@
     ChatMessageToolCall,
     ChatMessageToolCallDefinition,
 )
+from smolagents.utils import BASE_BUILTIN_MODULES
 
 
 def get_new_path(suffix="") -> str:
@@ -381,6 +382,12 @@ def test_tool_descriptions_get_baked_in_system_prompt(self):
         assert tool.name in agent.system_prompt
         assert tool.description in agent.system_prompt
 
+    def test_module_imports_get_baked_in_system_prompt(self):
+        agent = CodeAgent(tools=[], model=fake_code_model)
+        agent.run("Empty task")
+        for module in BASE_BUILTIN_MODULES:
+            assert module in agent.system_prompt
+
     def test_init_agent_with_different_toolsets(self):
         toolset_1 = []
         agent = CodeAgent(tools=toolset_1, model=fake_code_model)

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout a4ec1e5be3fb553b45af5f38f134f7be26d3a274 tests/test_agents.py
