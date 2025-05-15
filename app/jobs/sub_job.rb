class SubJob < ApplicationJob
  include Logging

  self.queue_adapter = :sidekiq

  queue_as :default

  def perform(index, queued_at, is_last)
    puts "SubJob with index ##{index}: #{time_usage(queued_at)}. #{memory_usage}." if is_last
  end
end
