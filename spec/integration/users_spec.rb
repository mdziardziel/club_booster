require 'swagger_helper'

RSpec.describe 'Users' do
  path '/api/users' do
  #   get 'Get users' do
  #     consumes 'application/json'
  #     produces 'application/json'
  #     tags :users
  #     parameter(
  #       in: :header, 
  #       name: :Authorization, 
  #       required: true,
  #       type: :string,
  #       example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
  #     )
  #     tags :users

  #     let(:Authorization) { users.first.generate_jwt }
  #     let(:users) { create_list(:user, 4) }
  #     let(:club1) { create(:club, owner_id: users.first.id) }
  #     let(:club2) { create(:club, owner_id: users.second.id) }

  #     before do
  #       create(:user_club, club: club2, user: users.first)
  #     end


  #     response 200, 'Return all the available users'  do
  #       let(:Authorization) { users.first.generate_jwt }

  #       run_test!
  #     end
      

  #     response 401, 'Return all the available users'  do
  #       let(:Authorization) { 'wrong-jwt' }

  #       run_test!
  #     end
  #   end

    post 'Sign up' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            user: {
              type: :object,
              required: true,
              properties: {
                email: { type: :string, example: 'test_user@user.pl' }, 
                password: { type: :string, example: 'test_user' } 
              }
            }
          }
        }
      )
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { user: { email: email, password: password } } }

      response 201, 'creates new user'  do
        let(:email) { 'email@example.com' }
        let(:password) { 'qwerty1234' }

        run_test!
      end

      response 422, 'email has been taken or invalid'  do
        let(:password) { 'qwerty1234' }
        let(:email) { create(:user).email }

        run_test!
      end
    end
  end

  path '/api/users/password' do
    post 'send password reset token' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            user: {
              type: :object,
              required: true,
              properties: {
                email: { type: :string, example: 'test_user@user.pl' }
              }
            }
          }
        }
      )
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { user: { email: email} } }

      response 201, 'send reset password email'  do
        let(:email) { create(:user).email }

        run_test!
      end
    end

    patch 'reset password' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter( 
        name: :body, 
        in: :body, 
        required: true,
        schema: { 
          type: :object, 
          required: true,
          properties: { 
            user: {
              type: :object,
              required: true,
              properties: {
                reset_password_token: { type: :string, example: 'Cvo6v4WvA48zP3-wqyqS' },
                password: { type: :string, example: 'ad32uh2r43fwef' },
                password_confirmation: { type: :string, example: 'ad32uh2r43fwef' }
              }
            }
          }
        }
      )
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let(:body) { { user: { reset_password_token: reset_password_token, password: password, password_confirmation: password_confirmation } } }

      let(:token) do
        user.send_reset_password_instructions
      end

      let(:user) { create(:user) }

      response 204, 'send reset password email'  do
        let(:reset_password_token) { token }
        let(:password) { 'ad32uh2r43fwef' }
        let(:password_confirmation) { 'ad32uh2r43fwef' }

        run_test!
      end
    end
  end

  path '/api/users/current' do
    get 'Get current user' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter name: 'Authorization', in: :header, type: :string

      let!(:user) do
        create(:user)
      end

      it 'returns current user'  do
        get '/api/users/current', headers: { Authorization: user.generate_jwt } 
        expect(JSON.parse(response.body)).to eq(user.attributes.slice(*UsersController::SERIALIZE_ATTRIBUTES))
      end

      response 200, 'Return current user'  do
        let(:Authorization) { user.generate_jwt }

        run_test!
      end

      response 401, ''  do
        let(:Authorization) { 'wrong-jwt' }
        let(:id) { user.id }

        run_test!
      end
    end
  end

  path '/api/users' do
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
            user: {
              type: :object,
              required: true,
              properties: {
                name: { type: :string, example: 'John' },
                surname: { type: :string, example: 'Cena' },
                birth_date: { type: :string, example: '2020-05-11T21:16:10.280+02:00' },
                avatar_url: { type: :string, example: 'logo.png' },
                personal_description: { type: :string, example: 'lalala' },
                career_description: { type: :string, example: 'dadada' }
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
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }

      let!(:body) { { user: { name: name } } }
      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user, name: 'John') }
      let(:name) { 'Obi' }
      let(:action) { put "/api/users", params: body, headers: { Authorization: user.generate_jwt } }

      it 'updates name' do
        expect { action }.to change { User.find(user.id).name }.from('John').to('Obi')
      end

      response 201, 'updates club'  do
        run_test!
      end

    end
  end
end