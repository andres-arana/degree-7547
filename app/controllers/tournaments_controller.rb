class TournamentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_tournament, only: [:edit, :update, :destroy, :ready]
  before_filter :check_tournament_ownership, only: [:edit, :update, :destroy, :ready]

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new tournament_params
    if @tournament.save
      current_user.add_role :organizer, @tournament
      redirect_to edit_tournament_path(@tournament), notice: "El torneo ha sido creado exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tournament.update_attributes tournament_params
      redirect_to dashboard_path, notice: "El torneo ha sido actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @tournament.destroy
    redirect_to dashboard_path, notice: "El torneo ha sido eliminado exitosamente."
  end

  def ready
    @tournament.start!
    redirect_to tournament_fixture_path(@tournament), notice: "El torneo ha comenzado."
  end

  private
  def load_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(:name)
  end
end
