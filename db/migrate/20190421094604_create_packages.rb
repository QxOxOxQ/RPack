class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :description
      t.string :title
      t.string :authors
      t.string :version
      t.string :maintainers
      t.string :license
      t.datetime :publication_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
