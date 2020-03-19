require 'swagger_helper'

RSpec.describe 'Events' do
  path '/api/clubs/{club_id}/events' do
    # get 'Get clubs' do
    #   consumes 'application/json'
    #   produces 'application/json'
    #   tags :clubs
    #   description "Returns all user's clubs"
    #   parameter(
    #     in: :header, 
    #     name: :Authorization, 
    #     required: true,
    #     type: :string,
    #     example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
    #   )

    #   let!(:users) { create_list(:user, 4) }
    #   let!(:club1) { create(:club, owner_id: users.first.id).reload }
    #   let!(:club2) { create(:club, owner_id: users.second.id).reload }
    #   let!(:Authorization) { users.first.generate_jwt }

    #   before do
    #     create(:user_club, club: club2, user: users.first)
    #     create(:club, owner_id: users.third.id) 
    #   end

    #   it "returns user's clubs" do
    #     get '/api/clubs', headers: { 'Authorization' => users.first.generate_jwt }
    #     expect(JSON.parse(response.body))
    #       .to contain_exactly(club1.attributes, club2.attributes)
    #     expect(Club.all.size).to eq(3)
    #   end


    #   response 200, "returns user's clubs"  do
    #     run_test!
    #   end
      

    #   response 401, 'unauthorized'  do
    #     let(:Authorization) { 'wrong-jwt' }

    #     run_test!
    #   end
    # end

    post 'Create new event' do
      consumes 'application/json'
      produces 'application/json'
      description "Creates new event for club"
      tags :events
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            event: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'Warta Poznań U19 - Lech Poznań U19' },
                start_date: { type: :integer, example: 0 }
              }
            }
          }
        }
      )
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )
      parameter(
        in: :path, 
        name: :club_id, 
        required: true,
        type: :string,
        example: '1'
      )

      let(:body) { { event: { name: name, start_date: 2.days.from_now.to_i } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }

      let(:action) { post "/api/clubs/#{club_id}/events", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'creates event' do
          expect { action }.to change { Event.all.size }.by(1)
        end
      end

      context 'when user has president role in other club' do
        let(:club_id) { create(:club).id }

        it 'does not create event' do
          expect { action }.not_to change { Event.all.size }
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'creates event' do
          expect { action }.to change { Event.all.size }.by(1)
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach]) }

        it 'does not create event' do
          expect { action }.not_to change { Event.all.size }
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not create event' do
          expect { action }.not_to change { Event.all.size }
        end
      end

      response 201, 'creates new event'  do
        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end
  end

  # path '/api/clubs/{id}' do
  #   get 'Get clubs' do
  #     consumes 'application/json'
  #     produces 'application/json'
  #     tags :clubs
  #     description "Returns club only if it is user's club"
  #     parameter(
  #       in: :header, 
  #       name: :Authorization, 
  #       required: true,
  #       type: :string,
  #       example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
  #     )

  #     parameter(
  #       in: :path, 
  #       name: :id, 
  #       required: true,
  #       type: :string,
  #       example: '1'
  #     )

  #     let!(:users) { create_list(:user, 4) }
  #     let!(:club1) { create(:club, owner_id: users.first.id).reload }
  #     let!(:club2) { create(:club, owner_id: users.second.id).reload }
  #     let!(:club3) { create(:club, owner_id: users.third.id) }
  #     let!(:Authorization) { users.first.generate_jwt }

  #     let(:id) { '1' }

  #     before { create(:user_club, club: club2, user: users.first) }

  #     it "returns only user's club" do
  #       get "/api/clubs/#{club2.id}",  headers: { 'Authorization' => users.first.generate_jwt }
  #       expect(JSON.parse(response.body)).to eq(club2.attributes)
  #     end

  #     it "doesn't return not user's club" do
  #       get "/api/clubs/#{club3.id}", headers: { 'Authorization' => users.first.generate_jwt }
  #       expect(JSON.parse(response.body)).to be_empty
  #     end

  #     response 200, "returns club"  do
  #       run_test!
  #     end
      

  #     response 401, 'unauthorized'  do
  #       let(:Authorization) { 'wrong-jwt' }

  #       run_test!
  #     end
  #   end
  # end
end