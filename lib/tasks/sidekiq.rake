namespace :sidekiq do
  desc 'Performance test with Sidekiq'
  task :test => :environment do
    if ENV['JOBS'].nil?
      SidekiqMainJob.perform_async
    else
      SidekiqMainJob.perform_async(ENV['JOBS'].to_i)
    end
  end

  desc 'Performance test with Sidekiq (bulk)'
  task :test_bulk => :environment do
    if ENV['JOBS'].nil?
      SidekiqBulkJob.perform_async
    else
      SidekiqBulkJob.perform_async(ENV['JOBS'].to_i)
    end
  end
end
