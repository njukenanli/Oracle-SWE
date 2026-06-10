#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 28739c763000afc908ebc64eba717b7d01784de1 test/integration/package_id/package_id_requires_modes_test.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/test/integration/package_id/package_id_requires_modes_test.py b/test/integration/package_id/package_id_requires_modes_test.py
index 30628834e64..a3a067fad67 100644
--- a/test/integration/package_id/package_id_requires_modes_test.py
+++ b/test/integration/package_id/package_id_requires_modes_test.py
@@ -12,7 +12,6 @@ class TestPackageIDRequirementsModes:
                              [("unrelated_mode", "2.0", "", ""),
                               ("patch_mode", "1.0.0.1", "1.0.1", "1.0.1"),
                               ("minor_mode", "1.0.1", "1.2", "1.2.Z"),
-                              ("minor_mode", "1.0.1", "1.2", "1.2.Z"),
                               ("major_mode", "1.5", "2.0", "2.Y.Z"),
                               ("semver_mode", "1.5", "2.0", "2.Y.Z"),
                               ("full_mode", "1.0", "1.0.0.1", "1.0.0.1")])
@@ -110,3 +109,87 @@ def package_id(self):
         self.assertIn("dep2/1.0@user/testing: PkgNames: ['dep1']", client.out)
         self.assertIn("consumer/1.0@user/testing: PKGNAMES: ['dep1', 'dep2']", client.out)
         self.assertIn("consumer/1.0@user/testing: Created", client.out)
+
+
+class TestRequirementPackageId:
+    """ defining requires(..., package_id_mode)
+    """
+
+    @pytest.mark.parametrize("mode, pattern",
+                             [("patch_mode", "1.2.3"),
+                              ("minor_mode", "1.2.Z"),
+                              ("major_mode",  "1.Y.Z")])
+    def test(self, mode, pattern):
+        c = TestClient(light=True)
+        pkg = GenConanfile("pkg", "0.1").with_requirement("dep/1.2.3", package_id_mode=mode)
+        c.save({"dep/conanfile.py": GenConanfile("dep", "1.2.3"),
+                "pkg/conanfile.py": pkg})
+        c.run("create dep")
+        c.run("create pkg")
+        c.run("list pkg:*")
+        assert f"dep/{pattern}" in c.out
+
+    def test_wrong_mode(self):
+        c = TestClient(light=True)
+        pkg = GenConanfile("pkg", "0.1").with_requirement("dep/1.2.3", package_id_mode="nothing")
+        c.save({"dep/conanfile.py": GenConanfile("dep", "1.2.3"),
+                "pkg/conanfile.py": pkg})
+        c.run("create dep")
+        c.run("create pkg", assert_error=True)
+        assert "ERROR: require dep/1.2.3 package_id_mode='nothing' is not a known package_id_mode" \
+               in c.out
+
+    @pytest.mark.parametrize("mode, pattern",
+                             [("patch_mode", "1.2.3"),
+                              ("minor_mode", "1.2.Z"),
+                              ("major_mode", "1.Y.Z")])
+    def test_half_diamond(self, mode, pattern):
+        # pkg -> libb -> liba
+        #  \----(mode)----/
+        c = TestClient(light=True)
+        pkg = GenConanfile("pkg", "0.1").with_requirement("liba/1.2.3", package_id_mode=mode)\
+                                        .with_requirement("libb/1.2.3")
+        c.save({"liba/conanfile.py": GenConanfile("liba", "1.2.3"),
+                "libb/conanfile.py": GenConanfile("libb", "1.2.3").with_requires("liba/1.2.3"),
+                "pkg/conanfile.py": pkg})
+        c.run("create liba")
+        c.run("create libb")
+        c.run("create pkg")
+        c.run("list pkg:*")
+        assert f"liba/{pattern}" in c.out
+        # reverse order also works the same
+        pkg = GenConanfile("pkg", "0.1").with_requirement("libb/1.2.3")\
+                                        .with_requirement("liba/1.2.3", package_id_mode=mode)
+        c.save({"pkg/conanfile.py": pkg})
+        c.run("create pkg")
+        c.run("list pkg:*")
+        assert f"liba/{pattern}" in c.out
+
+    @pytest.mark.parametrize("mode, pattern",
+                             [("patch_mode", "1.2.3"),
+                              ("minor_mode", "1.2.Z"),
+                              ("major_mode", "1.Y.Z")])
+    def test_half_diamond_conflict(self, mode, pattern):
+        # pkg -> libb --(mode)-> liba
+        #  \----(mode)-----------/
+        # The libb->liba mode is not propagated down to pkg, so it doesn't really conflict
+        c = TestClient(light=True)
+        pkg = GenConanfile("pkg", "0.1").with_requirement("liba/1.2.3", package_id_mode=mode) \
+            .with_requirement("libb/1.2.3")
+        libb = GenConanfile("libb", "1.2.3").with_requirement("liba/1.2.3",
+                                                              package_id_mode="patch_mode")
+        c.save({"liba/conanfile.py": GenConanfile("liba", "1.2.3"),
+                "libb/conanfile.py": libb,
+                "pkg/conanfile.py": pkg})
+        c.run("create liba")
+        c.run("create libb")
+        c.run("create pkg")
+        c.run("list pkg:*")
+        assert f"liba/{pattern}" in c.out
+        # reverse order also works the same
+        pkg = GenConanfile("pkg", "0.1").with_requirement("libb/1.2.3") \
+            .with_requirement("liba/1.2.3", package_id_mode=mode)
+        c.save({"pkg/conanfile.py": pkg})
+        c.run("create pkg")
+        c.run("list pkg:*")
+        assert f"liba/{pattern}" in c.out

EOF_114329324912
: '>>>>> Start Test Output'
python -m pytest . -rA
: '>>>>> End Test Output'
git checkout 28739c763000afc908ebc64eba717b7d01784de1 test/integration/package_id/package_id_requires_modes_test.py
