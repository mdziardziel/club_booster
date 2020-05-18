require 'swagger_helper'

RSpec.describe 'Clubs::Events' do
  path '/api/clubs/{club_id}/groups' do
    get 'get groups' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/groups'
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
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { group: { name: name, members_ids: members_ids } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:members_ids) { club.members.pluck(:id) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }
      let(:group) { create(:group, club: club, name: 'abba', members_ids: []) }
      let(:id) { group.id }

      let(:action) { get "/api/clubs/#{club_id}/groups", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'resturns group' do
          action
          expect(JSON.parse(response.body).map{ |x| x['id'] }).to eq(club.groups.pluck(:id))
        end
      end

      context 'when user has president role in other club' do
        let(:club) { create(:club) }

        before { create(:member, user: user, club: club, roles: [Role.player]) }

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'resturns group' do
          action
          expect(JSON.parse(response.body).map{ |x| x['id'] }).to eq(club.groups.pluck(:id))   
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before do
          create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach])
          create(:member, user: user, club: club, roles: [Role.player])
        end

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)       
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)       
        end
      end

      response 200, 'updates new group'  do
        run_test!
      end
    end


    post 'Create new group' do
      consumes 'application/json'
      produces 'application/json'
      description "Creates new group for club"
      tags 'clubs/groups'
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            group: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'Defenders' },
                members_ids: { type: :array, items: { type: :string }, example: [1, 2, 3] }
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
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { group: { name: name, members_ids: members_ids } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:members_ids) { club.members.pluck(:id) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }

      let(:action) { post "/api/clubs/#{club_id}/groups", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'creates group' do
          expect { action }.to change { Group.all.size }.by(1)
        end
      end

      context 'when user has president role in other club' do
        let(:club_id) { create(:club).id }

        it 'does not create group' do
          expect { action }.not_to change { Group.all.size }
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'creates group' do
          expect { action }.to change { Group.all.size }.by(1)
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach]) }

        it 'does not create group' do
          expect { action }.not_to change { Group.all.size }
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not create group' do
          expect { action }.not_to change { Group.all.size }
        end
      end

      response 201, 'creates new group'  do
        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end
  end

  path '/api/clubs/{club_id}/groups/{id}' do
    get 'get group' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/groups'
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
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { group: { name: name, members_ids: members_ids } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:members_ids) { club.members.pluck(:id) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }
      let(:group) { create(:group, club: club, name: 'abba', members_ids: []) }
      let(:id) { group.id }

      let(:action) { get "/api/clubs/#{club_id}/groups/#{id}", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'resturns group' do
          action
          expect(JSON.parse(response.body)['id']).to eq(id)
        end
      end

      context 'when user has president role in other club' do
        let(:club) { create(:club) }

        before { create(:member, user: user, club: club, roles: [Role.player]) }

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'resturns group' do
          action
          expect(JSON.parse(response.body)['id']).to eq(id)   
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before do
          create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach])
          create(:member, user: user, club: club, roles: [Role.player])
        end

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)       
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not return group' do
          action
          expect(response).to have_http_status(401)       
        end
      end

      response 200, 'updates new group'  do
        run_test!
      end
    end

    put 'Update group' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/groups'
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            group: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'Defenders' },
                members_ids: { type: :array, items: { type: :string }, example: [1, 2, 3] }
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
      parameter(
        in: :path, 
        name: :id, 
        required: true,
        type: :string,
        example: '1'
      )
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { group: { name: name, members_ids: members_ids } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:members_ids) { club.members.pluck(:id) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }
      let(:group) { create(:group, club: club, name: 'abba', members_ids: []) }
      let(:id) { group.id }

      let(:action) { put "/api/clubs/#{club_id}/groups/#{id}", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'updates group' do
          action
          expect(group.reload.name).to eq(name)
          expect(group.reload.members_ids).to eq(members_ids)
        end
      end

      context 'when user has president role in other club' do
        let(:club_id) { create(:club).id }

        it 'does not update group' do
          action
          expect(group.reload.name).to eq('abba')
          expect(group.reload.members_ids).to be_empty        
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'updates group' do
          action
          expect(group.reload.name).to eq(name)
          expect(group.reload.members_ids).to eq(members_ids)        
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach]) }

        it 'does not update group' do
          action
          expect(group.reload.name).to eq('abba')
          expect(group.reload.members_ids).to be_empty           
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not update group' do
          action
          expect(group.reload.name).to eq('abba')
          expect(group.reload.members_ids).to be_empty           
        end
      end

      response 201, 'updates new group'  do
        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end

    delete 'Removes group' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/groups'

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
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { group: { name: name, members_ids: members_ids } } }
      let(:Authorization) { user.generate_jwt }
      let(:club_id) { club.id }
      let(:club) { create(:club, owner_id: user.id) }
      let(:user) { create(:user) }
      let(:members_ids) { club.members.pluck(:id) }
      let(:name) { 'Warta Poznań U19 - Lech Poznań U19' }
      let!(:group) { create(:group, club: club, name: 'abba', members_ids: []) }
      let(:id) { group.id }

      let(:action) { delete "/api/clubs/#{club_id}/groups/#{id}", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has president role in this club' do
        it 'updates group' do
          expect { action }.to change { Group.all.size }.by(-1)
        end
      end

      context 'when user has president role in other club' do
        let(:club_id) { create(:club).id }

        it 'does not update group' do
          expect { action }.not_to change { Group.all.size }
        end
      end

      context 'when user has coach role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.coach]) }

        it 'updates group' do
          expect { action }.to change { Group.all.size }.by(-1) 
        end
      end

      context 'when user has coach role in other club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: create(:club).id, user_id: user.id, roles: [Role.coach]) }

        it 'does not update group' do
          expect { action }.not_to change { Group.all.size }
        
        end
      end

      context 'when user has player role in this club' do
        let(:club) { create(:club) }

        before { create(:member, club_id: club_id, user_id: user.id, roles: [Role.player]) }

        it 'does not update group' do
          expect { action }.not_to change { Group.all.size }
      
        end
      end

      response 200, 'updates new group'  do
        run_test!
      end
    end
  end
end