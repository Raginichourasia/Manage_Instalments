require "application_system_test_case"

class InstallmentsTest < ApplicationSystemTestCase
  setup do
    @installment = installments(:one)
  end

  test "visiting the index" do
    visit installments_url
    assert_selector "h1", text: "Installments"
  end

  test "should create installment" do
    visit installments_url
    click_on "New installment"

    fill_in "Installment structure", with: @installment.installment_structure
    fill_in "Num installments", with: @installment.num_installments
    fill_in "Student name", with: @installment.student_name
    fill_in "Total amount", with: @installment.total_amount
    click_on "Create Installment"

    assert_text "Installment was successfully created"
    click_on "Back"
  end

  test "should update Installment" do
    visit installment_url(@installment)
    click_on "Edit this installment", match: :first

    fill_in "Installment structure", with: @installment.installment_structure
    fill_in "Num installments", with: @installment.num_installments
    fill_in "Student name", with: @installment.student_name
    fill_in "Total amount", with: @installment.total_amount
    click_on "Update Installment"

    assert_text "Installment was successfully updated"
    click_on "Back"
  end

  test "should destroy Installment" do
    visit installment_url(@installment)
    click_on "Destroy this installment", match: :first

    assert_text "Installment was successfully destroyed"
  end
end