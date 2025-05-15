class SolidQueueMainJob < ApplicationJob
  include Logging
  include Amount

  self.queue_adapter = :solid_queue

  queue_as :default

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times.each_slice(AMOUNT_EACH_SLICE) do |index|
      jobs = index.map do |i|
        SolidQueueSubJob.new(i, start_at.to_i, i == amount - 1)
      end
      ActiveJob.perform_all_later(jobs)
    end
    puts "SolidQueueMainJob with amount ##{amount}: #{time_usage(start_at)}. #{memory_usage}."
  end
end

