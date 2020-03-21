require 'swagger_helper'

RSpec.describe 'Users' do
  path '/api/clubs' do
    get 'Get clubs' do
      consumes 'application/json'
      produces 'application/json'
      tags :clubs
      description "Returns all user's clubs"
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )

      let!(:users) { create_list(:user, 4) }
      let!(:club1) { create(:club, owner_id: users.first.id).reload }
      let!(:club2) { create(:club, owner_id: users.second.id).reload }
      let!(:Authorization) { users.first.generate_jwt }

      before do
        create(:member, club: club2, user: users.first)
        create(:club, owner_id: users.third.id) 
      end

      it "returns user's clubs" do
        get '/api/clubs', headers: { 'Authorization' => users.first.generate_jwt }
        expect(JSON.parse(response.body))
          .to contain_exactly(club1.attributes, club2.attributes)
        expect(Club.all.size).to eq(3)
      end


      response 200, "returns user's clubs"  do
        run_test!
      end
      

      response 401, 'unauthorized'  do
        let(:Authorization) { 'wrong-jwt' }

        run_test!
      end
    end

    post 'Create new club' do
      consumes 'application/json'
      produces 'application/json'
      description "Creates new club and grants PRESIDENT role to current user"
      tags :clubs
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            club: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'Warta Poznań U19' }
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

      let(:body) { { club: { name: name } } }
      let(:Authorization) { create(:user).generate_jwt }

      response 201, 'creates new club'  do
        let(:name) { 'Warta Poznań U19' }

        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end
  end

  path '/api/clubs/{id}' do
    put 'update club' do
      consumes 'application/json'
      produces 'application/json'
      description "Updates club"
      tags :clubs
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            club: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'Warta Poznań U19' }
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
        name: :id, 
        required: true,
        type: :string,
        example: '1'
      )

      let!(:body) { { club: { name: name } } }
      let!(:id) { create(:club, name: 'sdsds', owner_id: user.id).id }
      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }
      let(:name) { 'Warta Poznań U19' }
      let(:action) { put "/api/clubs/#{id}", params: body, headers: { Authorization: user.generate_jwt } }

      it 'updates name' do
        expect { action }.to change { Club.find(id).name }.from('sdsds').to(name)
      end

      response 201, 'updates club'  do
        run_test!
      end

      response 422, 'name can not be empty'  do
        let(:name) { '' }

        run_test!
      end
    end

    get 'Get clubs' do
      consumes 'application/json'
      produces 'application/json'
      tags :clubs
      description "Returns club only if it is user's club"
      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )

      parameter(
        in: :path, 
        name: :id, 
        required: true,
        type: :string,
        example: '1'
      )

      let!(:users) { create_list(:user, 4) }
      let!(:club1) { create(:club, owner_id: users.first.id).reload }
      let!(:club2) { create(:club, owner_id: users.second.id).reload }
      let!(:club3) { create(:club, owner_id: users.third.id) }
      let!(:Authorization) { users.first.generate_jwt }

      let(:id) { club1.id }

      before { create(:member, club: club2, user: users.first) }

      it "returns only user's club" do
        get "/api/clubs/#{club2.id}",  headers: { 'Authorization' => users.first.generate_jwt }
        expect(JSON.parse(response.body)).to eq(club2.attributes)
      end

      it "doesn't return not user's club" do
        get "/api/clubs/#{club3.id}", headers: { 'Authorization' => users.first.generate_jwt }
        expect(response).to have_http_status 401
      end

      response 200, "returns club"  do
        run_test!
      end
      

      response 401, 'unauthorized'  do
        let(:Authorization) { 'wrong-jwt' }

        run_test!
      end
    end
  end
end