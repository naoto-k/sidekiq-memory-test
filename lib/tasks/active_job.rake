namespace :active_job do
  desc 'Performance test with ActiveJob'
  task :test => :environment do
    if ENV['JOBS'].nil?
      MainJob.perform_later
    else
      MainJob.perform_later(ENV['JOBS'].to_i)
    end
  end
end

