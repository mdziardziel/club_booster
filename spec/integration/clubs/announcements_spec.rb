require 'swagger_helper'

RSpec.describe 'Clubs::announcements' do
  path '/api/clubs/{club_id}/announcements' do
    post 'Create new announcement' do
      consumes 'application/json'
      produces 'application/json'
      description "Creates new announcement for club"
      tags 'clubs/announcements'
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            announcement: {
              type: :object,
              required: true,
              properties: {
                content: { type: :string, example: 'Warta Poznań U19 - Lech Poznań U19' },
                members_ids: { type: :array, items: { type: :string }, example: [1, 2, 3] },
                groups_ids: { type: :array, items: { type: :string }, example: [11, 12] }
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
          announcement: { 
            content: name, 
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

      let(:action) { post "/api/clubs/#{club_id}/announcements", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'creates announcement' do
          expect { action }.to change { Announcement.all.size }.by(1)
        end
      end

      context 'when not only club members in params' do
        let(:expected_members_ids) do
          [
            user.members.first.id,
            club_member.id
          ]
        end
        let(:groups_ids) { [group1.id, group2.id] }
        let(:group1) { create(:group, club_id: club_id, members_ids: [user.members.first.id]) }
        let(:group2) { create(:group, members_ids: [create(:member).id]) }
        let(:club_member) { create(:member, club_id: club_id) }
        let(:members_ids) { [club_member.id, create(:member).id] }

        it 'assigns users only club members' do
          action
          expect(Announcement.last.members_ids).to eq(expected_members_ids)
        end
      end

      context 'when user has president role in other club' do
        let(:club_id) { create(:club).id }

        it 'does not create Announcement' do
          expect { action }.not_to change { Announcement.all.size }
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'creates Announcement' do
          expect { action }.to change { Announcement.all.size }.by(1)
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach]) }

        it 'does not create Announcement' do
          expect { action }.not_to change { Announcement.all.size }
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not create Announcement' do
          expect { action }.not_to change { Announcement.all.size }
        end
      end

      response 201, 'creates new Announcement'  do
        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end

    get 'get announcements' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/announcements'

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

      let!(:Authorization) { user.generate_jwt }
      let!(:club_id) { club.id }
      let!(:club) { create(:club, owner_id: user.id) }
      let!(:user) { create(:user) }

      let(:action) { get "/api/clubs/#{club_id}/announcements", headers: { Authorization: user.generate_jwt } }

      before do
        create_list(:announcement, 3, members_ids: [user.members.first.id], club: club)
        create_list(:announcement, 3, club: club, members_ids: [])
      end

      it 'returns member announcements' do
        action
        expect(JSON.parse(response.body).size).to eq(3)
      end

      response 200, 'creates new announcement'  do
        run_test!
      end
    end
  end

  path '/api/clubs/{club_id}/announcements/{id}' do
    get 'get announcement' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/announcements'

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
      parameter(
        in: :path, 
        name: :id, 
        required: true,
        type: :string,
        example: '1'
      )

      let!(:Authorization) { user.generate_jwt }
      let!(:club_id) { club.id }
      let!(:club) { create(:club, owner_id: user.id) }
      let!(:user) { create(:user) }
      let!(:id) { member_announcement.id }

      let(:action) { get "/api/clubs/#{club_id}/announcements/#{id}", headers: { Authorization: user.generate_jwt } }

      let!(:member_announcement) { create(:announcement, members_ids: [user.members.first.id], club: club) }
      let!(:not_member_announcement) { create(:announcement, club: club, members_ids: []) }

      it 'returns member announcement' do
        action
        expect(JSON.parse(response.body)['id']).to eq(member_announcement.id)
      end

      context 'when not member announcement' do
        let!(:id) { not_member_announcement.id }

        it 'does not return member announcement' do
          action
          expect(JSON.parse(response.body)).to be_blank
        end
      end

      response 200, 'creates new announcement'  do
        run_test!
      end
    end
  end
end