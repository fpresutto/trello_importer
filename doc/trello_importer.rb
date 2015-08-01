require 'trello'
require 'csv'
require 'pry'

def get_list_id_for(trello_lists, column_name)
  trello_lists[column_name].id
end


Trello.configure do |config|
  config.developer_public_key = 'DEVELOPER_KEY'
  config.member_token = 'MEMBER_TOKEN'
end

user = Trello::Member.find('USERNAME')
board = Trello::Board.create({:name=>"PROJECT_NAME", :description=>"", :closed=>false,
  :starred=>true, :url=>"ANY_CURRENT_USER_PROJECT_URL", :organization_id=>nil,
  :prefs=>{"permissionLevel"=>"private", "voting"=>"disabled", "comments"=>"members",
    "invitations"=>"members", "selfJoin"=>false, "cardCovers"=>true, "cardAging"=>"regular",
    "calendarFeedEnabled"=>false, "background"=>"blue", "backgroundColor"=>"#0079BF",
    "backgroundImage"=>nil, "backgroundImageScaled"=>nil, "backgroundTile"=>false,
    "backgroundBrightness"=>"unknown", "canBePublic"=>true, "canBeOrg"=>true, "canBePrivate"=>true,
    "canInvite"=>true}})


csv_text = File.read('CSV_FILENAME')
csv = CSV.parse(csv_text, :headers => true)
#raise csv.to_a.map {|row|  }.inspect
kanbanery_tickets = csv.each.inject([]) do |result, csv_row|
  kanbanery_ticket = csv_row.to_a.to_h # this is a Hash, eg. {"Title" => "Make coffee"}
  result << kanbanery_ticket
end



column_names = kanbanery_tickets.map { |ticket| ticket['Column name'] }
#binding.pry
result_list = []
trello_lists = column_names.uniq.each.inject([]) do |result, column_name|
  result_list << Trello::List.create(name: column_name, board_id: board.id)
end

kanbanery_tickets.first

user = Trello::Member.find('USERNAME')

#binding.pry if kanbanery_ticket["Column name"].nil?
def get_id_from_column_name(result_list, column_name)
  result_list.each do |result|
    if result.name == column_name
      return result.id
    end
  end
end


trello_cards = kanbanery_tickets.each.inject([]) do |result, kanbanery_ticket|

  column_name = kanbanery_ticket["Column name"]
  list_id = get_id_from_column_name(result_list, column_name)
  desc = "#{kanbanery_ticket["Description"]} \n Creado por #{kanbanery_ticket["Owner email"]}"
  member_ids = kanbanery_ticket["Owner email"]
  # binding.pry
  card = Trello::Card.create(list_id: list_id, name: kanbanery_ticket["Title"], desc: desc, member_ids: user.id , card_labels: 'labels', due: 'due', pos: '')
  result << card
end


