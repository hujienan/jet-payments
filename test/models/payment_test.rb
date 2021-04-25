require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "should not save payment without value" do
    payment = Payment.new
    payment.save
  end
end
