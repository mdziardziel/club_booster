require 'swagger_helper'

RSpec.describe 'Users' do
  path '/api/clubs' do

    post 'Create new club' do
      consumes 'application/json'
      produces 'application/json'
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
end