json.extract! installment, :id, :student_name, :total_amount, :num_installments, :installment_structure, :created_at, :updated_at
json.url installment_url(installment, format: :json)
