#!/bin/bash -xe

MASTER_PROFILE=xx
GD_ADMIN_ACCOUNT_PROFILE=xx
GD_ADMIN_ACCOUNT=xxx

# first bit to allow org based auto-enable
aws --profile ${MASTER_PROFILE} organizations enable-aws-service-access --service-principal guardduty.amazonaws.com

# beware this creats a detector in the account if there isn't one
# delegate the account so don't have to do gd administration in master
aws --profile ${MASTER_PROFILE} guardduty enable-organization-admin-account --admin-account-id ${GD_ADMIN_ACCOUNT}

# auto enables the new accounts as they come on board (won't affect legacy)
DETECTOR_ID=$(aws --profile ${GD_ADMIN_ACCOUNT_PROFILE} guardduty list-detectors --query DetectorIds --output text)
aws --profile ${GD_ADMIN_ACCOUNT_PROFILE} guardduty update-organization-configuration --detector-id ${DETECTOR_ID} --auto-enable
