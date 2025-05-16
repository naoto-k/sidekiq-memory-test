namespace :active_job do
  desc 'Performance test with ActiveJob'
  task :test => :environment do
    if ENV['JOBS'].nil?
      MainJob.perform_later
    else
      MainJob.perform_later(ENV['JOBS'].to_i)
    end
  end

  desc 'Performance test with ActiveJob (bulk)'
  task :test_bulk => :environment do
    if ENV['JOBS'].nil?
      BulkJob.perform_later
    else
      BulkJob.perform_later(ENV['JOBS'].to_i)
    end
  end
end

