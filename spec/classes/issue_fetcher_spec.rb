require 'spec_helper'

describe Marco::IssueFetcher do
  before do
    @projects = double(JIRA::Resource::ProjectFactory)
    @project = double(JIRA::Resource::Project)
    @jira = double(JIRA::Client, Project: @projects)
    @kb = double(Marco::KnowledgeBase)
  end

  subject { described_class.new(@jira, 'some-project', @kb) }

  context '.fetch' do
    it 'fetches issues' do
      some_issue = double(JIRA::Resource::Issue, key: 'some-key')
      some_other_issue = double(JIRA::Resource::Issue, key: 'some-other-key')

      expect(@projects).to receive(:find).with('some-project') { @project }

      # first loop
      expect(@kb).to receive(:size) { 5 }
      expect(@project).to receive(:issues).with(startAt: 5, maxResults: Marco::IssueFetcher::MAX_RESULTS) { [some_issue, some_other_issue] }
      expect(@kb).to receive(:learn).with(some_issue)
      expect(@kb).to receive(:learn).with(some_other_issue)
      expect(@kb).to receive(:save!)

      # second loop
      expect(@kb).to receive(:size) { 7 }
      expect(@project).to receive(:issues).with(startAt: 7, maxResults: Marco::IssueFetcher::MAX_RESULTS) { [] }
      subject.fetch
    end
  end
end
