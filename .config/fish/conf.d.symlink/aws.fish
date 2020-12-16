# AWS Vault
set -x AWS_VAULT_KEYCHAIN_NAME login
set -x AWS_SESSION_TTL 12h
set -x AWS_ASSUME_ROLE_TTL 1h

# AWS
function unset_aws
  for aws_var in AWS_ACCESS_KEY_ID AWS_DEFAULT_REGION AWS_REGION AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN AWS_VAULT
		set -e $aws_var
	end
end

function assume-aws
  if test grep -q "[okta]" ~/.aws/config; then
    set -l aws_cmd aws-okta
  else
    set -l aws_cmd aws-vault
	end

  unset_aws
  eval ($aws_cmd exec $argv -- env | grep -E "^AWS_" | sed -e "s/^/export\ /")
  AWS_PAGER="" aws --output text --query Arn sts get-caller-identity
end

function aws-get-console-output
  aws ec2 get-console-output --instance-id $argv[1] | jq -r '.Output'
end

function aws-get-that-ip
  AWS_PAGER="" aws ec2 describe-instances \
    --filter Name=network-interface.addresses.private-ip-address,Values=$argv[1] \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output text
end
