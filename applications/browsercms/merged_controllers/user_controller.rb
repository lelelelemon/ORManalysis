  class UserController < ApplicationController
    # Return information about the current user as json. Can be used by cached html pages do create interactive elements.
    def show
      render json: UserPresenter.new(current_user)
    end
  end