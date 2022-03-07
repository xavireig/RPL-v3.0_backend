# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server, at: '/cable'

  match 'api/*other',
    controller: 'api/v1/base_api',
    action: 'handle_options_request',
    constraints: { method: 'OPTIONS' },
    via: [:options]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # auth module
      get '/email_confirm/:confirm_code',
        to: 'auth#email_confirm'

      post '/auth/try_forgot_password',
        to: 'auth#try_forgot_password'

      put '/auth/save_new_password',
        to: 'auth#save_new_password'

      get '/auth/vat', to: 'auth#valid_auth_token'
      post '/auth/signup', to: 'auth#signup'
      post '/auth/signin', to: 'auth#signin'
      delete '/auth/signout', to: 'auth#signout'

      get '/get_user_by_email', to: 'auth#user_by_email'
      post '/delete_account', to: 'auth#delete_account'

      # information about new files - deprecated
      post '/ext/files', to: 'ext#new_file'

      # add my club to some league
      post '/league/public_listing/:id',
        to: 'leagues#public_listing'

      post '/leagues/:league_id/club/:id/connect',
        to: 'clubs#connect'

      post '/leagues/:league_id/club/:id/disconnect',
        to: 'clubs#disconnect'

      post '/league_settings/:id/save_league_settings',
        to: 'league_settings#save_league_settings'

      put '/leagues/:id/start_draft',
        to: 'leagues#start_draft'

      post '/leagues/:league_id/set_league_draft_time',
        to: 'leagues#set_league_draft_time'

      post '/leagues/:league_id/set_time_per_pick',
        to: 'leagues#set_time_per_pick'

      get '/leagues/:id/league_draft_settings',
        to: 'leagues#league_draft_settings'

      get '/leagues/:league_id/league_squad_size',
        to: 'leagues#league_squad_size'

      put '/leagues/:id/reject_invite',
        to: 'leagues#reject_invite'

      get '/league_invites/:invite_id/check_league_can_accept_invite',
        to: 'league_invites#check_league_can_accept_invite'

      get '/leagues/my_league_invites',
        to: 'league_invites#my_league_invites'

      post '/leagues/my_league_invites/send_reminder',
        to: 'league_invites#send_reminder'

      get '/leagues/:id/get_scoring_type',
        to: 'scoring_type#scoring_type'

      put '/leagues/:league_id/set_scoring_type',
        to: 'scoring_type#set_scoring_type'

      put '/leagues/:league_id/set_scoring_is_def',
        to: 'scoring_type#set_scoring_is_def'

      put '/leagues/:id/sync_points_data',
        to: 'scoring_type#sync_points_data'

      put '/leagues/:id/sync_cats_data',
        to: 'scoring_type#sync_cats_data' # sync_cats_data

      post '/leagues/:id/reset_scoring_to_def',
        to: 'scoring_type#reset_scoring_to_def'

      get '/leagues/:id/club_info',
        to: 'clubs#club_info'

      post '/clubs/:id/take_free_agent',
        to: 'clubs#take_free_agent'

      post '/clubs/:id/drop_player',
        to: 'clubs#drop_player'

      get '/leagues/:id/code',
        to: 'leagues#leagues_code'

      get '/leagues/:code/link', to: 'leagues#leagues_info_link'

      get '/leagues/:id/league_clubs_list',
        to: 'leagues#league_clubs_list'

      get '/leagues/:league_id/league_clubs_list_with_patterns',
        to: 'leagues#league_clubs_list_with_patterns'

      get '/leagues/:league_id/fin_status',
        to: 'leagues#fin_status'

      put '/leagues/:league_id/fin_status',
        to: 'leagues#set_fin_status'

      get '/leagues/:id/tran_basic_settings',
        to: 'leagues#tran_basic_settings'

      put '/leagues/:league_id/tran_basic_settings',
        to: 'leagues#set_tran_basic_settings'

      get '/leagues/:id/tran_addit_setting',
        to: 'leagues#tran_addit_setting'

      put '/leagues/:league_id/tran_addit_setting',
        to: 'leagues#set_tran_addit_setting'

      get '/leagues/:league_id/settings/formation',
        to: 'leagues#league_settings_formation'

      post '/leagues/:league_id/settings/formation/drop',
        to: 'leagues#drop_league_settings_formation'

      post '/leagues/:league_id/settings/formation/add',
        to: 'leagues#add_league_settings_formation'

      get '/leagues/:league_id/settings/positions',
        to: 'leagues#league_settings_positions'

      post '/leagues/:league_id/set_transfer_deadlines',
        to: 'leagues#set_transfer_deadlines'

      post '/leagues/:league_id/set_squad_settings',
        to: 'leagues#set_squad_settings'

      post '/leagues/:league_id/set_fixture_settings',
        to: 'leagues#set_fixture_settings'

      get '/leagues/:id/show_with_formations',
        to: 'leagues#show_with_formations'

      get '/leagues/public_leagues',
        to: 'leagues#public_leagues'

      post '/bids/create_team_to_team_bid',
        to: 'bids#create_team_to_team_bid'

      get '/bids', to: 'bids#bids_index'
      get '/bids/user_requested_bids', to: 'bids#user_requested_bids'
      post '/bids/reject_bid', to: 'bids#reject_bid'
      post '/bids/revoke_bid', to: 'bids#revoke_bid'
      post '/bids/accept_bid', to: 'bids#accept_bid'
      post '/bids/bid_accept_process', to: 'bids#bid_accept_process'
      # admin work with bids
      get '/bids/:league_id/admin', to: 'bids#bids_admin_index'
      post '/bids/:league_id/:bid_id/approve_bid',
        to: 'bids#bids_admin_approve'
      post '/bids/:league_id/:bid_id/veto_bid', to: 'bids#bids_admin_veto'

      post '/promotions/create', to: 'promotions#create'
      post '/promotions/update', to: 'promotions#update'
      post '/promotions/change_enable_status',
        to: 'promotions#change_enable_status'
      post '/promotions/accept_invitation',
        to: 'promotions#accept_promotion_invitation'
      post '/promotions/index', to: 'promotions#index'

      get '/transfers/:league_id', to: 'transfer_activity#list_transfers'
      get '/total_trasfers/:club_id',
        to: 'transfer_activity#club_transfers_count'
      get '/trends/:league_id', to: 'transfer_activity#list_trends'

      post '/waiver_bids/create_waiver_bid',
        to: 'waiver_bids#create_waiver_bid'
      get '/waiver_bids', to: 'waiver_bids#bids_index'
      post '/waiver_bids/remove_bid', to: 'waiver_bids#remove_bid'
      post '/waiver_bids/change_auction_date',
        to: 'waiver_bids#change_auction_date'
      # This methods could be used for API turning on
      # post '/waiver_bids/apply_bid', to: 'waiver_bids#apply_bid'
      post '/waiver_bids/hold_an_auction', to: 'waiver_bids#hold_an_auction'

      get 'blog/features', to: 'blog#features'

      get 'cms_news_by_type', to: 'cms_news#cms_news_by_type'
      get 'get_injuries_and_suspensions', to: 'injury_and_suspension#index'
      get 'get_players_news', to: 'news#index'
      get 'league_scoring_type', to: 'scoring_type#scoring_type'
      post '/clubs/check_unique', to: 'clubs#check_unique'

      # notifications
      get '/notifications/get_notifications',
        to: 'notifications#index'
      post '/notifications/mark_as_viewed',
        to: 'notifications#mark_notification_as_viewed'
      # get '/notifications/get_league_notifications',
      #   to: 'notifications#league_notifications'

      resources :blog

      resources :leagues, only: %i[create index show update] do
        resources :league_messages, only: [:create]

        resources :league_invites, only: %i[create index]

        resources :footballers, only: [:index]

        resources :real_teams, only: [:index]

        resources :chats, only: %i[create index]

        resources :scoring_type, only: [:index]

        resources :epl_fixtures, only: [:index]
      end

      resources :clubs, only: %i[create update index show]

      get 'club_fixtures/:id', to: 'clubs#club_fixtures'
      get 'club_stats/:club_id', to: 'clubs#club_stats'
      get '/list_of_user_clubs', to: 'clubs#list_of_user_clubs'
      get 'players_table', to: 'footballers#players_table'
      get 'player_stats', to: 'footballers#player_stats'
      get 'all_players_stats', to: 'footballers#all_players_stats'

      get '/line_up/:league_id/round_list',
        to: 'line_up#round_list'

      get '/line_up/:virtual_club_id/:round_week_num/line_up_data',
        to: 'line_up#line_up_data'

      get '/line_up/:virtual_club_id/:round_week_num/line_up_data_for_club',
        to: 'line_up#line_up_data_for_club'

      put '/line_up/:virtual_club_id/:round_week_num/move_player',
        to: 'line_up#move_player'

      put '/line_up/:virtual_club_id/:round_week_num/change_line_up_format',
        to: 'line_up#change_line_up_format'

      get '/match_day/:league_id/:round_week_num/virtual_fixture_from_cache/:virt_fixture_id',
        to: 'match_day#full_virtual_fixture_data_from_cache'

      get '/match_day/:league_id/:round_week_num/
        virtual_fixture/:virt_fixture_id',
        to: 'match_day#full_virtual_fixture_data'

      get '/match_day/:league_id/:week_num/virtual_round_info',
        to: 'match_day#virtual_round_info'

      get '/match_day/:league_id/round_list',
        to: 'match_day#round_list'

      get '/match_day/:league_id/round_info/:round_num',
        to: 'match_day#round_info'

      get '/match_day/:league_id/fixtures_table/:round_num',
        to: 'match_day#fixtures_table'

      get '/match_day/:league_id/messages', to: 'match_day#messages'

      get '/match_day_league/:league_id/get_main_stat_tbl',
        to: 'match_day_league#main_stat_tbl'

      get '/match_day_league/:league_id/get_short_stat_tbl',
        to: 'match_day_league#short_stat_tbl'

      get '/match_day_league/:league_id/my_vf_data/:round_week_num',
        to: 'match_day_league#my_vf_data'

      get '/match_day_league/:league_id/news_by_league_or_club',
        to: 'match_day_league#news_by_league_or_club'

      get '/match_day_league/:league_id/my_club_in_league_stat',
        to: 'match_day_league#my_club_in_league_stat'

      post '/get_news', to: 'match_day_league#news_by_footballer'

      put '/draft/:league_id/player_to_queue/:footballer_id',
        to: 'draft#player_to_queue'

      get '/draft/:virtual_club_id/personal_queue',
        to: 'draft#personal_queue'

      delete '/draft/:league_id/personal_queue/:order_in_q',
        to: 'draft#rem_from_queue'

      put '/draft/:league_id/move_in_queue',
        to: 'draft#move_in_queue'

      get '/draft/:league_id/footballers_status',
        to: 'draft#footballers_status'

      get '/draft/:league_id/short_draft_status',
        to: 'draft#short_draft_status'

      get '/draft/:league_id/full_draft_status',
        to: 'draft#full_draft_status'

      put '/draft/:league_id/switch_auto_pick',
        to: 'draft#switch_auto_pick'

      get '/draft/:league_id/result',
        to: 'draft#result'

      post '/draft/:league_id/take_footballer/:footballer_id',
        to: 'draft#take_footballer'

      post '/draft/:league_id/undo', to: 'draft#undo'

      get '/draft/:league_id/free_footballers_table',
        to: 'draft#free_footballers_table'

      get '/league_draft_queue/:league_id',
        to: 'league_draft_queue#show'

      post '/league_draft_queue/:league_id/update_clubs_order_in_queue',
        to: 'league_draft_queue#update_clubs_order_in_queue'

      get '/seasons', to: 'season#index'
      get '/seasons/cur_week_number', to: 'season#cur_week_number'
      get '/seasons/cur_season', to: 'season#cur_season'

      get '/crest/shapes', to: 'crest#shapes'
      get '/crest/patterns/:shape_id', to: 'crest#patterns'

      get '/real_teams/:league_id/real_teams_list',
        to: 'real_teams#real_teams_list'

      post 'create_feedback', to: 'feedback#create'
      get 'footballer_team_color', to: 'footballers#footballer_team_color'

      post '/subscription/trial/:user_id',
        to: 'subscriptions#start_trial_subscription'

      post '/save_auto_sub', to: 'line_up#auto_sub'

      resources :subscriptions

      scope :subscription do
        get 'client_token', to: 'subscriptions#subscription_token'
        get 'user_status', to: 'subscriptions#user_status'
      end

      resources :virtual_clubs
      resources :webhooks, only: [] do
        collection { post :index }
      end
    end
  end
end
