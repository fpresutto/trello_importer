class TrelloImporter::Card

  attr_reader :description, :list_name, :name, :owners, :requester

  def initialize(data)
    @name        = data[:name]
    @description = data[:description]
    @list_name   = data[:list_name]
    @requester   = data[:requester]
    @owners      = data[:owners]
    @labels      = data[:labels]
    @due_date    = data[:due_date]
    @position    = data[:position]
  end

  def labels
    @labels.sort
  end

  def due_date
    Date.parse(@due_date).to_s
  end

  def position
    @position.empty? ? 'bottom' : @position
  end

end
