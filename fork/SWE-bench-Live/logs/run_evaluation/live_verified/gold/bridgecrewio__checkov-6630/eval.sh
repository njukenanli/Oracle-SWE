#!/bin/bash
set -uxo pipefail
cd /testbed
git config --global --add safe.directory /testbed
cd /testbed
git checkout e1a17d5af24185b8bc1952c8c46af130fce90794 tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf
git apply --verbose --reject - <<'EOF_114329324912'
diff --git a/tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml b/tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml
index 2da6e98fc0..c24d6f77f3 100644
--- a/tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml
+++ b/tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml
@@ -8,6 +8,7 @@ pass:
   - "aws_security_group.pass_codestar"
   - "aws_security_group.pass_dax_cluster"
   - "aws_security_group.pass_dms"
+  - "aws_security_group.pass_dms_serverless"
   - "aws_security_group.pass_docdb"
   - "aws_security_group.pass_ec2"
   - "aws_security_group.pass_ec2_client_vpn"
diff --git a/tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf b/tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf
index 6cf99c8f22..7e1ff6a949 100644
--- a/tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf
+++ b/tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf
@@ -141,6 +141,36 @@ resource "aws_dms_replication_instance" "pass_dms" {
   vpc_security_group_ids     = [aws_security_group.pass_dms.id]
 }
 
+#DMS Serverless
+
+resource "aws_security_group" "pass_dms_serverless" {
+  ingress {
+    description = "TLS from VPC"
+    from_port   = 443
+    to_port     = 443
+    protocol    = "tcp"
+    cidr_blocks = ["0.0.0.0/0"]
+  }
+}
+
+resource "aws_dms_replication_config" "pass_dms_serverless" {
+  replication_config_identifier = "dms"
+  resource_identifier           = "dms"
+  replication_type              = "cdc"
+  source_endpoint_arn           = "aws_dms_endpoint.source.endpoint_arn"
+  target_endpoint_arn           = "aws_dms_endpoint.target.endpoint_arn"
+  table_mappings                = <<EOF
+  {
+    "rules":[{"rule-type":"selection","rule-id":"1","rule-name":"1","rule-action":"include","object-locator":{"schema-name":"%%","table-name":"%%"}}]
+  }
+EOF
+
+  compute_config {
+    max_capacity_units           = "1"
+    vpc_security_group_ids       = [aws_security_group.pass_dms_serverless.id]
+  }
+}
+
 # DocDB
 
 resource "aws_security_group" "pass_docdb" {

EOF_114329324912
: '>>>>> Start Test Output'
pipenv run pytest -rA
: '>>>>> End Test Output'
git checkout e1a17d5af24185b8bc1952c8c46af130fce90794 tests/terraform/graph/checks/resources/SGAttachedToResource/expected.yaml tests/terraform/graph/checks/resources/SGAttachedToResource/main.tf
