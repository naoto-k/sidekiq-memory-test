class SolidQueueMainJob < ApplicationJob
  include Logging
  include Amount

  self.queue_adapter = :solid_queue

  queue_as :main

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times do |index|
      SolidQueueSubJob.perform_later(index, start_at.to_i, index == amount - 1)
    end
    puts "SolidQueueMainJob with amount ##{amount}: #{time_usage(start_at)}. #{memory_usage}."
  end
end

