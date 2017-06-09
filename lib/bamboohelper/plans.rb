require 'json'
require 'rest-client'
module LitaBambooHelper
  module Plan
    def list_projects
      url = "#{config.url}/project.json"
      info = []
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        json_response = JSON.parse(response)
        if json_response['projects']['project']
          json_response['projects']['project'].each do |proj|
            info << "[#{proj['key']}] : #{proj['name']}"
          end
        end
      rescue Exception=>e
        raise "Error to list projects :#{e.message}"
      end
      info
    end

    def list_project_plan(proj_id)
      url = "#{config.url}/project/#{proj_id}.json?expand=plans"
      info = []
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        json_response = JSON.parse(response)
        if json_response['plans']['plan']
          json_response['plans']['plan'].each do |plan|
            info << "[#{plan['key']}] : #{plan['name']} Enabled: #{plan['enabled']}"
          end
        end
      rescue Exception=>e
        raise "Error to list plans :#{e.message}"
      end
      info
    end

    def list_plan_build(plan_id, last=1)
      count =last -1
      if count<0
        count=0
      end
      puts "***#{count}"
      url = "#{config.url}/result/#{plan_id}.json?expand=results[0:#{count}].result.labels"
      info = []
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        json_response = JSON.parse(response)
        if json_response['results']['result']
          json_response['results']['result'].each do |result|
            labels = []
            if result['labels']['label']
              result['labels']['label'].each do |label|
                labels << label['name']
              end
            end
            info << "[#{result['buildResultKey']}] : Successful=#{result['successful'] ? 'T' : 'F'} Finished=#{result['finished'] ? 'T' : 'F'} NotRunYet=#{result['notRunYet'] ? 'T' : 'F'} Start: #{result['prettyBuildStartedTime']} Complete: #{result['prettyBuildCompletedTime']} Label: #{labels.to_s}"
          end
        end
      rescue Exception=>e
        raise "Error to list build results :#{e.message}"
      end
      info
    end

    def queue_plan(plan_id)
      url = "#{config.url}/queue/#{plan_id}?os_authType=basic"
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :post,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        if response.code == 200
          true
        else
          false
        end
      rescue Exception=>e
        raise "Error to queue plan #{plan_id} for build :#{e.message}"
      end
    end

    def dequeue_plan(build_id)
      url = "#{config.url}/queue/#{build_id}?os_authType=basic"
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :delete,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        if response.code == 200
          true
        else
          false
        end
      rescue Exception=>e
        raise "Error to dequeue plan build #{build_id} :#{e.message}"
      end
    end

    def list_queue()
      url = "#{config.url}/queue.json?os_authType=basic"
      info = []
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        json_response = JSON.parse(response)
        if json_response['queuedBuilds']['queuedBuild']
          json_response['queuedBuilds']['queuedBuild'].each do |result|
            info << "BuildKey: #{result['buildResultKey']} TrigerReason: #{result['triggerReason']} "
          end
        end
      rescue Exception=>e
        raise "Error to list build queue :#{e.message}"
      end
      info.to_s
    end

    def get_server_info
      url = "#{config.url}/info.json?os_authType=basic"
      info = {}
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        info = JSON.parse(response)
      rescue Exception=>e
        raise "Error to get server info :#{e.message}"
      end
    end

    def get_server_version
      info = get_server_info
      info['version']
    end

    def get_build_labels(build_id)
      url = "#{config.url}/result/#{build_id}/label.json"
      info = []
      begin
        response = RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :get,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        json_response = JSON.parse(response)
        if json_response['labels']['label']
          json_response['labels']['label'].each do |result|
            info << "[#{result['name']}]"
          end
        end
      rescue Exception=>e
        raise "Error to list build queue :#{e.message}"
      end
      info.join(',')
    end #def

    def add_build_label(build_id, label)
      url = "#{config.url}/result/#{build_id}/label"
      payload = {'name' =>  "#{label}"}
      headers = {'Content-Type'=> 'application/json'}
      info = []
      begin
        RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :post,
          :user => config.user,
          :password => config.password,
          :payload =>payload,
          :headers => headers
        )
        true
      rescue Exception=>e
        raise "Error to add label to build result :#{e.message}"
      end
    end #def

    def delete_build_label(build_id, label)
      url = "#{config.url}/result/#{build_id}/#{label}"
      begin
        RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :delete,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        true
      rescue Exception=>e
        raise "Error to delete label from build result :#{e.message}"
      end
    end #def

    def pause_server()
      url = "#{config.url}/server/pause"
      begin
        RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :post,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        true
      rescue Exception=>e
        raise "Error to pause bamboo server:#{e.message}"
      end
    end

    def resume_server()
      url = "#{config.url}/server/resume"
      begin
        RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :post,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        true
      rescue Exception=>e
        raise "Error to resume bamboo server :#{e.message}"
      end
    end

    def prepare_restart()
      url = "#{config.url}/server/prepareForRestart"
      begin
        RestClient::Request.execute(
          :url => url,
          :verify_ssl => config.verify_ssl,
          :method=> :put,
          :user => config.user,
          :password => config.password,
          :headers => {
            :accept => :json,
            :content_type => :json
          }
        )
        true
      rescue Exception=>e
        raise "Error to prepare bamboo server to restart :#{e.message}"
      end
    end

  end #module
end
