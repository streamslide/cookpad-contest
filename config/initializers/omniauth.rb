Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '589820887715988', '1445cc809e760841ddaee2fd44f8b967', {scope: 'user_about_me,user_photos,friends_photos,email,offline_access'}
end
