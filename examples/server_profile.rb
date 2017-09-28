# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

my_client = {
  url: ENV['ONEVIEWSDK_URL'],
  user: ENV['ONEVIEWSDK_USER'],
  password: ENV['ONEVIEWSDK_PASSWORD']
}

# my_server_profile_template = 'spt1'
# my_server_hardware_type = 'SY 480 Gen9 2'
# my_server_hardware = '0000A66101, bay 5'
# my_enclosure_group = 'eg1'
my_server_profile_template = 'spt1'
my_server_hardware_type = 'BL660c Gen9 1'
my_server_hardware = 'Encl1, bay 2'
my_enclosure_group = 'EG_1'

# use this to create server profile with volume attachments using api200 or api300
volume_data_api_200 = {
  name: 'Volume1',
  description: 'volume for api200 or api300',
  provisioningParameters: {
    provisionType: 'Full',
    requestedCapacity: 1024 * 1024 * 1024,
    shareable: false
  }
}

# use this to create server profile with volume attachments using api500 or greater
volume_data_api_500 = {
  name: 'Volume1',
  description: 'Volume store serv for api500',
  size: 1024 * 1024 * 1024,
  provisioningType: 'Thin',
  isShareable: false
}

# use this to add storage paths to volume attachments using api200 or api300
storage_paths_api_200 = [
  {
    isEnabled: true,
    storageTargetType: 'Auto',
    connectionId: 1
  }
]

# use this to add storage paths to volume attachments using api500 or greater
storage_paths_api500 = [
  {
    isEnabled: true,
    targetSelector: 'Auto',
    connectionId: 1
  }
]

# Creates a server profile with the desired Enclosure group and Server hardware type
oneview_server_profile 'ServerProfile1' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
end

# Creates a server profile using a template
# Note that when creating a profile using a template, anything passed into the data property will override
# the template defaults. This may cause the profile to be in an "inconsistent with template" state. Since
# you're using a template, you probably don't want to put much in the data property (if anything); instead,
# update the template.
oneview_server_profile 'ServerProfile2' do
  client my_client
  data(
    description: 'Override Description',
    boot: {
      order: [],
      manageBoot: true
    }
  )
  server_profile_template my_server_profile_template
  server_hardware my_server_hardware
end

# If a profile does get in an inconsistent state, you can update it from it's template. Note that this action
# only works on profiles that already exist. It also does not consider any properties beside the name; it
# purely finds it by name and ensures it is consistent with the template. If the update requires the server to
# go offline, it should fail; you'll need to explicitly power off the server, then try the update again.
oneview_server_profile 'update ServerProfile2 from template' do
  client my_client
  data(name: 'ServerProfile2')
  action :update_from_template
end

# Creates a server profile with the desired Enclosure group and Server hardware type and some connections
oneview_server_profile 'ServerProfile3' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  data(
    macType: 'Virtual',
    wwnType: 'Virtual'
  )
  ethernet_network_connections(
    EthernetNetwork1: {
      name: 'Connection1'
    }
  )
  fc_network_connections(
    FCNetwork1: {
      name: 'Connection2',
      functionType: 'FibreChannel',
      portId: 'Auto'
    }
  )
  fcoe_network_connections(
    fcoe1: {
      name: 'c1',
      functionType: 'FibreChannel',
      portId: 'None'
    }
  )
  action :create_if_missing
end

# Creates or updates ServerProfile3 with multiple boot connections in the same network
oneview_server_profile 'ServerProfile3' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  data(
    bootMode: {
      manageMode: true,
      mode: 'BIOS'
    },
  boot: {
      manageBoot: true
    }
  )
  ethernet_network_connections [
    {
      EthernetNetwork1: {
        name: 'PrimaryBoot',
        boot: {
          priority: "Primary"
        }
      }
    },
    {
      EthernetNetwork1: {
        name: 'SecondaryBoot',
        boot: {
          priority: "Secondary"
        }
      }
    }
  ]
  action :create
end

# Creates on server profile template with the desired Enclosure group and Server hardware type
oneview_server_profile 'ServerProfile4' do
  client my_client
  enclosure_group my_enclosure_group
  server_hardware_type my_server_hardware_type
  fc_network_connections(
    FCNetwork1: {
      id: 1,
      name: 'Connection1',
      functionType: 'FibreChannel',
      portId: 'Auto'
    }
  )
  volume_attachments(
    [
      {
        volume: 'test2',
        attachment_data: {
          id: 1,
          lunType: 'Auto',
          storagePaths: storage_paths_api_200
        }
      },
      {
        volume_data: volume_data_api_200,
        storage_system: 'ThreePAR-1',
        storage_pool: 'cpg-growth-limit-1TiB',
        host_os_type: 'Windows 2012 / WS2012 R2',
        attachment_data: {
          id: 2,
          lunType: 'Auto',
          storagePaths: storage_paths_api_200
        }
      }
    ]
  )
end

# Clean up the profiles:
oneview_server_profile 'Delete ServerProfile1' do
  client my_client
  data(name: 'ServerProfile1')
  action :delete
end

oneview_server_profile 'Delete ServerProfile2' do
  client my_client
  data(name: 'ServerProfile2')
  action :delete
end

oneview_server_profile 'Delete ServerProfile3' do
  client my_client
  data(name: 'ServerProfile3')
  action :delete
end

oneview_server_profile 'ServerProfile4' do
  client my_client
  action :delete
end
