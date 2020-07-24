ActiveRecord::Schema.define do
  create_table :notable_jobs do |t|
    t.string :note_type
    t.text :note
    t.text :job
    t.string :job_id
    t.string :queue
    t.float :runtime
    t.float :queued_time
    t.timestamp :created_at
  end

  create_table :notable_requests do |t|
    t.string :note_type
    t.text :note
    t.references :user, polymorphic: true
    t.text :action
    t.integer :status
    t.text :url
    t.string :request_id
    t.string :ip
    t.text :user_agent
    t.text :referrer
    t.text :params
    t.float :request_time
    t.timestamp :created_at
  end

  create_table :users do |t|
    t.string :email
  end
end
