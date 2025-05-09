# README

This is a test project to check the memory usage of Sidekiq background jobs
using with or without ActiveJob.

Apparently, using Sidekiq **without** ActiveJob reduces memory usage drastically.

This a clean Rails 5.1.5 project using Ruby 2.4.3 and Sidekiq 5.1.1.

It simulates a specific use case where one background job enqueues thousands of sub jobs.

To run the test, first start sidekiq with

```
docker compose up -d
```

and then run the test with

```
docker compose exec app bundle exec rake sidekiq:test
```

```
docker compose exec app bundle exec rake sidekiq:test_sidekiq
```

It will enqueue 250_000 jobs by default.

You can change the number of jobs to enqueue by setting the `JOBS` environment variable, e.g.:

```
docker compose exec -e JOBS=10_000 app bundle exec rake sidekiq:test
```

The results on my local dev environment are:

## Sidekiq::Worker

### 1000 times

```
SidekiqMainJob with amount #1000. Total time taken: 3.59596179 sec. Total memory used: 90.5MB.
SidekiqSubJob with index #999: 4.964172652 sec. Total memory used: 90.9MB.
```

### 10000 times

```
SidekiqMainJob with amount #10000. Total time taken: 27.888882899 sec. Total memory used: 97.8MB.
SidekiqSubJob with index #9999: 65.169397941 sec. Total memory used: 100.3MB.
```

### 100000 times

```
SidekiqMainJob with amount #100000. Total time taken: 316.123098262 sec. Total memory used: 135.9MB.
SidekiqSubJob with index #99999: 466.372994784 sec. Total memory used: 142.8MB.
```

## ActiveJob with Sidekiq Adapter

### 1000 times

```
MainJob with amount #1000. Total time taken: 10.414916688 sec. Total memory used: 92.3MB.
SubJob with index #999: 10.929477986 sec. Total memory used: 92.3MB.
```

### 10000 times

```
MainJob with amount #10000. Total time taken: 48.659713855 sec. Total memory used: 116.6MB.
SubJob with index #9999: 129.917127836 sec. Total memory used: 122.4MB.
```

### 100000 times

```
MainJob with amount #100000. Total time taken: 1129.007123868 sec. Total memory used: 307.8MB.
SubJob with index #99999: 1129.604909318 sec. Total memory used: 307.8MB.
```
