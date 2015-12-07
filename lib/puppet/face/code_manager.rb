require 'puppet'
require 'puppet/face'
require 'json'
require 'puppet/network/http'
require 'puppet/network/http_pool'
require 'puppet/network/http/nocache_pool'
require 'uri'

Puppet::Face.define(:code_manager, '0.1.0') do
  description <<-DESCRIPTION
The code_manager face is used to interact with the code-manager service to 
deploy environments.
DESCRIPTION
  summary "Used to work with the code-manager service to deploy environments"
  copyright "Puppet Labs", 2015
  author "puppetlabs"
  notes "No notes at this time."

  action :startall do
    summary "Start a deploy of all environments."

    post_body = {"deploy-all" => true}

    option '-w', '--wait' do
      summary "Wait for the code-manager service to return"
      default_to { false }
    end

    option '-s SERVER', '--cmserver SERVER' do
      summary "Code manager server name"
      default_to { nil }
    end

    option '-p PORT', '--cmport PORT' do
      summary "Code manager port on server"
      default_to { nil }
    end

    option '-t TOKENFILE', '--tokenfile TOKENFILE' do
      summary "File containing RBAC authorization token"
      default_to { nil }
    end

    when_invoked do |options|
      deploy_call = DeployCall.new(post_body, options)
      deploy_call.result
    end
  end

  action :start do
    summary "Start a deploy of one environment"
    arguments "<environment>"

    post_body = {}

    option '-w', '--wait' do
      summary "Wait for the code-manager service to return."
      default_to { false }
    end

    option '-s SERVER', '--cmserver SERVER' do
      summary "Code manager server name"
      default_to { nil }
    end

    option '-p PORT', '--cmport PORT' do
      summary "Code manager port on server"
      default_to { nil }
    end

    option '-t TOKENFILE', '--tokenfile TOKENFILE' do
      summary "File containing RBAC authorization token"
      default_to { nil }
    end

    when_invoked do |environment, options|
      post_body["environments"] = [ environment ]
      deploy_call = DeployCall.new(post_body, options)
      deploy_call.result
    end
  end
end

# Class to actually do the deploy call across multiple actions
class DeployCall
  DEFAULT_CODE_MANAGER_PORT = 8170
  CODE_MANAGER_PATH = "code-manager/v1/deploys"

  def initialize(post_body, options)
    @post_body = post_body
    if options[:wait]
      @post_body[:wait] = true
    end

    token_file = options[:tokenfile] || File.join(Dir.home, '.puppetlabs', 'token')

    if File.file?(token_file)
      token = File.read(token_file).gsub('\n','')
    else
      raise "Token file does not exist or is not readable."
    end

    Puppet.settings.preferred_run_mode = "master"
    code_manager_host = options[:cmserver] || Puppet[:ca_server]
    code_manager_port = options[:cmport] || DEFAULT_CODE_MANAGER_PORT
    @code_manager_all = "https://#{code_manager_host}:#{code_manager_port}/#{CODE_MANAGER_PATH}?token=#{token}"
  end

  def result
    uri = URI(@code_manager_all)
    Puppet.override(:http_pool => Puppet::Network::HTTP::NoCachePool.new) do
      conn = Puppet::Network::HttpPool.http_instance(uri.host, uri.port)
      response = conn.post(uri.request_uri, @post_body.to_json, {'Content-Type' =>'application/json'})
      JSON.pretty_generate(JSON.parse(response.body))
    end
  end
end
