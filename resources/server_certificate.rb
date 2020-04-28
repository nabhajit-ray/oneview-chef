# (c) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

OneviewCookbook::ResourceBaseProperties.load(self)

default_action :none

action :none do
end

action :import_certificate do
  OneviewCookbook::Helper.do_resource_action(self, :ServerCertificate, :import_certificate)
end

action :remove_certificate do
  OneviewCookbook::Helper.do_resource_action(self, :ServerCertificate, :remove_certificate)
end

action :update_certificate do
  OneviewCookbook::Helper.do_resource_action(self, :ServerCertificate, :update_certificate)
end
