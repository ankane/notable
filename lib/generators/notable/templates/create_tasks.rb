class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :notable_tasks do |t|
      t.string :note_type
      t.text :note
      t.text :task
      t.decimal :runtime
      t.timestamp :created_at
    end
  end
end
