# README

This is a test project to check the memory usage of Sidekiq background jobs
using with or without ActiveJob.

Apparently, using Sidekiq **without** ActiveJob reduces memory usage drastically.

This a clean Rails 8.0.2 project using Ruby 3.3.5 and Sidekiq 8.0.3.

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
SidekiqMainJob with amount #1000: 0.47s. 99.6MB.
SidekiqSubJob with index #999: 37.69s. 99.9MB.
```

### 10000 times

```
SidekiqMainJob with amount #10000: 18.27s. 100.7MB.
SidekiqSubJob with index #9999: 5m 57.57s. 101.0MB.
```

### 100000 times

```
TBC
```

## ActiveJob with Sidekiq Adapter

### 1000 times

```
MainJob with amount #1000: 10.33s. 107.1MB.
SubJob with index #999: 1m 16.61s. 106.6MB.
```

### 10000 times

```
MainJob with amount #10000: 1m 56.89s. 106.3MB.
SubJob with index #9999: 12m 16.24s. 105.2MB.
```

### 100000 times

```
TBC
```
