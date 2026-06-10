#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout 9d83ecd0aee6ae60318e67b50d903b1368a7635f tests/providers/test_bank.py
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/providers/test_bank.py b/tests/providers/test_bank.py
index a0692e681a..12ccff56cf 100644
--- a/tests/providers/test_bank.py
+++ b/tests/providers/test_bank.py
@@ -467,17 +467,16 @@ def test_bban(self, faker, num_samples):
             assert re.fullmatch(r"\d{12}", bban)
             account_number = bban[:-2]
             check_digits = int(bban[-2:])
-            assert (97 - (int(account_number) % 97)) == check_digits or check_digits == 97
+            assert (int(account_number) % 97) == check_digits or check_digits == 97
 
     def test_iban(self, faker, num_samples):
         for _ in range(num_samples):
             iban = faker.iban()
             assert iban[:2] == NlBeBankProvider.country_code
             assert re.fullmatch(r"\d{2}\d{12}", iban[2:])
-            bban = iban[4:]
-            account_number = bban[:-2]
-            check_digits = int(bban[-2:])
-            assert (97 - (int(account_number) % 97)) == check_digits or check_digits == 97
+            rearranged_iban = iban[4:] + iban[:4]
+            numeric_iban = "".join(str(ord(char) - 55) if char.isalpha() else char for char in rearranged_iban)
+            assert int(numeric_iban) % 97 == 1
 
     def test_swift8_use_dataset(self, faker, num_samples):
         for _ in range(num_samples):

EOF_114329324912
: '>>>>> Start Test Output'
pytest -rA
: '>>>>> End Test Output'
git checkout 9d83ecd0aee6ae60318e67b50d903b1368a7635f tests/providers/test_bank.py
