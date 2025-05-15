class SidekiqMainJob
  include Sidekiq::Job
  include Logging
  include Amount

  def perform(amount = AMOUNT_SUB_JOBS)
    start_at = Time.now
    amount.times.each_slice(AMOUNT_EACH_SLICE) do |index|
      args = index.map do |i|
        [i, start_at.to_i, i == amount - 1]
      end
      SidekiqSubJob.perform_bulk(args)
    end
    puts "SidekiqMainJob with amount ##{amount}: #{time_usage(start_at)}. #{memory_usage}."
  end
end

