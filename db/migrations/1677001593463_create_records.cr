class CreateRecords < Jennifer::Migration::Base
  def up
    create_table :records do |t|
      t.string :game_id, {:null => false}
      t.jsonb :context, {:null => false}

      t.timestamps
    end

    change_table :records do |t|
      t.add_index :game_id
    end
  end

  def down
    drop_table :records if table_exists? :records
  end
end