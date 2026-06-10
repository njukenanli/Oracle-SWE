#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 1b6146bde5f0fb7d4cd02d69ea1ea1637ae209ae test/unit/rules/resources/stepfunctions/test_state_machine_definition.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/unit/rules/resources/stepfunctions/test_state_machine_definition.py b/test/unit/rules/resources/stepfunctions/test_state_machine_definition.py
index 00fdcf4ba6..74957de20b 100644
--- a/test/unit/rules/resources/stepfunctions/test_state_machine_definition.py
+++ b/test/unit/rules/resources/stepfunctions/test_state_machine_definition.py
@@ -95,7 +95,7 @@ def rule():
                         "End": True,
                         "ItemsPath": "$",
                         "Parameters": {"BatchNumber.$": "$$.Map.Item.Value"},
-                        "Iterator": {
+                        "ItemProcessor": {
                             "StartAt": "Submit Batch Job",
                             "States": {
                                 "Submit Batch Job": {
@@ -257,7 +257,7 @@ def rule():
                             "MessageNumber.$": "$$.Map.Item.Index",
                             "MessageDetails.$": "$$.Map.Item.Value",
                         },
-                        "Iterator": {
+                        "ItemProcessor": {
                             "StartAt": "Write message to DynamoDB",
                             "States": {
                                 "Write message to DynamoDB": {

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 1b6146bde5f0fb7d4cd02d69ea1ea1637ae209ae test/unit/rules/resources/stepfunctions/test_state_machine_definition.py
