# frozen_string_literal: true

# braintree configaretion
if Rails.env.production?
  Braintree::Configuration.environment = :production
else
  Braintree::Configuration.environment = :sandbox
end

Braintree::Configuration.merchant_id = CONFIG['braintree']['merchant_id']
Braintree::Configuration.public_key = CONFIG['braintree']['public_key']
Braintree::Configuration.private_key = CONFIG['braintree']['private_key']
