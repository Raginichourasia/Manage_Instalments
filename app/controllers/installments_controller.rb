class InstallmentsController < ApplicationController
  before_action :set_installment, only: [:show, :edit, :update, :destroy, :pay_installment]

  def index
    @installments = Installment.all
  end

  def show; end

  def new
    @installment = Installment.new
  end

  def edit; end

  def create
    @installment = Installment.new(installment_params)

    if @installment.save
      redirect_to @installment, notice: "Installment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @installment.update(installment_params)
      redirect_to @installment, notice: "Installment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @installment.destroy
    redirect_to installments_path, notice: "Installment was successfully destroyed."
  end

  def pay_installment
    amount_paid = params[:amount_paid].to_i
    installment_number = params[:installment_number].to_i
    action = params[:action_type]

    if @installment.update_installment(amount_paid, installment_number, action)
      redirect_to @installment, notice: "Installment updated successfully."
    else
      redirect_to @installment, alert: "Error updating installment."
    end
  end

  private

  def set_installment
    @installment = Installment.find(params[:id])
  end

  def installment_params
    params.require(:installment).permit(:student_name, :total_amount, :num_installments, :installment_structure)
  end
end
