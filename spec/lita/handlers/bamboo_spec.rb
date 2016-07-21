require "spec_helper"

describe Lita::Handlers::Bamboo, lita_handler: true do
  before do
    registry.config.handlers.bamboo.url = 'https://bamboo.entertainment.com/rest/api/latest'
    registry.config.handlers.bamboo.verify_ssl = false
  end
  it do
    is_expected.to route_command('bamboo list project').to(:cmd_list_projects)
    is_expected.to route_command('bamboo list project AG plans').to(:cmd_list_project_plans)
    is_expected.to route_command('bamboo list plan AG-FPMWIL results limit 1').to(:cmd_list_plan_results)
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
end
