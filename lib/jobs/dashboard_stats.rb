module Jobs
  class DashboardStats < Jobs::Base

    def execute(args)
      stats_json = AdminDashboardData.fetch_stats.as_json

      # Add some extra time to the expiry so that the next job run has plenty of time to
      # finish before previous cached value expires.
      $redis.setex AdminDashboardData.stats_cache_key, (AdminDashboardData.recalculate_interval + 5).minutes, stats_json.to_json

      stats_json
    end

  end
end