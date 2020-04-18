require 'swagger_helper'

RSpec.describe 'Clubs::announcements' do
  path '/api/announcements' do
    get 'get announcements for users' do
      consumes 'application/json'
      produces 'application/json'
      tags :announcements

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

      let!(:Authorization) { user.generate_jwt }
      let!(:user) { create(:user) }

      let(:action) { get "/api/announcements", headers: { Authorization: user.generate_jwt } }

      before do
        clb = create(:club, owner_id: user.id)
        create_list(:announcement, 3, club: clb, members_ids: [clb.members.first.id])
        create_list(:announcement, 3, club: create(:club, owner_id: user.id), members_ids: [])
      end

      it 'returns member announcements' do
        action
        expect(JSON.parse(response.body).size).to eq(3)
      end

      response 200, 'gets announcements'  do
        run_test!
      end
    end
  end

  path '/api/announcements/{id}' do
    get 'get announcement for user' do
      consumes 'application/json'
      produces 'application/json'
      tags :announcements

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
      parameter(
        in: :query, 
        name: :locale, 
        required: false,
        type: :string,
        example: 'pl'
      )
      let(:locale) { 'pl' }
      

      let!(:Authorization) { user.generate_jwt }
      let!(:club) { create(:club, owner_id: user.id) }
      let!(:user) { create(:user) }
      let!(:id) { user_announcement.id }

      let(:action) { get "/api/announcements/#{id}", headers: { Authorization: user.generate_jwt } }

      let!(:user_announcement) { create(:announcement, club: club, members_ids: [user.members.first.id], club: club) }
      let!(:not_user_announcement) { create(:announcement, club: club, members_ids: []) }

      it 'returns member announcement' do
        action
        expect(JSON.parse(response.body)['id']).to eq(user_announcement.id)
      end

      context 'when not member announcement' do
        let!(:id) { not_user_announcement.id }

        it 'does not return member announcement' do
          action
          expect(JSON.parse(response.body)).to be_blank
        end
      end

      response 200, 'gets announcement'  do
        run_test!
      end
    end
  end
end