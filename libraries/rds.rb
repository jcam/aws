require 'open-uri'

module Opscode
  module Aws
    module Rds
      def rds
        begin
          require 'right_aws'
        rescue LoadError
          Chef::Log.error("Missing gem 'right_aws'. Use the default aws recipe to install it first.")
        end

        region = instance_availability_zone
        region = region[0, region.length-1]
        @@rds ||= RightAws::RdsInterface.new(new_resource.aws_access_key, new_resource.aws_secret_access_key, { :logger => Chef::Log, :region => region })
      end
    end # module Rds
  end
end
