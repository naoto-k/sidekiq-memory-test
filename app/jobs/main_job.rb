class MainJob < ApplicationJob
  include Logging

  queue_as :default

  AMOUNT_SUB_JOBS = 250_000

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times do |index|
      SubJob.perform_later(index, start_at.to_i, index == amount - 1)
    end
    puts "MainJob with amount ##{amount}: #{time_usage(start_at)}. #{memory_usage}."
  end
end
