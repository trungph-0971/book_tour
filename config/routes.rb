Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "application#hello"
  end
end
