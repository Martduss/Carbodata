class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at
    end

    add_index :users, :confirmation_token, unique: true
    add_index :users, :unlock_token, unique: true

    # Existing users never went through the confirmable sign-up flow; treat
    # them as already confirmed so :confirmable doesn't lock them out.
    reversible do |dir|
      dir.up { User.update_all(confirmed_at: Time.current) }
    end
  end
end
