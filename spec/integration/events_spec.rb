require 'swagger_helper'

RSpec.describe 'Events' do
  path '/api/clubs/{club_id}/events' do
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

      let(:body) do
        { 
          event: { 
            name: name, 
            start_date: 2.days.from_now.to_i, 
            groups_ids: groups_ids,
            members_ids: members_ids
          } 
        }
      end
      let(:groups_ids) { [] }
      let(:members_ids) { [] }
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

      context 'when not only club members in params' do
        let(:expected_participants) do
          {
            user.members.first.id.to_s => nil,
            club_member.id.to_s => nil
          }
        end
        let(:groups_ids) { [group1.id, group2.id] }
        let(:group1) { create(:group, club_id: club_id, members_ids: [user.members.first.id]) }
        let(:group2) { create(:group, members_ids: [create(:member).id]) }
        let(:club_member) { create(:member, club_id: club_id) }
        let(:members_ids) { [club_member.id, create(:member).id] }

        it 'assigns users only club members' do
          action
          expect(Event.last.participants).to eq(expected_participants)
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
end