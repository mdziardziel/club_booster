require 'swagger_helper'

RSpec.describe 'Users' do
  path '/api/users' do
    get 'Get users' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter name: 'Authorization', in: :header, type: :string

      let!(:users) do
        create_list(:user, 3)
      end


      response 200, description: 'Return all the available users'  do
        let(:Authorization) { users.first.generate_jwt }

        run_test!
      end

      response 401, description: 'Return all the available users'  do
        let(:Authorization) { 'wrong-jwt' }

        run_test!
      end
    end
  end

  path '/api/users/{id}' do
    get 'Get user' do
      consumes 'application/json'
      produces 'application/json'
      tags :users
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :id, in: :path, type: :integer

      let!(:user) do
        create(:user)
      end


      response 200, description: 'Return all the available users'  do
        let(:Authorization) { user.generate_jwt }
        let(:id) { user.id }

        run_test!
      end

      response 401, description: 'Return all the available users'  do
        let(:Authorization) { 'wrong-jwt' }
        let(:id) { user.id }

        run_test!
      end
    end
  end
end