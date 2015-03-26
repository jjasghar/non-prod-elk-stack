require 'spec_helper'

describe 'non-prod-elk-stack::default' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  describe file('/opt/kibana') do
    it { should be_directory }
  end
  describe file('/etc/logstash/conf.d/logstash.conf') do
    it { should be_file }
  end
  describe file('/etc/init.d/kibana4') do
    it { should be_file }
  end

  describe service('logstash') do
    it { should be_running }
  end
  describe service('elasticsearch') do
    it { should be_running }
  end

  describe service('kibana4') do
    it { should be_running }
  end

end
