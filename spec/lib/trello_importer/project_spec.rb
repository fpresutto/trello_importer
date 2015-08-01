require 'spec_helper'

module TrelloImporter
  describe Project do

    it { is_expected.to respond_to :import_from_csv }
    it { is_expected.to respond_to :name }

    it 'can be initialized with all its attributes' do
      subject = TrelloImporter::Project.new(:some_project_name)
      expect(subject.name).to eq :some_project_name
    end

    describe '#import_from_csv' do

      let(:subject) { TrelloImporter::Project.new(:some_project_name) }

      it 'accepts a file name' do
        expect{ subject.import_from_csv('spec/fixtures/kanbanery_sample.csv') }.not_to raise_error
      end

      context 'when no board name was provided' do

        xit 'uses the project name as board name' do
          expect(subject.import_from_csv('some/file.csv')).to include 'some_project_name'
        end
      end

      context 'when the CSV file describes Kanbanery tickets' do

        it 'creates as many cards as there are tickets' do
          cards = subject.import_from_csv('spec/fixtures/kanbanery_sample.csv')
          expect(cards).to be_kind_of Array
          expect(cards.count).to eq 3

          cards.each do |card|
            expect(card).to be_kind_of Card
          end
        end
      end
    end
  end
end
