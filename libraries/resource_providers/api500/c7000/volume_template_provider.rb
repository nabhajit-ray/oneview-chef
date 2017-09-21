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

module OneviewCookbook
  module API500
    module C7000
      # VolumeTemplate API500 C7000 provider
      class VolumeTemplateProvider < API300::C7000::VolumeTemplateProvider
        def load_resource_with_associated_resources
          validate_presence_of(:storage_system, :storage_pool)
          storage_system = load_storage_system
          root_template = storage_system.get_templates.find { |i| i['isRoot'] }
          storage_pool = resource_named(:StoragePool).find_by(@item.client, name: @new_resource.storage_pool, storageSystemUri: storage_system['uri']).first

          @item.set_root_template(root_template)
          @item.set_default_value('storagePool', storage_pool)
          snapshot_pool = resource_named(:StoragePool).find_by(@item.client, name: @new_resource.snapshot_pool, storageSystemUri: storage_system['uri']).first if @new_resource.snapshot_pool
          @item.set_default_value('snapshotPool', snapshot_pool) if snapshot_pool
        end

        def load_storage_system
          data = {
            hostname: @new_resource.storage_system,
            name: @new_resource.storage_system
          }
          load_resource(:StorageSystem, data)
        end
      end
    end
  end
end
