require 'spec_helper'

require_relative '../../../../apps/admin/controllers/users/list'

describe Admin::Controllers::Users::List do
  let(:action) { Admin::Controllers::Users::List.new }
  let(:params) { Hash[] }

  before do
    UserRepository.clear
    @user = User.new(first_name: 'John', last_name: 'Doe', screen_name: 'doey', password: 'foo12345', password_confirmation: 'foo12345')
    UserRepository.create @user
    puts @user.full_name
  end

  it "is successful" do

    response = action.call(params)
    response[0].must_equal 200
  end
end
