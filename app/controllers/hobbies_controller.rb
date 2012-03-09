class HobbiesController < ApplicationController

  layout 'memoir'
  
  def index
    @hobbies = @user.hobbies
    @hobby = Hobby.new
  end

  def create
    f_hobby = Hobby.find_by_name(params[:hobby][:name])
    f_hobby = Hobby.create(params[:hobby]) if f_hobby.nil?
    rh = f_hobby.rhobbies.build
    rh.user_id = session[:id]
    rh.save
    flash[:notice] = t('new_succ')
    redirect_to hobbies_path
  end

  def destroy
    if Rhobby.where("hobby_id = ?", params[:id]).size > 1
      Rhobby.delete_all ["user_id = ? AND hobby_id = ?", session[:id], params[:id]]
    else
      @hobby = Hobby.find(params[:id])
      @hobby.destroy
    end
    redirect_to hobbies_path, notice: t('delete_succ')
  end

end
