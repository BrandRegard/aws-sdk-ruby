# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'aws_sdk/core'

require 'aws_sdk/auto_scaling/config'
require 'aws_sdk/cloud_front/config'
require 'aws_sdk/cloud_formation/config'
require 'aws_sdk/cloud_search/config'
require 'aws_sdk/cloud_watch/config'
require 'aws_sdk/data_pipeline/config'
require 'aws_sdk/dynamo_db/config'
require 'aws_sdk/ec2/config'
require 'aws_sdk/elasticache/config'
require 'aws_sdk/elastic_beanstalk/config'
require 'aws_sdk/emr/config'
require 'aws_sdk/elb/config'
require 'aws_sdk/iam/config'
require 'aws_sdk/import_export/config'
require 'aws_sdk/glacier/config'
require 'aws_sdk/rds/config'
require 'aws_sdk/route_53/config'
require 'aws_sdk/s3/config'
require 'aws_sdk/simple_db/config'
require 'aws_sdk/simple_email_service/config'
require 'aws_sdk/simple_workflow/config'
require 'aws_sdk/sns/config'
require 'aws_sdk/sqs/config'
require 'aws_sdk/storage_gateway/config'
require 'aws_sdk/sts/config'

module AWS_SDK
  register_autoloads(self) do
    autoload :AutoScaling, 'auto_scaling'
    autoload :CloudFormation, 'cloud_formation'
    autoload :CloudFront, 'cloud_front'
    autoload :CloudSearch, 'cloud_search'
    autoload :CloudWatch, 'cloud_watch'
    autoload :DataPipeline, 'data_pipeline'
    autoload :DynamoDB, 'dynamo_db'
    autoload :EC2, 'ec2'
    autoload :ElastiCache, 'elasticache'
    autoload :ElasticBeanstalk, 'elastic_beanstalk'
    autoload :EMR, 'emr'
    autoload :ELB, 'elb'
    autoload :IAM, 'iam'
    autoload :ImportExport, 'import_export'
    autoload :Glacier, 'glacier'
    autoload :RDS, 'rds'
    autoload :Route53, 'route_53'
    autoload :S3, 's3'
    autoload :SimpleDB, 'simple_db'
    autoload :SimpleEmailService, 'simple_email_service'
    autoload :SimpleWorkflow, 'simple_workflow'
    autoload :SNS, 'sns'
    autoload :SQS, 'sqs'
    autoload :StorageGateway, 'storage_gateway'
    autoload :STS, 'sts'
    autoload :Record, 'record'
  end
end

require 'aws_sdk/rails'
