require 'swagger_helper'

RSpec.describe 'Clubs::Events' do
  path '/api/clubs/{club_id}/members' do
    post 'Create new, not approved member' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/members'
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            club_token: {
              type: :string,
              example: '9f+jUFs0ooRIx/tD'
            }
          }
        }
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

      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let!(:club_id) { club.id }
      let!(:body) { { club_token: club_token } }
      let!(:club) { create(:club) }
      let!(:club_token) { club.token }

      let(:action) { post "/api/clubs/#{club_id}/members", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user provides proper club token' do
        it 'creates member' do
          expect { action }.to change { Member.all.size }.by(1)
        end

        it 'creates not approved member' do
          action
          expect(Member.find_by(user_id: user.id, club_id: club_id).approved).to be_falsey
        end
      end

      context 'when user does not provide proper club token' do
        let(:club_token) { 'nafsisauf349fu' }

        it 'does not create member' do
          expect { action }.not_to change { Member.all.size }
        end
      end

      response 201, 'creates new group'  do
        run_test!
      end

      response 401, 'club token invalid'  do
        let(:club_token) { 'f4q4rfij93' }

        run_test!
      end
    end

    get 'show members' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/members'
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
  
      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let!(:club_id) { club.id }
      let!(:body) { {} }
      let!(:club) { create(:club) }
      let!(:member) { create(:member, user: user, club: club) }

      before { create(:member, user: user, club: create(:club)) }
  
      let(:action) { get "/api/clubs/#{club_id}/members", headers: { Authorization: user.generate_jwt } }

      it 'returns only club members' do
        action
        expect(JSON.parse(response.body).size).to eq(club.members.size) 
        expect(JSON.parse(response.body).map { |x| x['id'] }).to contain_exactly(*club.members.pluck(:id))
      end

      response 200, 'returns member'  do
        run_test!
      end
    end
  end

  path '/api/clubs/{club_id}/members/{id}' do
    put 'Update member' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/members'
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            member: {}
          }
        }
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
  
      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let!(:club_id) { club.id }
      let!(:body) { {} }
      let!(:club) { create(:club, owner_id: user.id) }
      let!(:id) { user.members.first.id }
  
      let(:action) { post "/api/clubs/#{club_id}/members/#{id}", params: body, headers: { Authorization: user.generate_jwt } }
  
      response 201, 'creates new group'  do
        run_test!
      end
    end

    get 'show member' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/members'
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
  
      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let!(:club_id) { club.id }
      let!(:body) { {} }
      let!(:club) { create(:club) }
      let!(:id) { member.id }
      let!(:member) { create(:member, user: user, club: club) }
  
      let(:action) { get "/api/clubs/#{club_id}/members/#{id}", headers: { Authorization: user.generate_jwt } }

      context 'with club member' do
        it 'returns only club member' do
          action
          expect(JSON.parse(response.body)['id']).to eq(id) 
        end
      end

      context 'with not club member' do
        let!(:id) { create(:member, user: user, club: create(:club)).id }

        it 'does not return member' do
          action
          expect(JSON.parse(response.body)).to be_blank 
        end
      end

      response 200, 'returns member'  do
        run_test!
      end
    end
  end

  path '/api/clubs/{club_id}/members/{member_id}/approve' do
    post 'Approve member and set roles' do
      consumes 'application/json'
      produces 'application/json'
      tags 'clubs/members'
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            member: {
              type: :object,
              required: true,
              properties: {
                roles: { type: :array, items: { type: :string }, example: %w(PLAYER COACH) }
              }
            }
          }
        }
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
        name: :member_id, 
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


      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let!(:club_id) { club.id }
      let!(:member_id) { not_approved_member.id }
      let!(:not_approved_member) { create(:member, club: club, approved: false, roles: []) }
      let!(:club) { create(:club) }
      let!(:body) { { member: { roles: %w(PLAYER COACH) } } } 

      let(:action) { post "/api/clubs/#{club_id}/members/#{member_id}/approve", params: body, headers: { Authorization: user.generate_jwt } }

      context 'when user has coach role' do
        before { create(:member, user: user, club: club, roles: %w(COACH)) }

        it 'approves member' do
          action
          expect(Member.find(member_id).approved).to be_truthy
        end

        it 'gives roles' do
          action
          expect(Member.find(member_id).roles).to eq(%w(PLAYER COACH))
        end
      end


      context 'when user has president role' do
        before { create(:member, user: user, club: club, roles: %w(PRESIDENT)) }

        it 'approves member' do
          action
          expect(Member.find(member_id).approved).to be_truthy
        end

        it 'gives roles' do
          action
          expect(Member.find(member_id).roles).to eq(%w(PLAYER COACH))
        end
      end

      context 'when user has player role' do
        before { create(:member, user: user, club: club, roles: %w(PLAYER)) }

        it 'does not approve member' do
          action
          expect(Member.find(member_id).approved).to be_falsey
        end

        it 'does not give roles' do
          action
          expect(Member.find(member_id).roles).to be_empty
        end
      end

      response 201, 'creates new group'  do
        before { create(:member, user: user, club: club, roles: %w(COACH)) }

        run_test!
      end
    end
  end
end