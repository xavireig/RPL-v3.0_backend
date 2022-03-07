# frozen_string_literal: true

task prepare_league: :environment do
  8.times do
    user = User.create!(
      fname: Faker::Name.name,
      lname: Faker::Name.name,
      email: Faker::Internet.email,
      password: 'password',
      provider: 'base',
      confirmed_at: Time.now
    )
    user.confirm
    user.skip_confirmation_notification!
  end
  league = League.create!(
    title: Faker::Team.name,
    required_teams: 8,
    starting_round: 1,
    match_numbers: 24,
    user: User.last,
    draft_time: Time.current,
    season_id: 1,
    invite_code: Faker::Number.unique.number(10)
  )

  formations = %w[f442 f433 f451 f352 f343 f541 f532]
  formations.each do |name|
    Formation.create!(
      name: name,
      league_id: league.id,
      allowed: true
    )
  end

  footballer_ids = Season.last.footballers.map(&:id)
  footballer_ids.each do |footballer_id|
    VirtualFootballer.create!(
      league_id: league.id,
      footballer_id: footballer_id
    )
  end

  DraftOrder.create(
    current_iteration: 0,
    current_step: 0,
    league_id: league.id,
    queue: []
  )

  User.last(8).each do |user|
    next if user.virtual_clubs.present?
    VirtualClub.create!(
      name: Faker::Team.name,
      color1: Faker::Color.hex_color,
      color2: Faker::Color.hex_color,
      color3: Faker::Color.hex_color,
      user: user,
      league: league,
      crest_pattern: CrestPattern.all.sample
    )
    puts 'User email:' + user.email unless user.eql?(User.last)
  end

  VirtualClub.last(8).each do |virtual_club|
    league.draft_order.queue.push(virtual_club.id)
    league.draft_order.save!
  end

  puts 'Chairman email:' + User.last.email
end
