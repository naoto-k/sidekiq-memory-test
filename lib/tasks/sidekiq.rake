namespace :sidekiq do
  desc 'Performance test with Sidekiq'
  task :test => :environment do
    if ENV['JOBS'].nil?
      SidekiqMainJob.perform_async
    else
      SidekiqMainJob.perform_async(ENV['JOBS'].to_i)
    end
  end
end
