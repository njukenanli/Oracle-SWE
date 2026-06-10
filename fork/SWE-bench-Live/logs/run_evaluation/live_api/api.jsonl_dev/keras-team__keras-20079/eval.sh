#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout d8b331412a89cbeaf07cc94fa5b55b9e5b6bf626 keras/src/layers/preprocessing/rescaling_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/keras/src/layers/preprocessing/rescaling_test.py b/keras/src/layers/preprocessing/rescaling_test.py
index 83a55e1f8a15..bd0a77423289 100644
--- a/keras/src/layers/preprocessing/rescaling_test.py
+++ b/keras/src/layers/preprocessing/rescaling_test.py
@@ -84,3 +84,21 @@ def test_rescaling_with_channels_first_and_vector_scale(self):
         x = np.random.random((2, 3, 10, 10)) * 255
         layer(x)
         backend.set_image_data_format(config)
+
+    @pytest.mark.requires_trainable_backend
+    def test_numpy_args(self):
+        # https://github.com/keras-team/keras/issues/20072
+        self.run_layer_test(
+            layers.Rescaling,
+            init_kwargs={
+                "scale": np.array(1.0 / 255.0),
+                "offset": np.array(0.5),
+            },
+            input_shape=(2, 3),
+            expected_output_shape=(2, 3),
+            expected_num_trainable_weights=0,
+            expected_num_non_trainable_weights=0,
+            expected_num_seed_generators=0,
+            expected_num_losses=0,
+            supports_masking=True,
+        )

EOF_114329324912
: '>>>>> Start Test Output'
SKIP_APPLICATIONS_TESTS=True pytest -rA keras
: '>>>>> End Test Output'
git checkout d8b331412a89cbeaf07cc94fa5b55b9e5b6bf626 keras/src/layers/preprocessing/rescaling_test.py
