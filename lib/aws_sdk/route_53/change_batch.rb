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

module AWS_SDK
  class Route53
    #
    # = Modify resource record sets with ChangeBatch
    #
    #   batch = AWS_SDK::Route53::ChangeBatch.new(hosted_zone_id)
    #   batch << AWS_SDK::Route53::CreateRequest.new('foo.example.com.', 'A', :resource_records => [{:value => '192.168.0.1'}])
    #   batch << AWS_SDK::Route53::DeleteRequest.new('bar.example.com.', 'CNAME')
    #   batch << AWS_SDK::Route53::DeleteRequest.new('baz.example.com.', 'AAAA')
    #   batch << AWS_SDK::Route53::CreateRequest.new('baz.example.com.', 'AAAA', :resource_records => [{:value => '192.168.0.3'}])
    #
    #   batch.call
    #
    # @attr_reader [String] hosted_zone_id 
    #
    # @attr_reader [Array<ChangeRequest>] changes
    #
    # @attr_reader [String] comment
    #
    class ChangeBatch

      include Enumerable
      include Core::Model

      # @private
      def initialize(hosted_zone_id, options={})
        super(options)
        @hosted_zone_id = hosted_zone_id
        @comment = options[:comment]
        @changes = []
      end

      attr_reader :hosted_zone_id

      attr_reader :changes

      attr_reader :comment

      # @param [ChangeRequest]
      # @return [Array]
      def push(change)
        @changes.push(change)
      end

      alias_method :<<, :push

      # Calls change batch request.
      # @param [Hash]
      # @return [ChangeInfo]
      def call(options={})
        resp = client.change_resource_record_sets(options.merge(self.to_hash))
        if resp[:change_info][:id]
          ChangeInfo.new_from(:change_resource_record_sets,
                              resp[:change_info],
                              resp[:change_info][:id],
                              :config => config)
        end
      end

      # Enumerates over changes.
      def each(&block)
        @changes.each(&block)
      end

      # Returns length of changes.
      # @return [Integer]
      def length
        @changes.length
      end

      alias_method :size, :length

      # Build query from change batch.
      # @return [Hash]
      def to_hash
        q = {}
        q[:hosted_zone_id] = hosted_zone_id
        q[:change_batch] = {}
        q[:change_batch][:comment] = comment if comment
        q[:change_batch][:changes] = []
        self.each { |change|
          q[:change_batch][:changes] << change.to_hash
        }
        q
      end
    end

    class ChangeRequest
      # @private
      def initialize(action, name, type, options={})
        @action = action
        @name = name
        @type = type
        @change_options = options
      end

      # @return [String]
      attr_reader :action

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :type

      # Build query fro change request.
      # @return [Hash]
      def to_hash
        q = {}
        q[:action] = action
        q[:resource_record_set] = {}
        q[:resource_record_set][:name] = name
        q[:resource_record_set][:type] = type
        q[:resource_record_set][:set_identifier] = @change_options[:set_identifier] if @change_options[:set_identifier]
        q[:resource_record_set][:weight] = @change_options[:weight] if @change_options[:weight]
        q[:resource_record_set][:region] = @change_options[:region] if @change_options[:region]
        q[:resource_record_set][:ttl] = @change_options[:ttl] if @change_options[:ttl]
        q[:resource_record_set][:resource_records] = @change_options[:resource_records] if @change_options[:resource_records]
        q[:resource_record_set][:alias_target] = @change_options[:alias_target] if @change_options[:alias_target]
        q
      end
    end

    #
    # A change request to create a resource record set.
    #
    class CreateRequest < ChangeRequest
      # @param [String, String, Hash]
      def initialize(name, type, options={})
        super('CREATE', name, type, options)
      end
    end

    #
    # A change request to delete a resource record set.
    #
    class DeleteRequest < ChangeRequest
      # @param [String, String, Hash]
      def initialize(name, type, options={})
        super('DELETE', name, type, options)
      end
    end
  end
end
