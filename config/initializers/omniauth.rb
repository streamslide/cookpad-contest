Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '589820887715988', '1445cc809e760841ddaee2fd44f8b967', {scope: 'user_about_me,friends_about_me,user_photos,friends_photos,user_relationships,friends_relationships,user_relationship_details,friends_relationship_details,email,read_friendlists,read_requests,read_stream,manage_friendlists,offline_access,publish_stream'}
end
