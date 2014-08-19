require 'spec_helper'

describe 'stepped into mysql_test_custom::server on omnios-151006' do
  let(:smartos_13_4_0_default_stepinto_run) do
    ChefSpec::Runner.new(
      :step_into => 'mysql_service',
      :platform => 'smartos',
      :version => '5.11' # Do this for now until Ohai can identify SmartMachines
      ) do |node|
      node.set['mysql']['service_name'] = 'smartos_13_4_0_default_stepinto'
      node.set['mysql']['version'] = '5.6'
      node.set['mysql']['port'] = '3308'
      node.set['mysql']['data_dir'] = '/data'
      node.set['mysql']['template_source'] = 'custom.erb'
    end.converge('mysql_test_custom::server')
  end

  let(:my_cnf_5_5_content_smartos_13_4_0) do
    'This my template. There are many like it but this one is mine.'
  end

  before do
    stub_command("/opt/local/bin/mysql -u root -e 'show databases;'").and_return(true)
  end

  context 'when using default parameters' do
    it 'creates mysql_service[smartos_13_4_0_default_stepinto]' do
      expect(smartos_13_4_0_default_stepinto_run).to create_mysql_service('smartos_13_4_0_default_stepinto')
    end

    it 'steps into mysql_service and installs the package' do
      expect(smartos_13_4_0_default_stepinto_run).to install_package('mysql-server').with(
        :version => '5.6'
        )
    end

    it 'steps into mysql_service and creates the include directory' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/opt/local/etc/mysql/conf.d').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates the run directory' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/var/run/mysql').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0755',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates the data directory' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/data').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates the data directory data subdirectory' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/data/data').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates the data directory data/mysql' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/data/data/mysql').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates the data directory data/test' do
      expect(smartos_13_4_0_default_stepinto_run).to create_directory('/data/data/test').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0750',
        :recursive => true
        )
    end

    it 'steps into mysql_service and creates my.conf' do
      expect(smartos_13_4_0_default_stepinto_run).to create_template('/opt/local/etc/my.cnf').with(
        :owner => 'mysql',
        :group => 'mysql',
        :mode => '0600'
      )
    end

    it 'steps into mysql_service and creates my.conf' do
      expect(smartos_13_4_0_default_stepinto_run).to render_file('/opt/local/etc/my.cnf').with_content(my_cnf_5_5_content_smartos_13_4_0)
    end

    it 'steps into mysql_service and creates a bash resource' do
      expect(smartos_13_4_0_default_stepinto_run).to_not run_bash('move mysql data to datadir')
    end

    it 'steps into mysql_service and initializes the mysql database' do
      expect(smartos_13_4_0_default_stepinto_run).to run_execute('initialize mysql database').with(
        :command => '/opt/local/bin/mysql_install_db --datadir=/data --user=mysql'
        )
    end

    it 'steps into mysql_service and creates the service method' do
      expect(smartos_13_4_0_default_stepinto_run).to create_template('/opt/local/lib/svc/method/mysqld').with(
        :cookbook => 'mysql',
        :owner => 'root',
        :group => 'root',
        :mode => '0555'
        )
    end

    it 'steps into mysql_service and creates /tmp/mysql.xml' do
      expect(smartos_13_4_0_default_stepinto_run).to create_template('/tmp/mysql.xml').with(
        :cookbook => 'mysql',
        :owner => 'root',
        :group => 'root',
        :mode => '0644'
        )
    end

    it 'steps into mysql_service and imports the mysql service manifest' do
      expect(smartos_13_4_0_default_stepinto_run).to_not run_execute('import mysql manifest').with(
        :command => 'svccfg import /tmp/mysql.xml'
        )
    end

    it 'steps into mysql_service and manages the mysql service' do
      expect(smartos_13_4_0_default_stepinto_run).to start_service('mysql')
      expect(smartos_13_4_0_default_stepinto_run).to enable_service('mysql')
    end

    it 'steps into mysql_service and waits for mysql to start' do
      expect(smartos_13_4_0_default_stepinto_run).to run_execute('wait for mysql').with(
        :command => 'until [ -S /tmp/mysql.sock ] ; do sleep 1 ; done',
        :timeout => 10
        )
    end

    it 'steps into mysql_service and assigns root password' do
      expect(smartos_13_4_0_default_stepinto_run).to run_execute('assign-root-password').with(
        :command => '/opt/local/bin/mysqladmin -u root password ilikerandompasswords'
        )
    end

    it 'steps into mysql_service and creates /etc/mysql_grants.sql' do
      expect(smartos_13_4_0_default_stepinto_run).to create_template('/opt/local/etc/mysql_grants.sql').with(
        :cookbook => 'mysql',
        :owner => 'root',
        :group => 'root',
        :mode => '0600'
        )
    end

    it 'steps into mysql_service and installs grants' do
      expect(smartos_13_4_0_default_stepinto_run).to_not run_execute('install-grants').with(
        :command => '/opt/mysql55/bin/mysql -u root -pilikerandompasswords < /etc/mysql_grants.sql'
        )
    end
  end
end
