require 'spec_helper'

describe Marco::IssueWriter do
  before do
    @projects = double(JIRA::Resource::ProjectFactory)
    @project = double(JIRA::Resource::Project)
    @jira = double(JIRA::Client, Project: @projects)
    @kb = double(Marco::KnowledgeBase)
  end

  subject { described_class.new(@jira, 'some-project', @kb) }

  context '.create' do
    it 'creates issues' do
      expect(@kb).to receive(:generate).with(17) { {summary: 'some-summary', text: 'some-text'} }
      expect(@projects).to receive(:find).with('some-project') { @project }
      subject.create(17)
    end
  end
end
