class DeleteOldPostsWorker
  include Sidekiq::Worker

  def perform
    Post.where('created_at < ?', 24.hours.ago).destroy_all
  end
end