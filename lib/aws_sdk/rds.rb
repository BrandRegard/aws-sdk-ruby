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
require 'aws_sdk/rds/config'

module AWS_SDK

  # This class is the starting point for working with Amazon Relational
  # Database Service (RDS).
  #
  # For more information about RDS:
  #
  # * {Amazon RDS}[http://aws.amazon.com/rds/]
  # * {Amazon RDS Documentation}[http://aws.amazon.com/documentation/rds/]
  #
  # = Credentials
  #
  # You can setup default credentials for all AWS services via
  # AWS.config:
  #
  #   AWS.config(
  #     :access_key_id => 'YOUR_ACCESS_KEY_ID',
  #     :secret_access_key => 'YOUR_SECRET_ACCESS_KEY')
  #
  # Or you can set them directly on the AWS_SDK::RDS interface:
  #
  #   rds = AWS_SDK::RDS.new(
  #     :access_key_id => 'YOUR_ACCESS_KEY_ID',
  #     :secret_access_key => 'YOUR_SECRET_ACCESS_KEY')
  #
  class RDS

    AWS_SDK.register_autoloads(self) do
      autoload :Client, 'client'
      autoload :Errors, 'errors'
      autoload :DBInstance, 'db_instance'
      autoload :DBInstanceCollection, 'db_instance_collection'
      autoload :DBSnapshot, 'db_snapshot'
      autoload :DBSnapshotCollection, 'db_snapshot_collection'
      autoload :Request, 'request'
    end

    include Core::ServiceInterface

    # @return [DBInstanceCollection]
    def db_instances
      DBInstanceCollection.new(:config => config)
    end
    alias_method :instances, :db_instances

    # @return [DBSnapshotCollection]]
    def db_snapshots
      DBSnapshotCollection.new(:config => config)
    end
    alias_method :snapshots, :db_snapshots

  end
end
