class AddAcceptedTermsAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :accepted_terms_at, :datetime
  end
end
