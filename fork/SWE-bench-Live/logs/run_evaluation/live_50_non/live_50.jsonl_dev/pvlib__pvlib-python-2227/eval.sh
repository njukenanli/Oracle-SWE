#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout b9946b236d49e43335935d2bb0e3c4b38b997757 pvlib/tests/test_pvsystem.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/pvlib/tests/test_pvsystem.py b/pvlib/tests/test_pvsystem.py
index c98c201af4..fd482c5127 100644
--- a/pvlib/tests/test_pvsystem.py
+++ b/pvlib/tests/test_pvsystem.py
@@ -1870,7 +1870,6 @@ def test_PVSystem_get_irradiance(solar_pos):
                                        irrads['dni'],
                                        irrads['ghi'],
                                        irrads['dhi'])
-
     expected = pd.DataFrame(data=np.array(
         [[883.65494055, 745.86141676, 137.79352379, 126.397131, 11.39639279],
          [0., -0., 0., 0., 0.]]),
@@ -1881,6 +1880,23 @@ def test_PVSystem_get_irradiance(solar_pos):
     assert_frame_equal(irradiance, expected, check_less_precise=2)
 
 
+def test_PVSystem_get_irradiance_float():
+    system = pvsystem.PVSystem(surface_tilt=32, surface_azimuth=135)
+    irrads = {'dni': 900., 'ghi': 600., 'dhi': 100.}
+    zenith = 55.366831
+    azimuth = 172.320038
+    irradiance = system.get_irradiance(zenith,
+                                       azimuth,
+                                       irrads['dni'],
+                                       irrads['ghi'],
+                                       irrads['dhi'])
+    expected = {'poa_global': 884.80903423, 'poa_direct': 745.84258835,
+                'poa_diffuse': 138.96644588, 'poa_sky_diffuse': 127.57005309,
+                'poa_ground_diffuse': 11.39639279}
+    for k, v in irradiance.items():
+        assert np.isclose(v, expected[k], rtol=1e-6)
+
+
 def test_PVSystem_get_irradiance_albedo(solar_pos):
     system = pvsystem.PVSystem(surface_tilt=32, surface_azimuth=135)
     irrads = pd.DataFrame({'dni': [900, 0], 'ghi': [600, 0], 'dhi': [100, 0],

EOF_114329324912
: '>>>>> Start Test Output'
pytest pvlib --cov=./ --cov-report=xml --ignore=pvlib/tests/iotools -rA
: '>>>>> End Test Output'
git checkout b9946b236d49e43335935d2bb0e3c4b38b997757 pvlib/tests/test_pvsystem.py
