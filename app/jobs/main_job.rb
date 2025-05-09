class MainJob < ApplicationJob
  queue_as :default

  AMOUNT_SUB_JOBS = 250_000

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times do |index|
      SubJob.perform_later(index, start_at.to_i, index == amount - 1)
    end
    puts "MainJob with amount ##{amount}. Total time taken: #{Time.now - start_at} sec. Total memory used: %.1fMB." % [`ps -o rss= -p #{$$}`.to_f/1024]
  end
end
