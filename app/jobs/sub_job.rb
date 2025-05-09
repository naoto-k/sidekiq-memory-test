class SubJob < ApplicationJob
  queue_as :default

  def perform(index, queued_at, is_last)
    puts "SubJob with index ##{index}: #{Time.now - Time.at(queued_at)} sec. Total memory used: %.1fMB." % [`ps -o rss= -p #{$$}`.to_f/1024] if is_last
  end
end
