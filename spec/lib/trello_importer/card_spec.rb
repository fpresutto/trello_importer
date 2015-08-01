require 'spec_helper'

describe TrelloImporter::Card do

  let(:subject) do
    TrelloImporter::Card.new({
      name: 'Users can star products.',
      description: 'In order to keep track of my prefered products, as an user, I want to be able to star/unstar products from the catalogue.',
      list_name: 'Done',
      owners: ['Bob', 'Eve'],
      labels: ['Enhancement', 'UX', 'Products'],
      due_date: '2015-02-25T00:00:00+00:00',
      position: '',
      requester: 'Alice',
      random: 'IgnOre_Me'
    })
  end

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :list_name }
  it { is_expected.to respond_to :requester }
  it { is_expected.to respond_to :owners }
  it { is_expected.to respond_to :labels }
  it { is_expected.to respond_to :due_date }
  it { is_expected.to respond_to :position }

  it 'can be initialized with all its attributes' do
    expect(subject.name).to eq 'Users can star products.'
    expect(subject.description).to eq 'In order to keep track of my prefered products, as an user, I want to be able to star/unstar products from the catalogue.'
    expect(subject.list_name).to eq 'Done'
    expect(subject.requester).to eq 'Alice'
    expect(subject.owners).to eq ['Bob', 'Eve']
    expect(subject.labels).to eq ['Enhancement', 'Products', 'UX']
    expect(subject.due_date).to eq '2015-02-25'
    expect(subject.position).to eq 'bottom'
  end

end
