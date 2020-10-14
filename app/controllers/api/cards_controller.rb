class Api::CardsController < ApplicationController
  def show
    begin
      @card = Card.find(params[:id])
      @board_id = @card.list.board_id
    rescue ActiveRecord::RecordNotFound
      @card = nil
      @error = "Invalid card data provided"
      render 'shared/error', status: :unprocessable_entity
    end
  end

  def create
    @list = List.find_by_id(params[:list_id])

    if !@list
      @error = "List not found"
      render 'shared/error', status: :not_found
    else
      @card = @list.cards.build(card_params)

      if @card.save
        render :create, status: :created
      else
        @error = @card.errors.full_messages.join(', ')
        render 'shared/error', status: :unprocessable_entity
      end
    end
  rescue ActionController::ParameterMissing
    @error = "Invalid card data provided"
    render 'shared/error', status: :unprocessable_entity
  end

  def update
    @card = Card.find_by_id(params[:id])

    if !@card
      @error = "Card not found"
      render 'shared/error', status: :not_found
    else
      if @card.update(card_params)
        render :update, status: :ok
      else
        @error = @card.errors.full_messages.join(', ')
        render 'shared/error', status: :unprocessable_entity
      end
    end
  end

  def destroy
    @card = Card.find_by_id(params[:id])

    if !@card
      @error = "Card not found"
      render 'shared/error', status: :not_found
    else
      if @card.destroy
        render :destroy, status: :ok
      else
        @error = @card.errors.full_messages.join(', ')
        render 'shared/error', status: :unprocessable_entity
      end
    end
  end

  private

  def card_params
    params.require(:card).permit(:title, :list_id, :description, :archived, :due_date, :completed, :labels => [])
  end
end