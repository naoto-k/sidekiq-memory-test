namespace :solid_queue do
  desc 'SolidQueue performance test with ActiveJob'
  task :test => :environment do
    if ENV['JOBS'].nil?
      SolidQueueMainJob.perform_later
    else
      SolidQueueMainJob.perform_later(ENV['JOBS'].to_i)
    end
  end
end
