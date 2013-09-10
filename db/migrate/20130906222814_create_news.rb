class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :headline
      t.string :url
      t.string :source
      t.timestamps
    end
  end
end
