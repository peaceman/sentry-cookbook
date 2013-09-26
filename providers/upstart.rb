action :init do
  Chef::Log.info("Make instance via upstart #{new_resource.name}")


  # Start webservice
  # sentry --config=/etc/sentry.conf.py start
  service new_resource.name do
    supports :status => true, :restart => true, :reload => true
    provider Chef::Provider::Service::Upstart
  end

  template "/etc/init/#{new_resource.name}.conf" do
      mode 0700
      source "upstart.conf.erb"
      variables(:user => new_resource.user,
                :group => new_resource.group,
                :virtualenv => new_resource.virtualenv,
                :config => new_resource.config,
                :port => new_resource.port,
                :host => new_resource.host,
                :name => new_resource.name)
      notifies :restart, "service[#{new_resource.name}]"
  end

end
