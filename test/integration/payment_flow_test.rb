require "test_helper"

class PaymentFlowTest < ActionDispatch::IntegrationTest
  test "can see the index page" do
    get "/"
    assert_select "h1", "Jet payments"
  end

  test "can create a payment" do
    get "/"
    assert_response :success

    post "/payments",
      params: {
        card_number: "5560000000000001",
        security_code: "111",
        name_on_card: "jet",
        expiry_date: "1223",
        email_address: "jet@safesoft.com.au",
        billing_address: "Perth city"
      }, xhr: true
    
    assert_response 400

    post "/payments",
      params: {
        card_number: "5520000000000000",
        security_code: "111",
        name_on_card: "jet",
        expiry_date: "1223",
        email_address: "jet@safesoft.com.au",
        billing_address: "Perth city"
      }, xhr: true
    
    assert_response 200
  end
end
