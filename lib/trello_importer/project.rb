require 'csv'
require 'trello'

module TrelloImporter
  class Project

    # Return the project name
    attr_reader :cards, :name, :result_list, :trello_board, :user

    def initialize(project_name='Imported Project')
      @name = project_name
    end

    # Create cards from a CSV file, returns a collection of Cards
    def import_from_csv(file_name)
      kanbanery_tickets = extract_kanbanery_tickets_from_csv(file_name)
      @cards = extract_cards(kanbanery_tickets)
    end

    def export_to_trello
      configure_trello
      @user = Trello::Member.find('USERNAME')
      create_trello_board!(@name)
      create_trello_lists!
      create_trello_cards
    end

    private

      # Sandi is happy!
      def extract_kanbanery_tickets_from_csv(csv_file_name)
        csv_text = File.read(csv_file_name)
        csv = CSV.parse(csv_text, :headers => true)
        csv.each.inject([]) do |result, csv_row|
          kanbanery_ticket = csv_row.to_a.to_h # this is a Hash, eg. {"Title" => "Make coffee"}
          result << kanbanery_ticket
        end
      end

      def extract_card_attributes(kanbanery_ticket)

        name = kanbanery_ticket["Title"]
        description = kanbanery_ticket["Description"]
        list_name = kanbanery_ticket["Column name"]
        requester = kanbanery_ticket["Creator email"]
        owners = kanbanery_ticket["Owner email"]
        labels = kanbanery_ticket[""]
        due_date = nil
        position = nil

        # TODO extend TrelloImporter::Card to contain all the Kanbanery tickets attributes
        # estimate = kanbanery_ticket["Estimate"]
        # priority = kanbanery_ticket["Priority"]

        card_attributes = {
          name: name,
          description: description,
          list_name: list_name,
          requester: requester,
          owners: owners,
          labels: labels,
          due_date: due_date,
          position: position
        }
      end

      def extract_cards(kanbanery_tickets)
        kanbanery_tickets.each.inject([]) do |cards, kanbanery_ticket|
          card_attributes = extract_card_attributes(kanbanery_ticket)
          card = Card.new(card_attributes)
          cards << card
        end
      end

      def configure_trello
        Trello.configure do |config|
          config.developer_public_key = TrelloImporter::DEVELOPER_PUBLIC_KEY
          config.member_token = TrelloImporter::MEMBER_TOKEN
        end
      end

      def create_trello_board!(board_name)

        board_attributes = {
          name: board_name,
          description: "",
          closed: false,
          starred: true,
          organization_id: nil,
          prefs: {
            "permissionLevel"=>"private",
            "voting"=>"disabled",
            "comments"=>"members",
            "invitations"=>"members",
            "selfJoin"=>false,
            "cardCovers"=>true,
            "cardAging"=>"regular",
            "calendarFeedEnabled"=>false,
            "background"=>"blue",
            "backgroundColor"=>"#0079BF",
            "backgroundImage"=>nil,
            "backgroundImageScaled"=>nil,
            "backgroundTile"=>false,
            "backgroundBrightness"=>"unknown",
            "canBePublic"=>true,
            "canBeOrg"=>true,
            "canBePrivate"=>true,
            "canInvite"=>true
          }
        }

        @trello_board = Trello::Board.create(board_attributes)
      end

      def create_trello_lists!
        @result_list = []
        close_default_trello_lists!
        lists_names = @cards.map{ |card| card.list_name }
        lists_names.uniq.each.inject([]) do |lists, list_name|
          @result_list << Trello::List.create(name: list_name, board_id: @trello_board.id)
        end
      end

      def get_id_from_list_name(list_name)
        result_list.each do |result|
          if result.name == list_name
           return result.id
          end
        end
      end

      def create_trello_cards
        @cards.each do |card|
          list_id = get_id_from_list_name(card.list_name)
          p list_id

          Trello::Card.create(list_id: list_id, name: card.name, desc: card.description, member_ids: user.id , card_labels: 'labels', due: 'due', pos: '')
        end
      end

      # Caution: closes the first three lists in the board!
      def close_default_trello_lists!
        @trello_board.lists.each do |list|
          list.close!
        end
      end

  end
end
