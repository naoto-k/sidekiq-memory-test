class SidekiqMainJob
  include Sidekiq::Job
  include Logging

  AMOUNT_SUB_JOBS = 250_000

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times do |index|
      SidekiqSubJob.perform_async(index, start_at.to_i, index == amount - 1)
    end
    puts "SidekiqMainJob with amount ##{amount}: #{time_usage(start_at)}. #{memory_usage}."
  end
end

