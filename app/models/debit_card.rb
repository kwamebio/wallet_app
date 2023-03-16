# == Schema Information
#
# Table name: debit_cards
#
#  id                 :bigint           not null, primary key
#  authorization_code :string           not null
#  last4              :string           not null
#  exp_month          :string           not null
#  exp_year           :string           not null
#  card_type          :string           not null
#  bank               :string           not null
#  user_id            :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class DebitCard < ApplicationRecord
  belongs_to :user

  def api_output
    JSON(self.to_json).except('authorization_code')
  end
end
