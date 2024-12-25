require 'sidekiq/cron'

Sidekiq::Cron::Job.load_from_hash YAML.load_file(File.join(Rails.root, 'config', 'schedule.yml')) if File.exist?(File.join(Rails.root, 'config', 'schedule.yml'))