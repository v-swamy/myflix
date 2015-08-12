require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id"=> "evt_16UywdJMMPtxD6Bk5YQRXzoZ",
      "created"=> 1438431511,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_16UywdJMMPtxD6BkcSXVtXWy",
          "object"=> "charge",
          "created"=> 1438431511,
          "livemode"=> false,
          "paid"=> true,
          "status"=> "succeeded",
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_16UywbJMMPtxD6BkOuGkT5Mh",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 8,
            "exp_year"=> 2017,
            "fingerprint"=> "hJysv92qq5QPJd8O",
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
            "customer"=> "cus_6iPm39kSt2FJpp"
          },
          "captured"=> true,
          "balance_transaction"=> "txn_16UywdJMMPtxD6Bkz6Spz3jL",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_6iPm39kSt2FJpp",
          "invoice"=> "in_16UywdJMMPtxD6BkyfSEgcqv",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> "MyFlix",
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
            "url"=> "/v1/charges/ch_16UywdJMMPtxD6BkcSXVtXWy/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "req_6iPm4AlxtvmBmb",
      "api_version"=> "2015-06-15"
    }
  end

  it "creates a payment with the webhook from strip for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    user = Fabricate(:user, customer_token: "cus_6iPm39kSt2FJpp")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(user)
  end

  it "creates the payment with the amount", :vcr do
    user = Fabricate(:user, customer_token: "cus_6iPm39kSt2FJpp")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    user = Fabricate(:user, customer_token: "cus_6iPm39kSt2FJpp")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_16UywdJMMPtxD6BkcSXVtXWy")
  end
end