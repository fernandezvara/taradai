Taradai::Application.routes.draw do

  devise_for :users
  
  resources :profiles, :only => [:new, :create, :edit, :update]
  resources :pendings, :only => [:create, :delete]
  resources :messages, :only => [:create]
  
  match 'map',                                              :controller => 'maps',             :action => 'random',              :as => 'maps_random'
  match 'my/map(.:format)',                                  :controller => 'maps',             :action => 'query',               :as => 'maps_query'
  # Searching.....
  match 's',                                                :controller => 'search',           :action => 'form',                :as => 'search_form'
  match 's/results',                                        :controller => 'search',           :action => 'results',             :as => 'search_results'
  
  # Locale
  match 'my/locale/:locale',                                :controller => 'locale',           :action => 'change',              :as => 'locale'
  
  #Activities - Ajax
  match 'my/netupdates.:format',                            :controller => 'network',          :action => 'updates',             :as => "network_updates"
  match ':profilename/updates.:format',                     :controller => 'prof',             :action => 'updates',             :as => "profile_updates"
  
  # Notifications
  match 'my/notifications/preview',                         :controller => 'notifications',    :action => 'preview',             :as => 'notifications_preview'
  match 'my/notifications',                                 :controller => 'notifications',    :action => 'index',               :as => 'notifications_index'
    
  # Blogs
  
  match 'my/blog',                                          :controller => 'blogs',            :action => 'index',               :as => 'blog_my'
  match 'my/blog/new',                                      :controller => 'blogs',            :action => 'new',                 :as => 'blog_new'
  match 'my/blog/create',                                   :controller => 'blogs',            :action => 'create',              :as => 'blog_create'
  match 'my/blog/:slug/',                                   :controller => 'blogs',            :action => 'read',                :as => 'blog_read'
  match 'my/blog/:slug/edit',                               :controller => 'blogs',            :action => 'edit',                :as => 'blog_edit'
  match 'my/blog/:slug/update',                             :controller => 'blogs',            :action => 'update',              :as => 'blog_update'
  match 'my/blog/:slug/delete',                             :controller => 'blogs',            :action => 'delete',              :as => 'blog_delete'
  match 'my/blog/:slug/destroy',                            :controller => 'blogs',            :action => 'destroy',             :as => 'blog_destroy'
  
  match ':profilename/blog',                                :controller => 'blogs',            :action => 'browse',              :as => 'blogs_show'
  match ':profilename/blog/:slug',                          :controller => 'blogs',            :action => 'show',                :as => 'blog_show'
  
  
  #Messages
  match 'my/messages/inbox',                                :controller => 'messages',         :action => 'inbox',               :as => 'messages_inbox'
  match 'my/messages/preview',                              :controller => 'messages',         :action => 'preview',             :as => 'messages_preview'
  match 'my/messages/inbox/:slug',                          :controller => 'messages',         :action => 'read_inbox',          :as => 'message_read_inbox'
  match 'my/messages/inbox/delete/:slug',                   :controller => 'messages',         :action => 'delete_inbox',        :as => 'message_delete_inbox'
  match 'my/messages/inbox/destroy/:slug',                  :controller => 'messages',         :action => 'destroy_inbox',       :as => 'message_destroy_inbox'
  match 'my/messages/outbox',                               :controller => 'messages',         :action => 'outbox',              :as => 'messages_outbox'
  match 'my/messages/new',                                  :controller => 'messages',         :action => 'new',                 :as => 'message_new'
  match 'my/messages/reply/:slug',                          :controller => 'messages',         :action => 'reply',               :as => 'message_reply'
  match 'my/messages/outbox/:slug',                         :controller => 'messages',         :action => 'read_outbox',         :as => 'message_read_outbox'
  match 'my/messages/outbox/delete/:slug',                  :controller => 'messages',         :action => 'delete_outbox',       :as => 'message_delete_outbox'
  match 'my/messages/outbox/destroy/:slug',                 :controller => 'messages',         :action => 'destroy_outbox',      :as => 'message_destroy_outbox'
  
  #Friends
  match 'my/friends/accept/:id',                            :controller => 'pendings',         :action => 'accept',              :as => 'friend_accept'
  match 'my/friends/ignore/:id',                            :controller => 'pendings',         :action => 'ignore',              :as => 'friend_ignore' 
  match 'my/friends/list.:format',                          :controller => 'friends',          :action => 'list',                :as => 'friend_list'
  match 'my/friends/requested',                             :controller => 'pendings',         :action => 'requested',           :as => 'friend_requested'
  match 'my/friends/requests',                              :controller => 'pendings',         :action => 'index',               :as => 'friend_requests' 
  match 'my/friends/request/:profilename',                  :controller => 'friends',          :action => 'req',                 :as => 'friend_request'
  
  # Portraits (must validate object class before use one or other uploader!!!)
  match ':profilename/portrait/new',                        :controller => 'portrait',         :action => 'new',                 :as => 'portrait_new'
  match ':profilename/portrait/create',                     :controller => 'portrait',         :action => 'create',              :as => 'portrait_create'
  match ':profilename/portrait/delete',                     :controller => 'portrait',         :action => 'delete',              :as => 'portrait_delete'
  match ':profilename/portrait/destroy',                    :controller => 'portrait',         :action => 'destroy',             :as => 'portrait_destroy'
  
  # Statuses
  match ':profilename/status/new',                          :controller => 'statuses',         :action => 'new',                 :as => 'status_new'
  match ':profilename/status/change',                       :controller => 'statuses',         :action => 'create',              :as => 'status_create'
  
  # Photos, albums
  match ':profilename/photos',                              :controller => 'photos',           :action => 'show',                :as => 'photos_show'
  match ':profilename/photos/album/new',                    :controller => 'photos',           :action => 'album_new',           :as => 'album_new'
  match '/photos/album/create',                             :controller => 'photos',           :action => 'album_create',        :as => 'album_create'
  match ':profilename/photos/album/:slug',                  :controller => 'photos',           :action => 'album_show',          :as => 'album_show'
  match ':profilename/photos/album/:slug/organize',         :controller => 'photos',           :action => 'album_organize',      :as => 'album_organize'
  match ':profilename/photos/album/:slug/delete',           :controller => 'photos',           :action => 'album_delete',        :as => 'album_delete'
  match ':profilename/photos/album/:slug/deleteit',         :controller => 'photos',           :action => 'album_deleteit',      :as => 'album_deleteit'
  match ':profilename/photos/album/:slug/org',              :controller => 'photos',           :action => 'album_org',           :as => 'album_org'
  match '/photos/album/:slug/cover/:id',                    :controller => 'photos',           :action => 'album_cover',         :as => 'album_cover'
  match '/photos/album/:slug/newcover/:id',                 :controller => 'photos',           :action => 'album_newcover',      :as => 'album_change_cover'
  match '/photos/album/:slug/delete/:id',                   :controller => 'photos',           :action => 'photo_delete',        :as => 'photo_delete'
  match '/photos/album/:slug/deleteit/:id',                 :controller => 'photos',           :action => 'photo_deleteit',      :as => 'photo_deleteit'
  match ':profilename/photos/album/:slug/new',              :controller => 'photos',           :action => 'photo_new',           :as => 'photo_new'
  match ':profilename/photos/album/:slug/:id',              :controller => 'photos',           :action => 'photo_show',          :as => 'photo_show'
  match '/photos/create',                                   :controller => 'photos',           :action => 'photo_create',        :as => 'photo_create'

  #Matchers for tendencies....
  match '/t/:name',                                         :controller => 'tendencies',       :action => 'show',                :as => 'tendencies_show'
  match '/t/:name/forum',                                   :controller => 'tendencies',       :action => 'forum',               :as => 'tendencies_forum'
  match '/t/:name/forum/new',                               :controller => 'tendencies',       :action => 'forum_new',           :as => 'tendencies_forum_new'  
  match '/t/:name/forum/create',                            :controller => 'tendencies',       :action => 'forum',               :as => 'tendencies_forum_create'
  match '/t/:name/blogs',                                   :controller => 'tendencies',       :action => 'blogs',               :as => 'tendencies_blogs'
  match '/t/:name/members',                                 :controller => 'tendencies',       :action => 'members',             :as => 'tendencies_members'
  match '/t/:name/groups',                                  :controller => 'tendencies',       :action => 'groups',              :as => 'tendencies_groups'

  #Matchers for ongs...

  #Matchers for companies...

  #Matchers for groups....
  match '/my/groups/new',                                   :controller => 'groups',            :action => 'new',                 :as => 'group_new'
  match '/g/create',                                        :controller => 'groups',            :action => 'create',              :as => 'group_create'
  match '/my/groups',                                       :controller => 'groups',            :action => 'browse',              :as => 'groups_show'
  match '/g/:slug',                                         :controller => 'groups',            :action => 'show',                :as => 'group_show'
  match '/g/:slug/edit',                                    :controller => 'groups',            :action => 'edit',                :as => 'group_edit'  
  match '/g/:slug/update',                                  :controller => 'groups',            :action => 'update',              :as => 'group_update'
  match '/g/:slug/delete',                                  :controller => 'groups',            :action => 'delete',              :as => 'group_delete'
  match '/g/:slug/destroy',                                 :controller => 'groups',            :action => 'destroy',             :as => 'group_destroy'
  match '/g/:slug/portrait',                                :controller => 'groups',            :action => 'portrait',            :as => 'group_portrait'
  match '/g/:slug/portrait/create',                         :controller => 'groups',            :action => 'portrait_create',     :as => 'group_portrait_create'  
  
  
  match '/g/:slug/apply',                                   :controller => 'groups',            :action => 'apply',               :as => 'group_apply' # apply for membership
  match '/g/:slug/applycreate',                             :controller => 'groups',            :action => 'applycreate',         :as => 'group_apply_create'
  match '/g/:slug/join',                                    :controller => 'groups',            :action => 'join',                :as => 'group_join' #when public
  match '/g/:slug/joincreate',                              :controller => 'groups',            :action => 'joincreate',          :as => 'group_join_create'
  match '/g/:slug/forum',                                   :controller => 'gforum',            :action => 'index',               :as => 'group_forum'
  match '/g/:slug/photos',                                  :controller => 'groups',            :action => 'photos',              :as => 'group_photos'
  match '/g/:slug/events',                                  :controller => 'groups',            :action => 'events',              :as => 'group_events'
  match '/g/:slug/members',                                 :controller => 'groups',            :action => 'members',             :as => 'group_members'
  match '/g/:slug/applies',                                 :controller => 'groups',            :action => 'applies',             :as => 'group_applies'  
  
  match '/g/:slug/accept/:prof',                            :controller => 'groups',            :action => 'accept',             :as => 'group_apply_accept'  
  match '/g/:slug/ignore/:prof',                            :controller => 'groups',            :action => 'ignore',             :as => 'group_apply_ignore'  
  
  # Group Forum
  match '/g/:slug/forum/new',                              :controller => 'gforum',            :action => 'new_topic',           :as => 'group_forum_topic_new'  
  match '/g/:slug/forum/create',                           :controller => 'gforum',            :action => 'create_topic',        :as => 'group_forum_topic_create'
  match '/g/:slug/forum/:tslug',                           :controller => 'gforum',            :action => 'topic',               :as => 'group_forum_topic_show'  
  match '/g/:slug/forum/:tslug/edit',                      :controller => 'gforum',            :action => 'edit_topic',          :as => 'group_forum_topic_edit'  
  match '/g/:slug/forum/:tslug/update',                    :controller => 'gforum',            :action => 'update_topic',        :as => 'group_forum_topic_update'
  match '/g/:slug/forum/:tslug/delete',                    :controller => 'gforum',            :action => 'delete_topic',        :as => 'group_forum_topic_delete'  
  match '/g/:slug/forum/:tslug/destroy',                   :controller => 'gforum',            :action => 'destroy_topic',       :as => 'group_forum_topic_destroy'

  match '/g/:slug/forum/:tslug/answer',                    :controller => 'gforum',            :action => 'new_answer',          :as => 'group_forum_topic_answer_new'  
  match '/g/:slug/forum/:tslug/answer/create',             :controller => 'gforum',            :action => 'create_answer',       :as => 'group_forum_topic_answer_create'
  match '/g/:slug/forum/:tslug/:aslug/edit',               :controller => 'gforum',            :action => 'edit_answer',         :as => 'group_forum_topic_answer_edit'  
  match '/g/:slug/forum/:tslug/:aslug/update',             :controller => 'gforum',            :action => 'update_answer',       :as => 'group_forum_topic_answer_update'  
  match '/g/:slug/forum/:tslug/:aslug/delete',             :controller => 'gforum',            :action => 'delete_answer',       :as => 'group_forum_topic_answer_delete'  
  match '/g/:slug/forum/:tslug/:aslug/destroy',            :controller => 'gforum',            :action => 'destroy_answer',      :as => 'group_forum_topic_answer_destroy'  
  match '/g/:slug/forum/:tslug#(:aslug)',                  :controller => 'gforum',            :action => 'topic',               :as => 'group_forum_topic_show' 
      
  #Matchers for users....
  match ':profilename/friends',             :controller => 'friends',          :action => 'show',             :as => 'friends_show'
  match ':profilename/about',               :controller => 'profiles',         :action => 'about',            :as => 'profile_about'
  match ':profilename/groups',              :controller => 'groups',           :action => 'profile_show',     :as => 'profile_groups'
  
  # must search for profile type... then show the correct form, so the view must have a conditional for each profile type.
  match 'my/data',                          :controller => 'profiles',         :action => 'edit',       :as => 'profile_edit'
  #Generic matcher for all profiles...
  match ':profilename',                     :controller => 'prof',             :action => 'show',       :as => 'profile_show'

  root :to => "network#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
