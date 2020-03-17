require 'swagger_helper'

RSpec.describe 'Authentication' do
  path '/api/authentication' do
    post 'Authenticate' do
      consumes 'application/json'
      produces 'application/json'
      tags :authentication
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

      let(:user) { create(:user, password: password) }
      let(:body) { { user: { email: user.email, password: password_body } } }
      let(:password) { 'qwerty' }

      response 201, 'Returns jwt for authenticated user'  do
        let(:password_body) { password }
        run_test!
      end

      response 401, 'invalid credentials'  do
        let(:password_body) { 'wrong password' }

        run_test!
      end
    end
  end
end