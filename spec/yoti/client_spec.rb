require 'spec_helper'

describe 'Yoti::Client' do
  describe '.get_activity_details' do
    let(:encrypted_yoti_token) { File.read('spec/fixtures/encrypted_yoti_token.txt', encoding: 'utf-8') }
    let(:activity_details) { Yoti::Client.get_activity_details(encrypted_yoti_token) }
    let(:profile) { activity_details.user_profile }
    let(:outcome) { activity_details.outcome }
    let(:user_id) { activity_details.user_id }

    context 'when the encrypted token is nil' do
      it 'raises an ArgumentError ' do
        error = 'wrong number of arguments (given 0, expected 1)'
        expect { Yoti::Client.get_activity_details }.to raise_error(ArgumentError, error)
      end
    end

    context 'when the encrypted token is valid' do
      it 'returns an ActivityDetails object' do
        expect(activity_details).to be_a(Yoti::ActivityDetails)
      end

      it 'contains the fetched profile' do
        expect(profile).not_to be_nil
      end

      it 'contains the decrypted user ID value' do
        expected_id = 'Hig2yAT79cWvseSuXcIuCLa5lNkAPy70rxetUaeHlTJGmiwc/g1MWdYWYrexWvPU'
        expect(user_id).to eql(expected_id)
      end

      it 'contains the decrypted phone number value' do
        phone_number = '+447474747474'
        expect(profile['phone_number']).to eql(phone_number)
      end

      it 'contains the decrypted selfie value' do
        selfie = File.read('spec/fixtures/selfie.txt', encoding: 'utf-8')
        expect(profile['selfie']).to eql(selfie)
      end

      it 'contains the outcome with a successful value' do
        expect(outcome).to eql 'SUCCESS'
      end
    end
  end
end
