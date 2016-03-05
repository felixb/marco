class Marco::IssueFetcher < Marco::Base

  MAX_RESULTS = 50

  def initialize(jira, project_id, knowledge_base)
    @jira = jira
    @project_id = project_id
    @knowledge_base = knowledge_base
  end

  def fetch
    project = @jira.Project.find(@project_id)

    loop do
      startAt = @knowledge_base.size
      issues = project.issues(startAt: startAt, maxResults: MAX_RESULTS)
      break if issues.size == 0

      logger.info "Parsing #{issues.size} issues #{issues.first.key}..#{issues.last.key}"
      issues.each { |issue| @knowledge_base.learn(issue) }
      @knowledge_base.save!
    end
  end
end
