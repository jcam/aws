include Opscode::Aws::Rds
include Opscode::Aws::Ec2

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  if rds_instance
    Chef::Log.warn("Modifying RDS instances not yet supported.")
  else
    create_instance
  end
end

action :delete do
  if rds_instance
    delete_instance
  else
    Chef::Log.debug("RDS instance #{new_resource.name} does not exist")
  end
end

private

def get_instance
  begin
    rds_instance = rds.describe_db_instances(new_resource.name).first
    return true
  rescue RightAws::AwsError => e
    if e.message =~ /^DBInstanceNotFound/
      return false
    else
      raise e
    end
  end
end

def create_instance
  params = {
    :instance_class => new_resource.flavor,
    :engine => new_resource.engine,
    :multi_az => new_resource.multi_az,
    :auto_minor_version_upgrade => new_resource.auto_minor_version_upgrade,
    :db_security_groups =>
      group_names_to_objs(
        new_resource.db_security_groups ).map{|g| g[:group_id]}
  }

  params[:backup_retention_period] = new_resource.backup_retention_period unless new_resource.backup_retention_period.nil?
  params[:db_parameter_group]      = new_resource.db_parameter_group unless new_resource.db_parameter_group.nil?
  params[:engine_version]          = new_resource.engine_version unless new_resource.engine_version.nil?
  params[:db_subnet_group_name]    = new_resource.db_subnet_group_name unless new_resource.db_subnet_group_name.nil?
  params[:iops]                    = new_resource.iops unless new_resource.iops.nil?
  params[:option_group_name]       = new_resource.option_group_name unless new_resource.option_group_name.nil?
  params[:db_name]                 = new_resource.db_name unless new_resource.db_name.nil?
  params[:availability_zone]       = new_resource.availability_zone unless new_resource.availability_zone.nil?
  params[:db_subnet_group_name]    = new_resource.db_subnet_group_name unless new_resource.db_subnet_group_name.nil?

  params.merge!(new_resource.custom) unless new_resource.custom.nil?

  rds.create_db_instance( new_resource.name,
                          new_resource.master_username,
                          new_resource.master_user_password,
                          params )
end # create_instance

def delete_instance
  rds.delete_db_instance(new_resource.name)
end
