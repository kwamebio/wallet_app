# == Schema Information
#
# Table name: bank_accounts
#
#  id             :bigint           not null, primary key
#  account_number :string           not null
#  bank_name      :string           not null
#  bank_code      :string           not null
#  account_name   :string           not null
#  recipient_code :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class BankAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
