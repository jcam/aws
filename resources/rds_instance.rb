actions :create, :delete

default_action :create

attribute :aws_access_key,              :kind_of => String, :required => true
attribute :aws_secret_access_key,       :kind_of => String, :required => true
attribute :master_username,             :kind_of => String, :required => true
attribute :master_user_password,        :kind_of => String, :required => true
attribute :flavor,                      :kind_of => String, :required => true
attribute :engine,                      :default => 'mysql'
attribute :name,                        :kind_of => String, :name_attribute => true, :required => true
attribute :multi_az,                    :default => false
attribute :backup_retention_period,     :kind_of => Integer
attribute :db_parameter_group,          :kind_of => String
attribute :engine_version,              :kind_of => String
attribute :auto_minor_version_upgrade,  :default => false
attribute :db_subnet_group_name,        :kind_of => String
attribute :iops,                        :kind_of => Integer
attribute :option_group_name,           :kind_of => String
attribute :db_security_groups,          :kind_of => Array, :required => true
attribute :custom,                      :kind_of => Hash
