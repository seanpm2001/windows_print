#
# Cookbook:: windows_print
# Resource:: driver
#
# Copyright:: 2013, Texas A&M
#

unified_mode true

property :driver_name, String, name_property: true
property :inf_path, String, required: true
property :inf_file, String, required: true
property :version, String, default: 'Type 3 - User Mode'
property :environment, String, default: 'x64'
property :domain_username, String
property :domain_password, String

action :install do
  if driver_exists?
    Chef::Log.debug("#{new_resource.driver_name} already installed - nothing to do.")
  else
    converge_by "Install Printer Driver #{new_resource.driver_name}" do
      Chef::Log.debug("pnputil.exe /a #{new_resource.inf_path}\\#{new_resource.inf_file}\"")
      Chef::Log.debug("Add-PrinterDriver -Name \"#{new_resource.driver_name}\"")
      powershell_script 'Add driver to Windows Store' do
        code "pnputil.exe /a \"#{new_resource.inf_path}\\#{new_resource.inf_file}\""
      end
      powershell_script "Installing print driver: #{new_resource.driver_name}" do
        code "Add-PrinterDriver -Name \"#{new_resource.driver_name}\""
      end
      Chef::Log.info("#{new_resource.driver_name} installed.")
    end
  end
end

action :delete do
  if exists?
    converge_by "Delete Printer Driver #{new_resource.driver_name}" do
      execute "Deleting print driver: #{new_resource.driver_name}" do
        command "rundll32 printui.dll PrintUIEntry /dd /m \"#{new_resource.driver_name}\" /h \"#{new_resource.environment}\" /v \"#{new_resource.version}\""
      end
    end
  else
    Chef::Log.debug("#{new_resource.driver_name} doesn't exist - can't delete.")
  end
end

action_class do
  def driver_exists?
    case new_resource.environment
    when 'x64'
      check = powershell_out("Get-wmiobject -Class Win32_PrinterDriver -EnableAllPrivileges | where {$_.name -like '#{new_resource.driver_name},3,Windows x64'} | fl name").run_command
      Chef::Log.debug("\"#{new_resource.driver_name}\" x64 driver found.")
    when 'x86'
      check = powershell_out("Get-wmiobject -Class Win32_PrinterDriver -EnableAllPrivileges | where {$_.name -like '#{new_resource.driver_name},3,Windows NT x86'} | fl name").run_command
      Chef::Log.debug("\"#{new_resource.driver_name}\" x86 driver found.")
    when 'Itanium'
      check = powershell_out("Get-wmiobject -Class Win32_PrinterDriver -EnableAllPrivileges | where {$_.name -like '#{new_resource.driver_name},3,Itanium'} | fl name").run_command
      Chef::Log.debug("\"#{new_resource.driver_name}\" xItanium driver found.")
    else
      Chef::Log.debug('Please use \"x64\", \"x86\" or \"Itanium\" as the environment type')
    end
    check.stdout.include?(new_resource.driver_name)
  end

  # Attempt to prevent typos in new_resource.name
  def driver_name
    case new_resource.environment
    when 'x64'
      File.readlines(new_resource.inf_path).grep(/NTamd64/)
      # Grab Next line String Between " and " and make that new_resource.name
    when 'x86'
      File.readlines(new_resource.inf_path).grep(/NTx86/)
      # Grab Next line String Between " and " and make that new_resource.name
    when 'Itanium'
      File.readlines(new_resource.inf_path).grep(/NTx86/)
      # Grab Next line String Between " and " and make that new_resource.name
    else
      Chef::Log.debug('Please use \"x64\", \"x86\" or \"Itanium\" as the environment type')
    end
  end
end
