require 'swagger_helper'

RSpec.describe 'Clubs::Events' do
  path '/api/events' do
    get 'get events for users' do
      consumes 'application/json'
      produces 'application/json'
      tags :user_events

      parameter(
        in: :header, 
        name: :Authorization, 
        required: true,
        type: :string,
        example: 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsInZlciI6MSwiZXhwIjo0NzQwMjMyOTkyfQ.pFrhdrKLPY2iDUOiqBgyioFtEz3qzEYYt8dFx997vOE'
      )

      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }

      let(:action) { get "/api/events", headers: { Authorization: user.generate_jwt } }

      before do
        clb = create(:club, owner_id: user.id)
        create_list(:event, 3, club: clb, participants: { clb.members.first.id => nil })
        create_list(:event, 3, club: create(:club, owner_id: user.id), participants: {})
      end

      it 'returns member events' do
        action
        expect(JSON.parse(response.body).size).to eq(3)
      end

      response 200, 'gets events'  do
        run_test!
      end
    end
  end

  path '/api/events/{id}' do
    get 'get event for user' do
      consumes 'application/json'
      produces 'application/json'
      tags :user_events

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

      let!(:Authorization) { user.generate_jwt }
      let!(:club) { create(:club, owner_id: user.id) }
      let!(:user) { create(:user) }
      let!(:id) { user_event.id }

      let(:action) { get "/api/events/#{id}", headers: { Authorization: user.generate_jwt } }

      let!(:user_event) { create(:event, club: club, participants: { user.members.first.id => nil }, club: club) }
      let!(:not_user_event) { create(:event, club: club, participants: {}) }

      it 'returns member event' do
        action
        expect(JSON.parse(response.body)['id']).to eq(user_event.id)
      end

      context 'when not member event' do
        let!(:id) { not_user_event.id }

        it 'does not return member event' do
          action
          expect(JSON.parse(response.body)).to be_blank
        end
      end

      response 200, 'gets event'  do
        run_test!
      end
    end
  end
end