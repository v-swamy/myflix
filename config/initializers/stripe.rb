Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    user.deactivate!
  end
end