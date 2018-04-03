describe 'datadog::repository' do
  context 'on debianoids' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian', version: '8.9'
      ).converge(described_recipe)
    end

    it 'include apt cookbook' do
      expect(chef_run).to include_recipe('apt::default')
    end

    it 'installs apt-transport-https' do
      expect(chef_run).to install_package('install-apt-transport-https')
    end

    it 'sets up an apt repo' do
      expect(chef_run).to add_apt_repository('datadog').with(
        key: ['A2923DFF56EDA6E76E55E492D3A80E30382E94DE']
      )
    end

    it 'removes the datadog-beta repo' do
      expect(chef_run).to remove_apt_repository('datadog-beta')
    end
  end
end
