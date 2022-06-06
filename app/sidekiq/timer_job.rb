require 'sidekiq-scheduler'

class TimerJob
  include Sidekiq::Job

  def perform
    PaymentAdapter.check_status_active_transactions
  end
end
