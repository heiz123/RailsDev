# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'CentOS_6.5'
  # For Windows
  # config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5-i386_chef-provisionerless.box'
  # For Mac and Unix
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # cakephpを使うために必要
  config.vm.synced_folder 'vagrant', '/home/vagrant'

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :info
    chef.cookbooks_path = './site-cookbooks'
    chef.run_list = %w(base nginx mysql56 database ruby_build rbenv::system ruby_gem)

    chef.json = {
        mysql: {
            password: 'abc123'
        },
        rbenv: {
            rubies: ['2.1.2'],
            global: '2.1.2',
            gems: {
                '2.1.2' => [
                    {
                        name: 'bundler',
                        options: '--no-ri --no-rdoc'
                    },
                    {
                        name: 'rails',
                        options: '--no-ri --no-rdoc'
                    }
                ]
            }
        },
        nginx: {
            application: 'chef_rails',
        }
    }
  end
end
