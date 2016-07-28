module Lita
  module Handlers
    class Bamboo < Handler

      namespace 'Bamboo'
      config :url, required: true, type: String  # https://host:port/rest/api/latest
      config :verify_ssl, required: true, types: [TrueClass, FalseClass], default: false
      config :user, required: true, type: String
      config :password, required: true, type: String

      include ::LitaBambooHelper::Plan

      route(
        /^bamboo\s+list\s+project[s]?\s*$/,
        :cmd_list_projects,
        command: true,
        help: {
          t('help.cmd_list_projects_key') => t('help.cmd_list_projects_value')
        }
      )

      route(
        /^bamboo\s+list\s+project\s+(\S+)\s+plans$/,
        :cmd_list_project_plans,
        command: true,
        help: {
          t('help.cmd_list_project_plans_key') => t('help.cmd_list_project_plans_value')
        }
      )

      route(
        /^bamboo\s+list\s+plan\s+(\S+)\s+results\s+limit\s+(\d+)\s*$/,
        :cmd_list_plan_results,
        command: true,
        help: {
          t('help.cmd_list_plan_results_key') => t('help.cmd_list_plan_results_value')
        }
      )

      route(
        /^bamboo\s+list\s+queue\s*$/,
        :cmd_list_queue,
        command: true,
        help: {
          t('help.cmd_list_queue_key') => t('help.cmd_list_queue_value')
        }
      )

      route(
        /^bamboo\s+queue\s+(\S+)$/,
        :cmd_queue_plan,
        command: true,
        help: {
          t('help.cmd_queue_plan_key') => t('help.cmd_queue_plan_value')
        }
      )

      route(
        /^bamboo\s+dequeue\s+(\S+)$/,
        :cmd_dequeue_plan,
        command: true,
        help: {
          t('help.cmd_dequeue_plan_key') => t('help.cmd_dequeue_plan_value')
        }
      )

      def cmd_list_projects(response)
        begin
          info = list_projects
          response.reply info.join "\n"
        rescue Exception => e
          response.reply e.message
        end
      end

      def cmd_list_project_plans(response)
        proj_id = response.matches[0][0]
        begin
          info = list_project_plan(proj_id)
          response.reply info.join "\n"
        rescue Exception => e
          response.reply e.message
        end
      end

      def cmd_list_plan_results(response)
        plan_id = response.matches[0][0]
        limit = response.matches[0][1]
        begin
          info = list_plan_build(plan_id, Integer(limit))
          response.reply info.join "\n"
        rescue Exception => e
          response.reply e.message
        end
      end

      def cmd_queue_plan(response)
        plan_id = response.matches[0][0]
        begin
          success = queue_plan(plan_id)
          unless success
            response.reply "Failed to queue plan #{plan_id}"
          end
        rescue Exception => e
          response.reply e.message
        end
      end

      def cmd_dequeue_plan(response)
        build_id = response.matches[0][0]
        begin
          success = dequeue_plan(build_id)
          unless success
            response.reply "Failed to dequeue plan build #{build_id}"
          end
        rescue Exception => e
          response.reply e.message
        end
      end

      def cmd_list_queue(response)
        begin
          info = list_queue
          response.reply info
        rescue Exception => e
          response.reply e.message
        end
      end

      Lita.register_handler(self)

    end
  end
end
