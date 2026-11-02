
from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck


class S3PublicAccessCheck(BaseResourceCheck):

    def __init__(self):
        name = "Ensure S3 bucket blocks all public access"
        id = "CKV_CUSTOM_1"
        supported_resources = ("aws_s3_bucket_public_access_block",)
        categories = (CheckCategories.NETWORKING,)

        super().__init__(
            name=name,
            id=id,
            categories=categories,
            supported_resources=supported_resources
        )

    def scan_resource_conf(self, conf):
        required_settings = [
            "block_public_acls",
            "block_public_policy",
            "ignore_public_acls",
            "restrict_public_buckets"
        ]

        for setting in required_settings:
            value = conf.get(setting, [False])

            if isinstance(value, list):
                value = value[0] if value else False

            if value is not True:
                return CheckResult.FAILED

        return CheckResult.PASSED


check = S3PublicAccessCheck()
