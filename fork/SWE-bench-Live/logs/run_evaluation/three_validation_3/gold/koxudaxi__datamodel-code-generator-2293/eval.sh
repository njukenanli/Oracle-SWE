#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 4f45637ac45ab8f75794e6dbde069ba371d2bc02 tests/data/expected/main/jsonschema/array_field_constraints.py tests/data/expected/main/openapi/collapse_root_models_field_constraints.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/data/expected/main/jsonschema/array_field_constraints.py b/tests/data/expected/main/jsonschema/array_field_constraints.py
index 552326260..714fa9705 100644
--- a/tests/data/expected/main/jsonschema/array_field_constraints.py
+++ b/tests/data/expected/main/jsonschema/array_field_constraints.py
@@ -9,7 +9,14 @@
 from pydantic import BaseModel, Field
 
 
-class TestSchema(BaseModel):
-    numbers: List[str] = Field(
-        ..., description='A list of numbers', regex='^\\d{1,15}$'
+class Number(BaseModel):
+    __root__: str = Field(
+        ...,
+        description='Just a number',
+        examples=['1', '5464446', '684572369854259'],
+        regex='^\\d{1,15}$',
     )
+
+
+class TestSchema(BaseModel):
+    numbers: List[Number] = Field(..., description='A list of numbers')
diff --git a/tests/data/expected/main/openapi/collapse_root_models_field_constraints.py b/tests/data/expected/main/openapi/collapse_root_models_field_constraints.py
index 88cf88e72..8154d771e 100644
--- a/tests/data/expected/main/openapi/collapse_root_models_field_constraints.py
+++ b/tests/data/expected/main/openapi/collapse_root_models_field_constraints.py
@@ -17,6 +17,16 @@ class Users(BaseModel):
     __root__: List[str]
 
 
+class FileHash(BaseModel):
+    __root__: str = Field(
+        ...,
+        description='For file',
+        max_length=32,
+        min_length=32,
+        regex='^[a-fA-F\\d]{32}$',
+    )
+
+
 class FileRequest(BaseModel):
     file_hash: str = Field(
         ...,
@@ -38,6 +48,4 @@ class ImageRequest(BaseModel):
 
 
 class FileHashes(BaseModel):
-    __root__: List[str] = Field(
-        ..., max_length=32, min_length=32, regex='^[a-fA-F\\d]{32}$'
-    )
+    __root__: List[FileHash]

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 4f45637ac45ab8f75794e6dbde069ba371d2bc02 tests/data/expected/main/jsonschema/array_field_constraints.py tests/data/expected/main/openapi/collapse_root_models_field_constraints.py
