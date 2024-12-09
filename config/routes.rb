Rails.application.routes.draw do
  root "installments#new"

  resources :installments do
    post :pay_installment, on: :member
  end
end
