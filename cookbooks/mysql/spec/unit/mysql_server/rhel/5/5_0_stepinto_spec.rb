require 'spec_helper'

describe 'stepped into mysql_test_custom::server 5.0 on centos-5.8' do
  let(:centos_5_8_default_run) do
    ChefSpec::Runner.new(
      :step_into => 'mysql_service',
      :platform => 'centos',
      :version => '5.8'
      ) do |node|
      node.set['mysql']['service_name'] = 'centos_5_8_default'
      node.set['mysql']['version'] = '5.0'
      node.set['mysql']['port'] = '3308'
      node.set['mysql']['data_dir'] = '/data'
      node.set['mysql']['template_source'] = 'custom.erb'
    end.converge('mysql_test_custom::server')
  end

  let(:my_cnf_5_5_content_centos_5_8) do
    'This my template. There are many like it but this one is mine.'
  end

  before do
    stub_command("/usr/bin/mysql -u root -e 'show databases;'").and_return(true)
  end

  context 'when using default parameters' do
    it 'creates mysql_service[centos_5_8_default]' do
      expect(centos_5_8_default_run).to create_mysql_service('centos_5_8_default').with(
        :version => '5.0',
        :port => '3308',
        :data_dir => '/data'
        )
    end

    it 'steps into mysql_service and installs package[mysql-server]' do
      expect(centos_5_8_default_run).to install_package('mysql-server')
    end

    it 'steps into mysql_service and creates directory[/var/run/mysqld]' do
      expect(centos_5_8_default_run).to create_directory('/var/run/mysqld').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates directory[/data]' do
      expect(centos_5_8_default_run).to create_directory('/data').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates template[/etc/my.cnf]' do
      expect(centos_5_8_default_run).to create_template('/etc/my.cnf').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0600'
        )
    end

    it 'steps into mysql_service and creates service[mysqld]' do
      expect(centos_5_8_default_run).to start_service('mysqld')
      expect(centos_5_8_default_run).to enable_service('mysqld')
    end

    it 'steps into mysql_service and creates execute[assign-root-password]' do
      expect(centos_5_8_default_run).to run_execute('assign-root-password').with(
        :command => '/usr/bin/mysqladmin -u root password ilikerandompasswords'
        )
    end

    it 'steps into mysql_service and creates template[/etc/mysql_grants.sql]' do
      expect(centos_5_8_default_run).to create_template('/etc/mysql_grants.sql').with(
        :cookbook => 'mysql',
        :owner => 'root',
        :group => 'root',
        :mode => '0600'
        )
    end

    it 'steps into mysql_service and creates execute[install-grants]' do
      expect(centos_5_8_default_run).to_not run_execute('install-grants').with(
        :command => '/usr/bin/mysql -u root -pilikerandompasswords < /etc/mysql_grants.sql'
        )
    end

    it 'steps into mysql_service and renders file[/etc/my.cnf]' do
      expect(centos_5_8_default_run).to render_file('/etc/my.cnf').with_content(my_cnf_5_5_content_centos_5_8)
    end

    it 'steps into mysql_service and creates bash[move mysql data to datadir]' do
      expect(centos_5_8_default_run).to_not run_bash('move mysql data to datadir')
    end
  end
end
