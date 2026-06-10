#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 38b63ac1d9c1c24e609be63c3e1fe91a1d814f94 tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.mmd b/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.mmd
new file mode 100644
index 0000000000..bf90bd708d
--- /dev/null
+++ b/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.mmd
@@ -0,0 +1,46 @@
+classDiagram
+  class CheckerCollector {
+    checker1
+    checker2
+    checker3
+  }
+  style CheckerCollector fill:#77AADD
+  class ElseifUsedChecker {
+    msgs : dict
+    name : str
+    leave_module(_: nodes.Module) None
+    process_tokens(tokens: list[TokenInfo]) None
+    visit_if(node: nodes.If) None
+  }
+  style ElseifUsedChecker fill:#99DDFF
+  class ExceptionsChecker {
+    msgs : dict
+    name : str
+    options : tuple
+    open() None
+    visit_binop(node: nodes.BinOp) None
+    visit_compare(node: nodes.Compare) None
+    visit_raise(node: nodes.Raise) None
+    visit_try(node: nodes.Try) None
+    visit_trystar(node: nodes.TryStar) None
+  }
+  style ExceptionsChecker fill:#44BB99
+  class StdlibChecker {
+    msgs : dict[str, MessageDefinitionTuple]
+    name : str
+    deprecated_arguments(method: str) tuple[tuple[int | None, str], ...]
+    deprecated_attributes() Iterable[str]
+    deprecated_classes(module: str) Iterable[str]
+    deprecated_decorators() Iterable[str]
+    deprecated_methods() set[str]
+    visit_boolop(node: nodes.BoolOp) None
+    visit_call(node: nodes.Call) None
+    visit_functiondef(node: nodes.FunctionDef) None
+    visit_if(node: nodes.If) None
+    visit_ifexp(node: nodes.IfExp) None
+    visit_unaryop(node: nodes.UnaryOp) None
+  }
+  style StdlibChecker fill:#44BB99
+  ExceptionsChecker --* CheckerCollector : checker1
+  StdlibChecker --* CheckerCollector : checker3
+  ElseifUsedChecker --* CheckerCollector : checker2
diff --git a/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc b/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc
index 1d0560a4d2..0796a1b611 100644
--- a/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc
+++ b/tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc
@@ -1,3 +1,3 @@
 [testoptions]
-output_formats=puml
+output_formats=puml,mmd
 command_line_args=-S --colorized --max-color-depth=2

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 38b63ac1d9c1c24e609be63c3e1fe91a1d814f94 tests/pyreverse/functional/class_diagrams/colorized_output/colorized.rc
