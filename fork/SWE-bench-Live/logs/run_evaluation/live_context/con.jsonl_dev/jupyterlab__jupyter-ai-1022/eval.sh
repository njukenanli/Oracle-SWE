#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout bf52423a81254009e9be6ca1b89a3f4c6e49ed49 packages/jupyter-ai/jupyter_ai/tests/test_handlers.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/packages/jupyter-ai/jupyter_ai/tests/test_handlers.py b/packages/jupyter-ai/jupyter_ai/tests/test_handlers.py
index a94c3fbf8..81108bdb7 100644
--- a/packages/jupyter-ai/jupyter_ai/tests/test_handlers.py
+++ b/packages/jupyter-ai/jupyter_ai/tests/test_handlers.py
@@ -77,6 +77,7 @@ def broadcast_message(message: Message) -> None:
             help_message_template=DEFAULT_HELP_MESSAGE_TEMPLATE,
             chat_handlers={},
             context_providers={},
+            message_interrupted={},
         )
 
 

EOF_114329324912
: '>>>>> Start Test Output'
pytest -vv -rA
: '>>>>> End Test Output'
git checkout bf52423a81254009e9be6ca1b89a3f4c6e49ed49 packages/jupyter-ai/jupyter_ai/tests/test_handlers.py
