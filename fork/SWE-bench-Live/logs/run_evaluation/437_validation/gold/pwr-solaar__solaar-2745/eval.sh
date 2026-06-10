#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 382e0b6797af1dd7a3ec05365d23fe95f974c8c8 tests/logitech_receiver/test_hidpp20_simple.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/logitech_receiver/test_hidpp20_simple.py b/tests/logitech_receiver/test_hidpp20_simple.py
index 031b7fc3d..f68c09923 100644
--- a/tests/logitech_receiver/test_hidpp20_simple.py
+++ b/tests/logitech_receiver/test_hidpp20_simple.py
@@ -107,7 +107,7 @@ def test_get_battery_voltage():
     feature, battery = _hidpp20.get_battery_voltage(device)
 
     assert feature == SupportedFeature.BATTERY_VOLTAGE
-    assert battery.level == 90
+    assert battery.level == 92
     assert common.BatteryStatus.RECHARGING in battery.status
     assert battery.voltage == 0x1000
 
@@ -130,7 +130,7 @@ def test_get_adc_measurement():
     feature, battery = _hidpp20.get_adc_measurement(device)
 
     assert feature == SupportedFeature.ADC_MEASUREMENT
-    assert battery.level == 90
+    assert battery.level == 92
     assert battery.status == common.BatteryStatus.RECHARGING
     assert battery.voltage == 0x1000
 
@@ -389,7 +389,7 @@ def test_decipher_battery_voltage():
     feature, battery = hidpp20.decipher_battery_voltage(report)
 
     assert feature == SupportedFeature.BATTERY_VOLTAGE
-    assert battery.level == 90
+    assert battery.level == 92
     assert common.BatteryStatus.RECHARGING in battery.status
     assert battery.voltage == 0x1000
 
@@ -410,7 +410,7 @@ def test_decipher_adc_measurement():
     feature, battery = hidpp20.decipher_adc_measurement(report)
 
     assert feature == SupportedFeature.ADC_MEASUREMENT
-    assert battery.level == 90
+    assert battery.level == 92
     assert battery.status == common.BatteryStatus.RECHARGING
     assert battery.voltage == 0x1000
 
@@ -449,3 +449,36 @@ def test_feature_flag_names(code, expected_flags):
 )
 def test_led_zone_locations(code, expected_name):
     assert hidpp20.LEDZoneLocations[code] == expected_name
+
+
+@pytest.mark.parametrize(
+    "millivolt, expected_percentage",
+    [
+        (-1234, 0),
+        (500, 0),
+        (2000, 0),
+        (3500, 0),
+        (3519, 0),
+        (3520, 1),
+        (3559, 1),
+        (3579, 2),
+        (3646, 5),
+        (3671, 10),
+        (3717, 20),
+        (3751, 30),
+        (3778, 40),
+        (3811, 50),
+        (3859, 60),
+        (3922, 70),
+        (3989, 80),
+        (4067, 90),
+        (4180, 99),
+        (4181, 100),
+        (4186, 100),
+        (4500, 100),
+    ],
+)
+def test_estimate_battery_level_percentage(millivolt, expected_percentage):
+    percentage = hidpp20.estimate_battery_level_percentage(millivolt)
+
+    assert percentage == expected_percentage

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 382e0b6797af1dd7a3ec05365d23fe95f974c8c8 tests/logitech_receiver/test_hidpp20_simple.py
