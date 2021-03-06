require 'puppet/parameter/boolean'
require 'puppet_x/gms/type'

module Puppet
  Puppet::Type.newtype(:git_webhook) do
    include PuppetX::GMS::Type

    @doc = %q{TODO
    }

    ensurable do
      defaultvalues
      defaultto :present
    end

    newparam(:name, :namevar => true) do
      desc 'A unique title for the key that will be provided to the prefered Git management system. Required.'
    end

    newparam(:webhook_url) do
      desc 'The URL the webhook will trigger upon a commit to the respective respository. Required. NOTE: GitHub & GitLab only.'
      validate do |value|
        unless value =~ /^(https?:\/\/)?(\S*\:\S*\@)?(\S*)\.?(\S*)\.?(\w*):?(\d*)\/?(\S*)$/
          raise(Puppet::Error, "Git webhook URL must be fully qualified, not '#{value}'")
        end
      end
    end

    add_parameter_token
    add_parameter_token_file
    add_parameter_username
    add_parameter_password

    newparam(:project_id) do
      desc 'The project ID associated with the project.'
      munge do |value|
        Integer(value)
      end
    end

    newparam(:project_name) do
      desc 'The project name associated with the project. Required.'
      munge do |value|
        String(value)
      end
    end

    newparam(:repo_name) do
      desc 'The name of the repository associated with the webhook. Required. NOTE: Stash only.'
      munge do |value|
        String(value)
      end
    end

    newparam(:hook_exe) do
      desc 'The absolute path to the exectuable triggered when a commit has been made to the respository. Required. NOTE: Stash only.'
      munge do |value|
        String(value)
      end
    end

    newparam(:hook_exe_params) do
      desc 'The parameters to be passed along side of the executable that will be triggered when a commit has been made to the repository. Optional. NOTE: Stash only.'
      munge do |value|
        String(value)
      end
    end

    newparam(:merge_request_events, :boolean => true, :parent => Puppet::Parameter::Boolean) do
      desc 'The URL in the webhook_url parameter will be triggered when a merge request is created. Optional. NOTE: GitLab only'

      defaultto false
    end

    newparam(:tag_push_events, :boolean => true, :parent => Puppet::Parameter::Boolean) do
      desc 'The URL in the webhook_url parameter will be triggered when a tag push event occurs. Optional. NOTE: GitLab only'

      defaultto false
    end

    newparam(:issue_events, :boolean => true, :parent => Puppet::Parameter::Boolean) do
      desc 'The URL in the webhook_url parameter will be triggered when an issue event occurs. Optional. NOTE: GitLab only.'

      defaultto false
    end

    newparam(:disable_ssl_verify, :boolean => true, :parent => Puppet::Parameter::Boolean) do
      desc 'Boolean value for disabling SSL verification for this webhook. Optional. NOTE: GitHub only'

      defaultto false
    end

    newparam(:server_url) do
      desc 'The URL path to the Git management system server. Required.'
      validate do |value|
        #unless value =~ /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
        unless value =~ /^(https?:\/\/).*:?.*\/?$/
          raise(Puppet::Error, "Git server URL must be fully qualified, not '#{value}'")
        end
      end
    end

    validate do
      validate_token_or_token_file
    end

  end
end

