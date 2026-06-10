#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
echo "No test files to reset"
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/keras/src/backend/common/thread_safe_test.py b/keras/src/backend/common/thread_safe_test.py
new file mode 100644
index 000000000000..b5775cca3586
--- /dev/null
+++ b/keras/src/backend/common/thread_safe_test.py
@@ -0,0 +1,29 @@
+import concurrent
+
+import numpy as np
+
+from keras.src import backend
+from keras.src import ops
+from keras.src import testing
+
+
+class TestThreadSafe(testing.TestCase):
+    def test_is_thread_safe(self):
+        if backend.IS_THREAD_SAFE:
+            executor = concurrent.futures.ThreadPoolExecutor()
+
+            def sum(x, axis):
+                return ops.sum(x, axis=axis)
+
+            futures = []
+
+            for i in range(10000):
+                futures.clear()
+                x = ops.convert_to_tensor(np.random.rand(100, 100))
+                futures.append(executor.submit(sum, x, 1))
+                x = ops.convert_to_tensor(np.random.rand(100))
+                futures.append(executor.submit(sum, x, 0))
+                concurrent.futures.wait(
+                    futures, return_when=concurrent.futures.ALL_COMPLETED
+                )
+                [future.result() for future in futures]

EOF_114329324912
: '>>>>> Start Test Output'
SKIP_APPLICATIONS_TESTS=True pytest -rA keras
: '>>>>> End Test Output'
echo "No test files to reset"
