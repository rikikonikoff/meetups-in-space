class MeetupsEditCreatorColumn < ActiveRecord::Migration
  def change
    change_table :meetups do |table|
      table.remove :user_id
      table.belongs_to :creator, class_name: :User, index: true
    end
  end
end
