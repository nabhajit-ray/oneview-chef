require_relative './../../../spec_helper'

describe 'oneview_test::logical_switch_group_replace_scopes' do
  let(:resource_name) { 'logical_switch_group' }
  include_context 'chef context'

  let(:scope1) { OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope1', uri: '/rest/fake/1') }
  let(:scope2) { OneviewSDK::API300::C7000::Scope.new(client, name: 'Scope2', uri: '/rest/fake/2') }

  before do
    allow(OneviewSDK::API300::C7000::Scope).to receive(:new).and_return(scope1, scope2)
    allow(scope1).to receive(:retrieve!).and_return(true)
    allow(scope2).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:retrieve!).and_return(true)
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:[]).and_call_original
  end

  it 'replace scopes' do
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:[]).with('scopeUris').and_return([])
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:replace_scopes).with([scope1, scope2])
    expect(real_chef_run).to replace_oneview_logical_switch_group_scopes('LogicalSwitchGroup1')
  end

  it 'replace scopes even when already one of scopes added' do
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:[]).with('scopeUris').and_return(['/rest/fake/1'])
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:replace_scopes).with([scope1, scope2])
    expect(real_chef_run).to replace_oneview_logical_switch_group_scopes('LogicalSwitchGroup1')
  end

  it 'does nothing when all scopes are already replaced' do
    allow_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).to receive(:[]).with('scopeUris').and_return(['/rest/fake/2', '/rest/fake/1'])
    expect_any_instance_of(OneviewSDK::API300::C7000::LogicalSwitchGroup).not_to receive(:replace_scopes)
    expect(real_chef_run).to replace_oneview_logical_switch_group_scopes('LogicalSwitchGroup1')
  end
end
