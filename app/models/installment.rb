class Installment < ApplicationRecord
  serialize :installment_structure, JSON

  after_create :generate_installment_structure

  def generate_installment_structure
    self.installment_structure ||= []
    self.installment_structure = Array.new(num_installments, total_amount / num_installments)
    save!
  end

  def update_installment(amount_paid, installment_number, action)
    return false unless valid_installment_structure?

    structure = installment_structure.dup
    current_installment = structure[installment_number - 1]

    if amount_paid > current_installment
      handle_excess_payment(structure, installment_number, amount_paid, current_installment)
    elsif amount_paid < current_installment
      handle_partial_payment(structure, installment_number, amount_paid, current_installment, action)
    else
      structure[installment_number - 1] = amount_paid
    end

    self.installment_structure = structure
    save!
  end

  private

  def valid_installment_structure?
    return true unless installment_structure.nil? || installment_structure.empty?

    errors.add(:base, "Installment structure is not set.")
    false
  end

  def handle_excess_payment(structure, installment_number, amount_paid, current_installment)
    excess_amount = amount_paid - current_installment
    structure[installment_number - 1] = amount_paid
    adjust_excess(structure, installment_number, excess_amount)
  end

  def handle_partial_payment(structure, installment_number, amount_paid, current_installment, action)
    remaining_amount = current_installment - amount_paid
    structure[installment_number - 1] = amount_paid

    if action == "add_to_next"
      adjust_next_installment(structure, installment_number, remaining_amount)
    elsif action == "create_new"
      structure.insert(installment_number, remaining_amount)
    end
  end

  def adjust_excess(structure, installment_number, excess_amount)
    return if excess_amount <= 0

    structure[installment_number..].each_with_index do |amount, index|
      next_installment_index = installment_number + index

      if excess_amount <= amount
        structure[next_installment_index] -= excess_amount
        break
      else
        excess_amount -= structure[next_installment_index]
        structure[next_installment_index] = 0
      end
    end
  end

  def adjust_next_installment(structure, installment_number, remaining_amount)
    if installment_number < structure.size
      structure[installment_number] += remaining_amount
    else
      structure.push(remaining_amount)
    end
  end
end
