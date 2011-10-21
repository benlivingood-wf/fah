define :fah, :username => "Anonymous",
             :team => "0",
             :passkey => "" do

  # Store metadata that might be useful to someone.
  node.default[:fah][:username] = params[:username]
  node.default[:fah][:team] = params[:team]
  node.default[:fah][:passkey] = params[:passkey]

  fah_archive = "fah.tgz"
  fah_archive_path = node.default[:fah][:install_dir] + "/" + fah_archive

  fah_dist = if node.default[:kernel][:machine] == "x86_64"
               node.default[:fah][:build64]
             else
               node.default[:fah][:build32]
             end

  # Create the fah install directory.
  directory node.default[:fah][:install_dir] do
    action :create
  end

  # Download the fah distribution.
  remote_file fah_archive_path do
    source fah_dist
    mode "0600"
  end

  # Extract fah inside the install directory.
  execute "extract fah" do
    command "cd " + node.default[:fah][:install_dir] + " && tar xvzf " + fah_archive
  end

  # Render the client configuration file with all of the values passed into this definition.
  template node.default[:fah][:install_dir] + "/client.cfg" do
    source "client.cfg.erb"
    variables(
      :username => params[:username],
      :team => params[:team],
      :passkey => params[:passkey]
    )
  end

  # Render the upstart script using the installation directory as where to run the fah6 binary.
  template "/etc/init/fah.conf" do
    source "fah.conf.erb"
    variables(
      :install_dir => node.default[:fah][:install_dir]
    )
  end

  # Restart the fah service.
  service "fah" do
    provider Chef::Provider::Service::Upstart
    action :restart
  end
end
