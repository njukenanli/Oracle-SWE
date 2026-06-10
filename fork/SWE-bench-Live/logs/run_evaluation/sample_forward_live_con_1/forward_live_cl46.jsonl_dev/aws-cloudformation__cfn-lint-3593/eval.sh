#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 5b268db34d9f989cab67ecb340379a0ba9ec0da6 test/unit/rules/resources/ecs/test_service_fargate.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/rules/resources/ecs/test_service_fargate.py b/test/unit/rules/resources/ecs/test_service_fargate.py
index 5ea578ccde..5c62b8b705 100644
--- a/test/unit/rules/resources/ecs/test_service_fargate.py
+++ b/test/unit/rules/resources/ecs/test_service_fargate.py
@@ -315,6 +315,83 @@ def rule():
             deque(["Resources", "Service", "Properties"]),
             [],
         ),
+        (
+            {
+                "Resources": {
+                    "TaskDefinition": jsonpatch.apply_patch(
+                        dict(_task_definition),
+                        [
+                            {
+                                "op": "add",
+                                "path": "/Properties/NetworkMode",
+                                "value": "awsvpc",
+                            },
+                            {
+                                "op": "remove",
+                                "path": "/Properties/RequiresCompatibilities",
+                            },
+                        ],
+                    ),
+                    "Service": dict(_service),
+                },
+            },
+            deque(["Resources", "Service", "Properties"]),
+            [],
+        ),
+        (
+            {
+                "Parameters": {"MyNetworkMode": {"Type": "String"}},
+                "Resources": {
+                    "TaskDefinition": jsonpatch.apply_patch(
+                        dict(_task_definition),
+                        [
+                            {
+                                "op": "add",
+                                "path": "/Properties/NetworkMode",
+                                "value": {"Ref": "MyNetworkMode"},
+                            },
+                            {
+                                "op": "remove",
+                                "path": "/Properties/RequiresCompatibilities",
+                            },
+                        ],
+                    ),
+                    "Service": dict(_service),
+                },
+            },
+            deque(["Resources", "Service", "Properties"]),
+            [],
+        ),
+        (
+            {
+                "Resources": {
+                    "TaskDefinition": jsonpatch.apply_patch(
+                        dict(_task_definition),
+                        [
+                            {
+                                "op": "add",
+                                "path": "/Properties/NetworkMode",
+                                "value": "host",
+                            },
+                            {
+                                "op": "remove",
+                                "path": "/Properties/RequiresCompatibilities",
+                            },
+                        ],
+                    ),
+                    "Service": dict(_service),
+                },
+            },
+            deque(["Resources", "Service", "Properties"]),
+            [
+                ValidationError(
+                    ("'RequiresCompatibilities' is a required property"),
+                    validator="required",
+                    rule=ServiceFargate(),
+                    path_override=deque(["Resources", "TaskDefinition", "Properties"]),
+                )
+            ],
+        ),
     ],
     indirect=["template"],
 )

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 5b268db34d9f989cab67ecb340379a0ba9ec0da6 test/unit/rules/resources/ecs/test_service_fargate.py
