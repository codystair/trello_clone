class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.string :description, nil: false
      t.references :card, foreign_key: true
      t.timestamps
    end
  end
end
