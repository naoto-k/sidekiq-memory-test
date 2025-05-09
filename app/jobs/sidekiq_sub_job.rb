class SidekiqSubJob
  include Sidekiq::Job
  include Logging

  def perform(index, queued_at, is_last)
    puts "SidekiqSubJob with index ##{index}: #{time_usage(queued_at)}. #{memory_usage}." if is_last
  end
end

