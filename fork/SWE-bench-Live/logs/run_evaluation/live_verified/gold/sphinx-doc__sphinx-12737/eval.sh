#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 3d49941484ef4dbceb155be0aedb09e49b896cd6 tests/test_builders/test_build_latex.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/test_builders/test_build_latex.py b/tests/test_builders/test_build_latex.py
index 2aa4e0ea565..92fef44df32 100644
--- a/tests/test_builders/test_build_latex.py
+++ b/tests/test_builders/test_build_latex.py
@@ -2230,43 +2230,71 @@ def test_one_parameter_per_line(app):
 
     # TODO: should these asserts check presence or absence of a final \sphinxparamcomma?
     # signature of 23 characters is too short to trigger one-param-per-line mark-up
-    assert '\\pysiglinewithargsret{\\sphinxbfcode{\\sphinxupquote{hello}}}' in result
+    assert (
+        '\\pysiglinewithargsret\n'
+        '{\\sphinxbfcode{\\sphinxupquote{hello}}}\n'
+        '{\\sphinxparam{' in result
+    )
 
-    assert '\\pysigwithonelineperarg{\\sphinxbfcode{\\sphinxupquote{foo}}}' in result
+    assert (
+        '\\pysigwithonelineperarg\n'
+        '{\\sphinxbfcode{\\sphinxupquote{foo}}}\n'
+        '{\\sphinxoptional{\\sphinxparam{' in result
+    )
 
     # generic_arg[T]
     assert (
-        '\\pysiglinewithargsretwithtypelist{\\sphinxbfcode{\\sphinxupquote{generic\\_arg}}}'
-        '{\\sphinxtypeparam{\\DUrole{n}{T}}}{}{}'
-    ) in result
+        '\\pysiglinewithargsretwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{generic\\_arg}}}\n'
+        '{\\sphinxtypeparam{\\DUrole{n}{T}}}\n'
+        '{}\n'
+        '{}\n' in result
+    )
 
     # generic_foo[T]()
     assert (
-        '\\pysiglinewithargsretwithtypelist{\\sphinxbfcode{\\sphinxupquote{generic\\_foo}}}'
-    ) in result
+        '\\pysiglinewithargsretwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{generic\\_foo}}}\n'
+        '{\\sphinxtypeparam{\\DUrole{n}{T}}}\n'
+        '{}\n'
+        '{}\n' in result
+    )
 
     # generic_bar[T](x: list[T])
     assert (
-        '\\pysigwithonelineperargwithtypelist{\\sphinxbfcode{\\sphinxupquote{generic\\_bar}}}'
-    ) in result
+        '\\pysigwithonelineperargwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{generic\\_bar}}}\n'
+        '{\\sphinxtypeparam{' in result
+    )
 
     # generic_ret[R]() -> R
     assert (
-        '\\pysiglinewithargsretwithtypelist{\\sphinxbfcode{\\sphinxupquote{generic\\_ret}}}'
-        '{\\sphinxtypeparam{\\DUrole{n}{R}}}{}{{ $\\rightarrow$ R}}'
-    ) in result
+        '\\pysiglinewithargsretwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{generic\\_ret}}}\n'
+        '{\\sphinxtypeparam{\\DUrole{n}{R}}}\n'
+        '{}\n'
+        '{{ $\\rightarrow$ R}}\n' in result
+    )
 
     # MyGenericClass[X]
     assert (
-        '\\pysiglinewithargsretwithtypelist{\\sphinxbfcode{\\sphinxupquote{class\\DUrole{w}{ '
-        '}}}\\sphinxbfcode{\\sphinxupquote{MyGenericClass}}}'
-    ) in result
+        '\\pysiglinewithargsretwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{class\\DUrole{w}{ }}}'
+        '\\sphinxbfcode{\\sphinxupquote{MyGenericClass}}}\n'
+        '{\\sphinxtypeparam{\\DUrole{n}{X}}}\n'
+        '{}\n'
+        '{}\n' in result
+    )
 
     # MyList[T](list[T])
     assert (
-        '\\pysiglinewithargsretwithtypelist{\\sphinxbfcode{\\sphinxupquote{class\\DUrole{w}{ '
-        '}}}\\sphinxbfcode{\\sphinxupquote{MyList}}}'
-    ) in result
+        '\\pysiglinewithargsretwithtypelist\n'
+        '{\\sphinxbfcode{\\sphinxupquote{class\\DUrole{w}{ }}}'
+        '\\sphinxbfcode{\\sphinxupquote{MyList}}}\n'
+        '{\\sphinxtypeparam{\\DUrole{n}{T}}}\n'
+        '{\\sphinxparam{list{[}T{]}}}\n'
+        '{}\n' in result
+    )
 
 
 @pytest.mark.sphinx('latex', testroot='markup-rubric')

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 3d49941484ef4dbceb155be0aedb09e49b896cd6 tests/test_builders/test_build_latex.py
