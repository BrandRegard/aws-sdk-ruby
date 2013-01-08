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

require 'spec_helper'
require 'thread'

describe AWS_SDK do

  context '#config' do

    it 'should return a configuration object' do
      AWS_SDK.config.should be_a(AWS_SDK::Core::Configuration)
    end

    it 'should pass options through to Configuration#with' do
      previous = AWS_SDK.config
      previous.should_receive(:with).with(:access_key_id => "FOO")
      AWS_SDK.config(:access_key_id => "FOO")
    end

    it 'should return the same config when no options are added' do
      AWS_SDK.config.should be(AWS_SDK.config)
    end

  end

  context '#stub!' do

    it 'should set the config :stub_clients to true' do
      AWS_SDK.should_receive(:config).with(:stub_requests => true)
      AWS_SDK.stub!
    end
    
  end

  context '#start_memoizing' do

    after(:each) { AWS_SDK.stop_memoizing }

    it 'should enable memoization' do
      AWS_SDK.start_memoizing
      AWS_SDK.memoizing?.should be_true
    end

    it 'should return nil' do
      AWS_SDK.start_memoizing.should be_nil
    end

    it 'should not extend into other threads' do
      AWS_SDK.start_memoizing
      Thread.new do
        AWS_SDK.memoizing?.should be_false
      end.join
    end

  end

  context '#stop_memoizing' do

    it 'should do nothing if memoization is disabled' do
      AWS_SDK.memoizing?.should be_false
      AWS_SDK.stop_memoizing
      AWS_SDK.memoizing?.should be_false
    end

    it 'should stop memoization' do
      AWS_SDK.start_memoizing
      AWS_SDK.memoizing?.should be_true
      AWS_SDK.stop_memoizing
      AWS_SDK.memoizing?.should be_false
    end

    it 'should only affect the current thread' do
      AWS_SDK.start_memoizing
      t = Thread.new do
        AWS_SDK.start_memoizing
        Thread.stop
        AWS_SDK.memoizing?.should be_true
      end
      Thread.pass until t.stop?
      AWS_SDK.stop_memoizing
      t.wakeup
      t.join
    end

  end

  context '#memoize' do

    before(:each) do
      AWS_SDK.stub(:start_memoizing)
      AWS_SDK.stub(:stop_memoizing)
    end

    it 'should call start_memoization' do
      AWS_SDK.should_receive(:start_memoizing)
      AWS_SDK.memoize { }
    end

    it 'should call stop_memoization at the end of the block' do
      AWS_SDK.memoize do
        AWS_SDK.should_receive(:stop_memoizing)
      end
    end

    it 'should call stop_memoization for an exceptional exit' do
      AWS_SDK.memoize do
        AWS_SDK.should_receive(:stop_memoizing)
        raise "FOO"
      end rescue nil
    end

    it 'should return the return value of the block' do
      AWS_SDK.memoize { "foo" }.should == "foo"
    end

    context 'while already memoizing' do

      it 'should do nothing' do
        AWS_SDK.stub(:memoizing?).and_return(true)
        AWS_SDK.should_not_receive(:start_memoizing)
        AWS_SDK.should_not_receive(:stop_memoizing)
        AWS_SDK.memoize { }
      end

    end

  end

  shared_examples_for "memoization cache" do

    context 'memoizing' do

      before(:each) { AWS_SDK.start_memoizing }
      after(:each) { AWS_SDK.stop_memoizing }

      it 'should return a resource cache object' do
        AWS_SDK.send(method).should be_a(cache_class)
      end

      it 'should return a different cache each time memoization is enabled' do
        cache = AWS_SDK.send(method)
        AWS_SDK.stop_memoizing
        AWS_SDK.start_memoizing
        AWS_SDK.send(method).should_not be(cache)
      end

      it 'should return a different cache in each thread' do
        cache = AWS_SDK.send(method)
        Thread.new do
          AWS_SDK.memoize { AWS_SDK.send(method).should_not be(cache) }
        end.join
      end

    end

    context 'not memoizing' do

      it 'should return nil' do
        AWS_SDK.send(method).should be_nil
      end

    end

  end

  context '#resource_cache' do
    let(:method) { :resource_cache }
    let(:cache_class) { AWS_SDK::Core::ResourceCache }
    it_should_behave_like "memoization cache"
  end

  context '#response_cache' do
    let(:method) { :response_cache }
    let(:cache_class) { AWS_SDK::Core::ResponseCache }
    it_should_behave_like "memoization cache"
  end

  context '#config' do

    context "SERVICE_region" do

      it 'returns REGION when endpoint is SERVICE.REGION.amazonaws.com' do
        AWS_SDK.config.stub(:ec2_endpoint).and_return('ec2.REGION.amazonaws.com')
        AWS_SDK.config.ec2_region.should == 'REGION'
      end

      it 'returns us-east-1 when endpoint is SERVCIE.amazonaws.com' do
        AWS_SDK.config.stub(:ec2_endpoint).and_return('ec2.amazonaws.com')
        AWS_SDK.config.ec2_region.should == 'us-east-1'
      end

      it 'returns us-gov-west-1 when endpoint is ec2.us-gov-west-1.amazonaws.com' do
        AWS_SDK.config.stub(:ec2_endpoint).and_return('ec2.us-gov-west-1.amazonaws.com')
        AWS_SDK.config.ec2_region.should == 'us-gov-west-1'
      end

      it 'returns us-gov-west-2 when endpoint is s3-fips-us-gov-west-1.amazonaws.com' do
        AWS_SDK.config.stub(:s3_endpoint).and_return('s3-fips-us-gov-west-2.amazonaws.com')
        AWS_SDK.config.s3_region.should == 'us-gov-west-2'
      end

      it 'returns us-gov-west-1 when endpoint is iam.us-gov.amazonaws.com' do
        AWS_SDK.config.stub(:iam_endpoint).and_return('iam.us-gov.amazonaws.com')
        AWS_SDK.config.iam_region.should == 'us-gov-west-1'
      end

    end

  end

end
