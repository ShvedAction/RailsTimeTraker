json.extract! track, :id, :start_time, :end_time, :total_time, :tag, :work_type, :user_id, :created_at, :updated_at
json.url track_url(track, format: :json)