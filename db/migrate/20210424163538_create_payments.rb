class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.string :card_number
      t.string :name_on_card
      t.string :expiry_date
      t.string :email_address
      t.string :billing_address
      t.text :description, null: true
      
      t.timestamps
    end
  end
end
