# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
Rails.application.routes.draw do
  apipie

  root to: 'misc#ping'

  as :hackers do
    get '/hackers/auth', to: 'hackers#auth'
    get '/hackers/auth/callback', to: 'hackers#callback'
    post '/hackers/oauth', to: 'hackers#oauth'
  end
end
