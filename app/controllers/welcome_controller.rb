# frozen_string_literal: true

# Welcome controller
class WelcomeController < ApplicationController
  # index function
  def index
    render json: { message: 'API is working!!!' }
  end
end
