require "spec_helper"

describe Lita::Handlers::Bamboo, lita_handler: true do
  before do
    registry.config.handlers.bamboo.url = 'https://bamboo.entertainment.com/rest/api/latest'
    registry.config.handlers.bamboo.verify_ssl = false
    registry.config.handlers.bamboo.user = 'dummy'
    registry.config.handlers.bamboo.password = 'pass'
  end
  it do
    is_expected.to route_command('bamboo list project').to(:cmd_list_projects)
    is_expected.to route_command('bamboo list project AG plans').to(:cmd_list_project_plans)
    is_expected.to route_command('bamboo list plan AG-FPMWIL results limit 1').to(:cmd_list_plan_results)
    is_expected.to route_command('bamboo list queue').to(:cmd_list_queue)
    is_expected.to route_command('bamboo queue PM-RVMGEMSET').to(:cmd_queue_plan)
    is_expected.to route_command('bamboo dequeue PM-RVMGEMSET-8').to(:cmd_dequeue_plan)
    is_expected.to route_command('bamboo get labels PM-BUILDPM-195').to(:cmd_get_labels)
    is_expected.to route_command('bamboo info').to(:cmd_get_info)
    is_expected.to route_command('bamboo add label LABLE1 to GE-BUILD-1').to(:cmd_add_label)
    is_expected.to route_command('bamboo delete label LABLE1 from GE-BUILD-1').to(:cmd_delete_label)
    is_expected.to route_command('bamboo pause').to(:cmd_pause)
    is_expected.to route_command('bamboo resume').to(:cmd_resume)
    is_expected.to route_command('bamboo prepare restart').to(:cmd_prepare_restart)
  end

  describe '#get all project list' do
    #let(:robot) { Lita::Robot.new(registry) }
    it 'fecth list of projects' do
      send_command('bamboo list project')
      puts replies.last
      #expect(replies.last).to match(/repositoryPath/)
    end
  end

  describe '#get project plan list' do
    #let(:robot) { Lita::Robot.new(registry) }
    it 'fecth list of plan in project' do
      send_command('bamboo list project AG plans')
      puts replies.last
      #expect(replies.last).to match(/repositoryPath/)
    end
  end

  describe '#get project plan results' do
    #let(:robot) { Lita::Robot.new(registry) }
    it 'fecth list of plan build results' do
      send_command('bamboo list plan PM-BUILDPM results limit 2')
      puts replies.last
      #expect(replies.last).to match(/repositoryPath/)
    end
  end

  describe '#manage build queue' do
    it 'list build queue' do
      send_command('bamboo list queue')
      puts replies.last
    end
    it 'queue plan' do
      send_command('bamboo queue PM-RVMGEMSET')
      puts replies.last
    end
    it 'dequeue plan' do
      send_command('bamboo dequeue PORJ-PLAN-8')
      puts replies.last
    end
  end

  describe '#get server info' do
    it 'show server info' do
      send_command('bamboo info')
      puts replies.last
    end
  end

  describe '#manage bulid label' do
    it 'get build labels' do
      send_command('bamboo get labels PM-BUILDPM-195')
      puts replies.last
    end
    it 'add label to build' do
      send_command('bamboo add label LABEL1 to TEST-PLAN-1')
      puts replies.last
    end
    it 'delete label to build' do
      send_command('bamboo delete label LABEL1 from TEST-PLAN-1')
      puts replies.last
    end
  end

  describe '#manager server state' do
    it 'pause server' do
      send_command('bamboo pause')
      puts replies.last
    end
    it 'resume server' do
      send_command('bamboo resume')
      puts replies.last
    end
    it 'prepare restart' do
      send_command('bamboo prepare restart')
      puts replies.last
    end
  end

end
