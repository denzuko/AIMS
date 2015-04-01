require 'rubygems'
require 'rack'
require 'sinatra'
require 'data_mapper'
require 'json'

require './lib/ims/rpcapi'

#Dir.glob('./lib/*/{controllers,helpers}/*.rb') {|f| require f}
Dir.glob('./models/*.rb') {|f| require f}

IMS::RpcApi.configure do
	#enable :logging

	file = File.new("#{File.dirname(__FILE__)}/log/#{ENV['RACK_ENV']}.environment.log", "a+")
	file.sync = true

	use Rack::CommonLogger, file

	set :sessions	=> false
	set :run, true
	set :environment, :production
end

DataMapper::setup(:default, "sqlite://#{Dir.pwd}/ims.db" )
DataMapper.finalize.auto_upgrade!

map('/') { run IMS::RpcApi }
