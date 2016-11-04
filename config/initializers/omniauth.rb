Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clef, 'ee62d01869399bd52e848568c57cff00', '4df776f848523975ed73ef440b797241',
  {:provider_ignores_state => true}
end
