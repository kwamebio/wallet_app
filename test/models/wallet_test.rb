# == Schema Information
#
# Table name: wallets
#
#  id              :bigint           not null, primary key
#  user_id         :bigint
#  settled_balance :integer          default(0)
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class WalletTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
