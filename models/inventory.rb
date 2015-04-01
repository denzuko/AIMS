require 'data_mapper'
require 'json'

module IMS
	module Models
		class Inventory
			include DataMapper::Resource

			property :id, Serial, :key => true
			property :added_on, DateTime, :default => lambda { |p,s| DateTime.now }
			property :location, String
			property :environment, String
			property :name, String
			property :vlan, String
			property :internal_ip, String
			property :external_ip, String
			property :client_name, String
			property :fqdn, String
			property :ssl, Boolean, :default => false
			property :details, String

			def to_json(*a)
				{
				   'guid'	=> self.id,
				   'host'	=> {
					   'name'	 => self.name,
					   'internal_ip' => self.internal_ip,
					   'external_ip' => self.internal_ip,
					   'fqdn'	 => self.fqdn,
					   'client_name' => self.client_name
				   }
				}
			end

			REQUIRED = [:client, :internal_ip, :name]

			def self.parse_json(body)
				json = JSON.parse(body)
				ret = { :client => json[:client], :name => json[:name], :internal_ip => json[:internal_ip] }

				return nil if REQUIRED.find { |r| ret[r].nil? }
				ret
			end
		end
	end
end
