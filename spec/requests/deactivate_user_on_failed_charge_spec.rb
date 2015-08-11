require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id"=> "evt_16YeM4JMMPtxD6BkAyK0OKBd",
      "created"=> 1439305676,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_16YeM4JMMPtxD6BkvzI69SDC",
          "object"=> "charge",
          "created"=> 1439305676,
          "livemode"=> false,
          "paid"=> false,
          "status"=> "failed",
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_16YeHYJMMPtxD6Bk1gPJ9x5L",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 8,
            "exp_year"=> 2018,
            "fingerprint"=> "hQHESuHoEl2eQKJS",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "tokenization_method"=> nil,
            "dynamic_last4"=> nil,
            "metadata"=> {},
            "customer"=> "cus_6k6Q7dIgREEspH"
          },
          "captured"=> false,
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_6k6Q7dIgREEspH",
          "invoice"=> nil,
          "description"=> "failed test",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> nil,
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "destination"=> nil,
          "application_fee"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_16YeM4JMMPtxD6BkvzI69SDC/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "req_6mCleblnTMbQKd",
      "api_version"=> "2015-06-15"
    }
  end

  it "deactivates a user when charge failed event received from Stripe on webhook", :vcr do
    user = Fabricate(:user, customer_token: "cus_6k6Q7dIgREEspH")
    post "/stripe_events", event_data
    expect(user.reload).not_to be_active
  end


end