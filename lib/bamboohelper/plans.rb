require 'json'
module LitaBambooHelper
  module Plan
    def list_projects
      url = "#{config.url}/project.json"
      info = []
      begin
        response = RestClient::Request.execute(:url => url, :verify_ssl => config.verify_ssl, :method=> :get)
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
        response = RestClient::Request.execute(:url => url, :verify_ssl => config.verify_ssl, :method=> :get)
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
        response = RestClient::Request.execute(:url => url, :verify_ssl => config.verify_ssl, :method=> :get)
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
      url = "#{config.url}/queue/#{plan_id}"
      begin
        response = RestClient::Request.execute(:url => url, :verify_ssl => config.verify_ssl, :method=> :post)
        if response.code == 200
          true
        else
          false
        end
      rescue Exception=>e
        raise "Error to queue paln for build :#{e.message}"
      end
    end

    def list_queue()
      url = "#{config.url}/queue?os_authType=basic"
      info = []
      begin
        response = RestClient::Request.execute(:url => url, :verify_ssl => config.verify_ssl, :method=> :get)
        json_response = JSON.parse(response)
        if json_response['results']['result']
          json_response['results']['result'].each do |result|
            info << "[#{result['buildResultKey']}] : Successful=#{result['successful']} Finished=#{result['finished']} NotRunYet=#{result['notRunYet']} Start: #{result['prettyBuildStartedTime']} Complete: #{result['prettyBuildCompletedTime']}"
          end
        end
      rescue Exception=>e
        raise "Error to list build results :#{e.message}"
      end
      info
    end
  end #module
end
