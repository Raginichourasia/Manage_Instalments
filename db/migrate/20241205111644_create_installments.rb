class CreateInstallments < ActiveRecord::Migration[7.1]
  def change
    create_table :installments do |t|
      t.string :student_name
      t.integer :total_amount
      t.integer :num_installments
      t.text :installment_structure

      t.timestamps
    end
  end
end
