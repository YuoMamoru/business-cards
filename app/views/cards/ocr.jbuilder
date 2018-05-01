# frozen_string_literal: true

json.key_format! camelize: :lower
json.extract! @texts, :lines, :company_id, :post_codes, :addresses, :phones, :mails
