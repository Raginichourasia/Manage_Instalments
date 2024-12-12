module Installments
  class GenerateStructureService
    def initialize(installment)
      @installment = installment
    end

    def call
      @installment.installment_structure ||= []
      @installment.installment_structure = Array.new(@installment.num_installments, @installment.total_amount / @installment.num_installments)
      @installment.save!
    end
  end
end
