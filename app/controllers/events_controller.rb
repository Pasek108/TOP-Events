class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy join leave ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :authorize_event_creator, only: %i[ edit destroy ]

  def index
    if user_signed_in?
      # @events = Event.all
      redirect_to upcoming_events_path, status: :see_other
    else
      redirect_to homepage_path, status: :see_other
    end
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.organizers << current_user

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      flash.now[:error] = "Something went wrong."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      flash.now[:error] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!

    redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
  end

  def join
    unless helpers.joined_event?(@event)
      @event.attendees << current_user
      flash[:success] = "You have successfully joined the event."
    else
      flash[:notice] = "You have already joined the event."
    end

    redirect_to request.referrer
  end

  def leave
    if helpers.joined_event?(@event)
      @event.attendees.destroy(current_user)
      flash[:success] = "You have successfully left the event."
    else
      flash[:notice] = "You have already left the event."
    end

    redirect_to request.referrer
  end

  def past
    @events = Event.past
  end

  def ongoing
    @events = Event.ongoing
  end

  def upcoming
    @events = Event.upcoming
  end

  private

  def set_event
    @event = Event.find(params.expect(:id))
  end

  def event_params
    params.expect(event: %i[ title description date ending_date latitude longitude location_name ])
  end

  def authorize_event_creator
    unless @event.organizers.include?(current_user)
      flash[:error] = "Something went wrong"
      redirect_to events_path
    end
  end
end
