#
# Cookbook Name:: image_streamer_test_api300
# Recipe:: os_build_plan_create
#
# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

image_streamer_os_build_plan 'OSBuildPlan1' do
  client node['image_streamer_test']['client']
  data(
    description: 'Chef created OS Build Plan',
    oeBuildPlanType: 'Deploy'
  )
  action :create
end
