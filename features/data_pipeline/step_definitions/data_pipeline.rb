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

Before("@data_pipeline") do

  @data_pipeline = AWS_SDK::DataPipeline.new
  @data_pipeline_client = @data_pipeline.client

  @pipelines = []

end

After("@data_pipeline") do

  @pipelines.each do |pipe|
    @data_pipeline_client.delete_pipeline :pipeline_id => pipe.pipeline_id
  end

end
