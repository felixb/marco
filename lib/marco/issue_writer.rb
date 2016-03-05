class Marco::IssueWriter < Marco::Base

  def initialize(jira, project_id, knowledge_base)
    @jira = jira
    @project_id = project_id
    @knowledge_base = knowledge_base
  end

  def create(num_sentences = 5)
    project = @jira.Project.find(@project_id)
    issue = @knowledge_base.generate(num_sentences)
    logger.info "Generating new ticket for project #{@project_id}"
    logger.info "Summary: #{issue[:summary]}"
    logger.info "Text: #{issue[:text]}"
  end
end
