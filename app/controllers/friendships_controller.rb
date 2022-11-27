class FriendshipsController < ApplicationController
  include ApplicationHelper

  def create
    return if current_user.id == params[:user_id] # Disallow the ability to send yourself a friend request
    # Disallow the ability to send friend request more than once to same person
    return if friend_request_sent?(User.find(params[:user_id]))
    # Disallow the ability to send friend request to someone who already sent you one
    return if friend_request_received?(User.find(params[:user_id]))

    @user = User.find(params[:user_id])
    # Since this friendships controller create method is a nested route under the users resource 
    # the route created provides the parameter user_id for use within this function
    # current_user.friend_sent.build() creates a new record in the Friendship table 
    # supplying the value of sent_by_id as that of the current user using the friend_sent association 
    # between the User model and Friendship model
    @friendship = current_user.friend_sent.build(sent_to_id: params[:user_id])
    if @friendship.save
      flash[:success] = 'Friend Request Sent!'
      @notification = new_notification(@user, @current_user.id, 'friendRequest')
      @notification.save
    else
      flash[:danger] = 'Friend Request Failed!'
    end
    redirect_back(fallback_location: root_path)
  end

  # The accept_friend method updates the friendship record in the Friendship table 
  # setting the status of the record to true which we used to signify that the users are friends
  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.status = true
    if @friendship.save
      flash[:success] = 'Friend Request Accepted!'
      # Once the original record is updated and saved a duplicate record is created. 
      # This duplicate record will have the inverse value for sent_by_id and sent_to_id. 
      # This makes it easier to perform friending tasks and database checks to determine friends lists.
      # Upon accepting the friend request another friend request is made automatically. 
      @friendship2 = current_user.friend_sent.build(sent_to_id: params[:user_id], status: true)
      @friendship2.save
    else
      flash[:danger] = 'Friend Request could not be accepted!'
    end
    redirect_back(fallback_location: root_path)
  end

  # If a user declines a friend request the record is deleted out of the Friendship table
  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship # return if no record is found

    @friendship.destroy
    flash[:success] = 'Friend Request Declined!'
    redirect_back(fallback_location: root_path)
  end
end
