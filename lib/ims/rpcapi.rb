require 'sinatra/base'

module IMS
	class RpcApi < Sinatra::Base

	
		before do
			content_type :json
			content_type "application/json;charset=UTF-8;"
			# json = JSON.parse(request.body.read)
		end

		not_found do
			response['Location'] = "/"
			content_type "application/json;charset=UTF-8;"
			halt 404, "#{{ 'error' => 'URL not found' }.to_json}"
		end

		error do
			content_type :json
			{ error => pamars['captures'].first.inspect }.to_json
		end

		post "/asset" do

			json = JSON.parse(request.body.read)

			if json.nil? halt 422, "#{{ 'error' => 'Empty asset data received'}.to_json}}"

			found = Model::Inventory.first :client => json[:client], :name => json[:name], 
						:internal_ip => json[:internal_ip]

			if found
				halt 409, "#{{ 'error' => 'asset exists' }.to_json}"
			else
				asset = Model::Inventory.new params

				if asset.save
					response['Location'] = "/asset/${asset['id']}"
					status 201
				else 
					halt 400, "#{{ 'error' => 'The request cannot be fulfilled'}.to_json}"
				end
			end
		end

		get "/asset" do
			{ 'inventory' => Array(Model::Inventory.all(:order => [:id.desc,:client_name.desc])) }.to_json
		end


		post %r{/asset/\d+} do

			asset   = Model::Inventory.get! params[:id]
			success = host.update! params[:asset]

			if success
				status 200
			else
				halt 400, "#{{ 'error' => 'The request cannot be fulfilled'}.to_json}"
			end
		end

		delete %r{/asset/\d+} do
			@asset = Model::Inventory.get(params[:id])

			if @asset
				{:success => "ok"}.to_json
			else
				halt 404, { "failed" => "asset item not found" }.to_json
			end
				
		end

		get %r{/asset/\d+} do

			content_type :json

			asset = Model::Inventory.get params[:id]

			if asset
				asset.to_json
			else
				error_msg={ :failed => 'asset id not found'}.to_json
				halt(404,error_msg) unless asset
			end
		end

		get %r{/asset/\d+/\w+} do
			halt(501,{ :failed => 'unimplemented api call'}.to_json)
		end

		get %r{/asset/(new|view)} do
			send_file "./public/index.html"
		end

		get %r{/asset/\w\+} do
			halt(501,{ :failed => 'unimplemented api call'}.to_json)
		end

		get "/index.json" do
			Model::Inventory.all(:order => [:id.desc,:client_name.desc]).to_json
		end

		get %r{/index(|.html)$} do
			content_type :html
			send_file './public/index.html'
		end

		get "/" do
			redirect "/index.json"
		end

		post "/" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			halt 405, error_msg
		end

		put "/" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		delete "/" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		post "/:context" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		put "/:context" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		delete "/:context" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		get "/:context" do
			error_msg={ :failed => 'api call not allowed'}.to_json
			status 405
		end

		run! if app_file == $0
	end
end
end
