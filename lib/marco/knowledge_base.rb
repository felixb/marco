class Marco::KnowledgeBase < Marco::Base

  DEFAULT_STATE = {
      size: 0,
  }

  def initialize(project_id, text_field)
    @project_id = project_id
    @text_field = text_field
    @summaries = MarkyMarkov::Dictionary.new("#{project_id}-summaries")
    @texts = MarkyMarkov::Dictionary.new("#{project_id}-texts")
    begin
      @state = YAML.load(File.read("#{project_id}-state.yaml"))
    rescue Errno::ENOENT
      logger.info "Initialize #{project_id} state"
      @state = DEFAULT_STATE.clone
    end
    logger.debug "Initial size: #{@state[:size]}"
  end

  def size
    @state[:size]
  end

  def learn(issue)
    @summaries.parse_string(issue.summary)
    @texts.parse_string(issue.fields[@text_field])
    @state[:size] += 1
  end

  def generate(num_sentences = 5)
    {
        summary: @summaries.generate_n_sentences(1),
        text: @texts.generate_n_sentences(num_sentences),
    }
  end

  def save!
    @summaries.save_dictionary!
    @texts.save_dictionary!
    File.write("#{@project_id}-state.yaml", @state.to_yaml)
  end

  def wipe!
    MarkyMarkov::Dictionary.delete_dictionary!("#{@project_id}-summaries")
    MarkyMarkov::Dictionary.delete_dictionary!("#{@project_id}-texts")
    FileUtils.rm_f("#{@project_id}-state.yaml")
  end
end
