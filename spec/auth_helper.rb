# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

def login_user
  user = FactoryBot.create(
    :user,
    level: UserLevel::ONE,
    program: Program.all.sample,
    entities: Entity.all.sample(rand(0..Entity.count))
  )
  # user.confirm # or set a confirmed_at inside the factory. Only      necessary if you are using the "confirmable" module
  # Log in with Devise
  sign_in user
end
