namespace :sidekiq do
  desc 'Sidekiq performance test with ActiveJob'
  task :test => :environment do
    if ENV['JOBS'].nil?
      MainJob.perform_later
    else
      MainJob.perform_later(ENV['JOBS'].to_i)
    end
  end

  desc 'Sidekiq performance test with Sidekiq'
  task :test_sidekiq => :environment do
    if ENV['JOBS'].nil?
      SidekiqMainJob.perform_async
    else
      SidekiqMainJob.perform_async(ENV['JOBS'].to_i)
    end
  end
end
