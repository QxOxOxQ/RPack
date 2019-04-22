class AddNameToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :name, :string
  end
end
