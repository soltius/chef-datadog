describe 'datadog::oracle' do
  context 'config 1' do
    expected_yaml = <<-EOF
    logs: ~
    init_config:
     custom_queries:
       - metric_prefix: oracle.custom_query
         query: |  # Use the pipe if you require a multi-line script.
           SELECT columns
           FROM tester.test_table
           WHERE conditions
         columns:
           # Put this for any column you wish to skip:
           # - {}
           - name: metric1
             type: gauge
           - name: tag1
             type: tag
           - name: metric2
             type: count
         tags:
         - tester:oracle
    instances:
      - server: localhost:1521
        service_name: my_sid
        user: my_username
        password: my_password
        tags:
          - test_tag_name
  EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
        node.set['datadog'] = {
          api_key: 'someapikey',
          oracle: {
            instances: [
              {
                server: 'localhost:1521',
                user: 'my_user',
                password: 'my_password',
                service_name: 'my_sid',
                tags: ['test_tag_name']
              }
            ],
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('oracle') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/oracle.d/oracle.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end

describe 'datadog::oracle' do
  context 'config 2' do
    expected_yaml = <<-EOF
    init_config: ~
    logs: ~

    instances:
      - server: localhost:1521
        service_name: my_sid
        user: my_username
        password: my_password
        tags:
          - test_tag_name
  EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
        node.set['datadog'] = {
          api_key: 'someapikey',
          oracle: {
            instances: [
              {
                server: 'localhost:1521',
                user: 'my_user',
                password: 'my_password',
                service_name: 'my_sid',
                tags: ['test_tag_name']
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('oracle') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/oracle.d/oracle.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
