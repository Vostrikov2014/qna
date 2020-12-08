class AddVkontakteNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :vkontakte_name, :string
  end
end
