class PhotocommentsController < ApplicationController
  include Recommend, Comment
  
  def create
    @photo = Photo.find(params[:photo_id])
    comments = @photo.photocomments
    if params[:reply_user_id].to_s != '' and @photo.album.user_id == session[:id]
      comment = comments.find_by_user_id(params[:reply_user_id])
      body = comment.body + 'repLyFromM'+ Time.now.to_i.to_s + ' ' + params[:photocomment][:body]
      comment.update_attribute('body', body)
      flash[:notice] = t'reply_succ'
    else
      if comments.collect{|c| c.user_id}.include?(session[:id])
        comment = comments.find_by_user_id(session[:id])
        body = comment.body + 'ReplyFRomU' + Time.now.to_i.to_s + ' '
        if params[:reply_user_id] != ''
          body = body + "repU#{params[:reply_user_id]} " + params[:photocomment][:body]
          flash[:notice] = t'reply_succ'
        else
          body += params[:photocomment][:body]
          flash[:notice] = t'add_comment_succ'
        end
        comment.update_attribute('body', body)
      else
        @photocomment = comments.new(params[:photocomment])
        @photocomment.user_id = session[:id]
        if params[:reply_user_id] != ''
          @photocomment.body = "repU#{params[:reply_user_id]} " + @photocomment.body
        end
        @photocomment.save
        flash[:notice] = t'comment_succ'
      end
    end
    if params[:comment_and_recommend]
      _r = Rphoto.find_by_user_id_and_photo_id(session[:id], @photo.id)
      save_rphoto(@photo) if _r.nil?
      flash[:notice] = flash[:notice] + t('photo_recommended')
    end
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.photocomments.find(params[:id])
    @comment.destroy
    flash[:notice] = t('delete_succ1', w: t('comment'))
    redirect_to album_photo_path(@photo.album, @photo) + "#notice"
  end

  def like
    comment = Photocomment.find(params[:id])
    like_it comment
    render json: comment.as_json
  end
  
end
