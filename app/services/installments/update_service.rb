module Installments
  class UpdateService
    def initialize(installment, amount_paid, installment_number, action)
      @installment = installment
      @amount_paid = amount_paid
      @installment_number = installment_number
      @action = action
    end

    def call
      return false unless valid_installment_structure?

      structure = @installment.installment_structure.dup
      current_installment = structure[@installment_number - 1]

      if @amount_paid > current_installment
        handle_excess_payment(structure, current_installment)
      elsif @amount_paid < current_installment
        handle_partial_payment(structure, current_installment)
      else
        structure[@installment_number - 1] = @amount_paid
      end

      @installment.installment_structure = structure
      @installment.save!
    end

    private

    def valid_installment_structure?
      return true unless @installment.installment_structure.nil? || @installment.installment_structure.empty?

      @installment.errors.add(:base, "Installment structure is not set.")
      false
    end

    def handle_excess_payment(structure, current_installment)
      excess_amount = @amount_paid - current_installment
      structure[@installment_number - 1] = @amount_paid
      adjust_excess(structure, excess_amount)
    end

    def handle_partial_payment(structure, current_installment)
      remaining_amount = current_installment - @amount_paid
      structure[@installment_number - 1] = @amount_paid

      if @action == "add_to_next"
        adjust_next_installment(structure, remaining_amount)
      elsif @action == "create_new"
        structure.insert(@installment_number, remaining_amount)
      end
    end

    def adjust_excess(structure, excess_amount)
      return if excess_amount <= 0

      structure[@installment_number..].each_with_index do |amount, index|
        next_installment_index = @installment_number + index

        if excess_amount <= amount
          structure[next_installment_index] -= excess_amount
          break
        else
          excess_amount -= structure[next_installment_index]
          structure[next_installment_index] = 0
        end
      end
    end

    def adjust_next_installment(structure, remaining_amount)
      if @installment_number < structure.size
        structure[@installment_number] += remaining_amount
      else
        structure.push(remaining_amount)
      end
    end
  end
end
