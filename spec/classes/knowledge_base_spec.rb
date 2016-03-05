require 'spec_helper'

describe Marco::KnowledgeBase do

  context '.init' do
    subject { described_class }

    it 'loads saved markov data' do
      @summaries = double(MarkyMarkov::Dictionary)
      @texts = double(MarkyMarkov::Dictionary)
      expect(MarkyMarkov::Dictionary).to receive(:new).with('some-project-summaries') { @summaries }
      expect(MarkyMarkov::Dictionary).to receive(:new).with('some-project-texts') { @texts }
      expect(File).to receive(:read).with('some-project-state.yaml') { :state }
      expect(YAML).to receive(:load).with(:state) { {size: 23} }

      kb = subject.new('some-project', 'customfield_9001')
      expect(kb.size).to eq(23)
    end
  end

  context 'methods' do
    subject { described_class.new('some-project', 'customfield_9001') }

    before do
      @summaries = double(MarkyMarkov::Dictionary)
      @texts = double(MarkyMarkov::Dictionary)
      allow(MarkyMarkov::Dictionary).to receive(:delete_dictionary!).with('some-project-summaries')
      allow(MarkyMarkov::Dictionary).to receive(:delete_dictionary!).with('some-project-texts')
      allow(FileUtils).to receive(:rm_f).with('some-project-state.yaml')

      allow(MarkyMarkov::Dictionary).to receive(:new).with('some-project-summaries') { @summaries }
      allow(MarkyMarkov::Dictionary).to receive(:new).with('some-project-texts') { @texts }
      allow(@summaries).to receive(:parse_string)
      allow(@texts).to receive(:parse_string)
    end

    context '.learn' do
      it 'parses summary and text' do
        issue = double(JIRA::Resource::Issue, summary: 'some-summary', fields: {'customfield_9001' => 'some-text'})
        expect(@summaries).to receive(:parse_string).with('some-summary')
        expect(@texts).to receive(:parse_string).with('some-text')

        subject.learn(issue)
      end

      it 'raises issue counter' do
        issue = double(JIRA::Resource::Issue, summary: 'some-summary', fields: {'customfield_9001' => 'some-text'})
        expect(subject.size).to eq(0)
        subject.learn(issue)
        expect(subject.size).to eq(1)
      end
    end

    context '.generate' do
      it 'generates an issue' do
        expect(@summaries).to receive(:generate_n_sentences).with(1) { 'some-summary' }
        expect(@texts).to receive(:generate_n_sentences).with(23) { 'some-text' }
        expect(subject.generate(23)).to eq({summary: 'some-summary', text: 'some-text'})
      end
    end

    context '.save!' do
      it 'saves the state' do
        expect(@summaries).to receive(:save_dictionary!)
        expect(@texts).to receive(:save_dictionary!)
        expect(File).to receive(:write).with('some-project-state.yaml', /size: 0/)

        subject.save!
      end
    end

    context '.wipe!' do
      it 'wipes the state from disk' do
        expect(MarkyMarkov::Dictionary).to receive(:delete_dictionary!).with('some-project-summaries')
        expect(MarkyMarkov::Dictionary).to receive(:delete_dictionary!).with('some-project-texts')
        expect(FileUtils).to receive(:rm_f).with('some-project-state.yaml')

        subject.wipe!
      end
    end
  end
end
