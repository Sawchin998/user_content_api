# frozen_string_literal: true

# migration to add contents table
class CreateContents < ActiveRecord::Migration[7.1]
  # change
  def change
    create_table :contents do |t|
      t.string :title
      t.string :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
