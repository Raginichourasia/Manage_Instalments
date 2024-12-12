class Installment < ApplicationRecord
  serialize :installment_structure, coder: JSON

  after_create :generate_installment_structure

  def generate_installment_structure
    Installments::GenerateStructureService.new(self).call
  end

  def update_installment(amount_paid, installment_number, action)
    Installments::UpdateService.new(self, amount_paid, installment_number, action).call
  end
end
