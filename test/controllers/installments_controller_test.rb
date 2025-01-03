require "test_helper"

class InstallmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @installment = installments(:one)
  end

  test "should get index" do
    get installments_url
    assert_response :success
  end

  test "should get new" do
    get new_installment_url
    assert_response :success
  end

  test "should create installment" do
    assert_difference("Installment.count") do
      post installments_url, params: { installment: { installment_structure: @installment.installment_structure, num_installments: @installment.num_installments, student_name: @installment.student_name, total_amount: @installment.total_amount } }
    end

    assert_redirected_to installment_url(Installment.last)
  end

  test "should show installment" do
    get installment_url(@installment)
    assert_response :success
  end

  test "should get edit" do
    get edit_installment_url(@installment)
    assert_response :success
  end

  test "should update installment" do
    patch installment_url(@installment), params: { installment: { installment_structure: @installment.installment_structure, num_installments: @installment.num_installments, student_name: @installment.student_name, total_amount: @installment.total_amount } }
    assert_redirected_to installment_url(@installment)
  end

  test "should destroy installment" do
    assert_difference("Installment.count", -1) do
      delete installment_url(@installment)
    end

    assert_redirected_to installments_url
  end
end
