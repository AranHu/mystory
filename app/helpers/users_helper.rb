module UsersHelper
  #  def site(user)
  #    site_url.sub(/\:\/\//, "://" + user.domain + ".")
  #  end
  #
  #  def site_url
  #    site_url.sub(/\:\/\//, "://" + session[:domain] + ".")
  #  end

  def whose_site(domain)
    site_url.sub(/\:\/\//, "://" + domain + ".")
  end

  def myself
    User.find(session[:id])
  end

  def blank_dot
    raw t('_dot')
  end

  def summary_no_comments(something, size)
    tmp = text_it(something.content[0, size])
    if something.is_a?(Memoir)
      link_url = memoirs_path
    else
      link_url = something
    end
    p = tmp + t('etc') + (link_to t('whole_article') , link_url)
    #    n = m.size
    #    if n > 1
    #      raw " (#{n}#{t('pic')})&nbsp;&nbsp;" + p
    #    else
    raw p
    #    end
  end

  def summary_no_comments_portal(something, size)
    tmp = text_it(something.content[0, size])
    if something.is_a?(Memoir)
      link_url = site(something.user) + memoirs_path
    else
      link_url = site(something.user) + something
    end
    p = tmp + t('etc') + (link_to t('whole_article') , link_url)
    raw p
  end

  def m_summary_no_comments_portal(something, size)
    tmp = text_it(something.content[0, size])
    if something.is_a?(Memoir)
      link_url = m(site(something.user) + memoirs_path)
    else
      link_url = m(site(something.user) + something)
    end
    p = tmp + t('etc') + (link_to t('whole_article') , link_url)
    raw p
  end

  def summary_blank(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      #TODO gsub may REPLACE <img> as <im and gsub twice is not effient.Use one time is the best.
      raw tmp[0, size] + t('chinese_etc')
    else
      raw tmp
    end
  end

  #  def summary_comment(something, size)
  #    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
  #    if something.is_a?(Note)
  #      count = something.notecomments.size
  #    elsif something.is_a?(Blog)
  #      count = something.blogcomments.size
  #    end
  #    comments = ""
  #    if count > 0
  #      comments = ' ' + t('comments', w: count)
  #    end
  #    if tmp.size > size + 30
  #      if count == 0
  #        comments = " >>"
  #      end
  #      raw tmp[0, size] + (link_to t('chinese_etc') + comments, something)
  #    else
  #      raw tmp + (link_to comments, something)
  #    end
  #  end

  

  def user_summary(something, size)
    tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")
    if tmp.size > size + 30
      raw tmp[0, size] + (link_to t('chinese_etc') + ' >>', site(something.user))
    else
      raw tmp
    end
  end

  def pic_name(something)
    a = /<img.*? src="\/uploads\/image\/.*"/.match(something.content)
    unless a.nil?
      a[0].sub(/.*<img.*? src="\/uploads\/image\/(.*?)".*/,'\1').sub(/\//, '/thumb_')
    end
  end

  #  def thumb_here(something)
  #    p_name = pic_name(something)
  #    unless p_name.nil?
  #      if something.is_a?(Note)
  #        href = note_path(something)
  #      elsif something.is_a?(Blog)
  #        href = blog_path(something)
  #      end
  #      content_tag(:a, image_tag("/uploads/thumb/" + p_name), href: href)
  #    end
  #  end
  
  def summary_comment(something, size)
    tmp = summary_comment_c(something, size)
    #    n = m.size
    #    if n > 1
    #      pic_count = "(#{n}#{t('pic')})&nbsp;&nbsp;"
    #      raw pic_count + summary_common(something, size, tmp)
    #    else
    summary_common(something, size, tmp)
    #    end
  end

  def summary_comment_portal(something, size)
    tmp = summary_comment_c(something, size)
#    n = m.size
#    if n > 1
#      raw "(#{n}#{t('pic')})&nbsp;&nbsp;" + summary_common_portal(something, size, tmp)
#    else
    summary_common_portal(something, size, tmp)
#    end
  end

  def m_summary_comment_portal(something, size)
    tmp = summary_comment_c(something, size)
#    n = m.size
#    if n > 1
#      raw "(#{n}#{t('pic')})&nbsp;&nbsp;" + summary_common_portal(something, size, tmp)
#    else
    m_summary_common_portal(something, size, tmp)
#    end
  end

  def summary_comment_c(something, size)
    tmp = text_it(something.content[0, size])
    tmp = text_it(something.content)[0, size] if tmp.match(/##/m)
    tmp = auto_emotion tmp
    tmp
  end

  def summary_common(something, size, tmp)
#    if something.is_a?(Note)
#      count = something.notecomments.count
#    elsif something.is_a?(Blog)
#      count = something.blogcomments.count
#    end
#    comments = ""
#    if count > 0
#      comments = ' ' + t('comments', w: count)
#    end
    if something.content.size > size
      raw tmp + t('etc') + (link_to t('whole_article'), something, target: '_blank')
#      raw tmp + t('etc') + (link_to t('whole_article') + comments, something, target: '_blank')
    else
#      raw tmp + (link_to comments, something, target: '_blank')
      raw tmp
    end
  end

  def summary_common_portal(something, size, tmp)
    if something.is_a?(Note)
      path = note_path(something)
#      count = something.notecomments.count
    elsif something.is_a?(Blog)
      path = blog_path(something)
#      count = something.blogcomments.count
    end
#    comments = ""
#    if count > 0
#      comments = ' ' + t('comments', w: count)
#    end
    if something.content.size > size
#      raw tmp + t('etc') + (link_to t('whole_article') + comments, site(something.user) + path, target: '_blank')
      raw tmp + t('etc') + (link_to t('whole_article'), site(something.user) + path, target: '_blank')
    else
#      raw tmp + (link_to comments, site(something.user) + path, target: '_blank')
      raw tmp
    end
  end

  def m_summary_common_portal(something, size, tmp)
    if something.is_a?(Note)
      path = note_path(something)
    elsif something.is_a?(Blog)
      path = blog_path(something)
    end
    comments = ""
    count = something.comments_count
    if count > 0
      comments = ' ' + t('comments', w: count)
    end
    if something.content.size > size
      raw tmp + t('etc') + (link_to t('whole_article') + comments, m(site(something.user) + path))
    else
      raw tmp + (link_to comments, m(site(something.user) + path))
    end
  end

  def text_it_pure(something)
    s = ignore_draft(something.gsub(/\r\n/,' '))
    s = ignore_img(s)
    s = ignore_image_tag(s)
    raw ignore_style_tag(s)
  end
    
  def text_it(something)
    s = auto_draft(something.gsub(/\r\n/,'&nbsp;'))
    s = auto_link(s)
    s = ignore_img(s)
    s = ignore_image_tag(s)
    raw ignore_style_tag(s)
  end
  
  def summary_comment_style(something, size)
    _style = style_it(something.content[0, size])
    summary_common(something, size, _style)
  end

  def style_it(something)
    s = auto_draft(something)
    s = auto_link(s)
    s = auto_img(s)
    s = auto_emotion(s)
    raw auto_style(auto_photo(s))
  end  
  
  def photos_count(mystr)
    m = mystr.scan(/(\+photo(\d{2,})\+)/m)
    m.size
  end

  def scan_photo(mystr)
    a_photo = nil
    m = mystr.scan(/(\+photo(\d{2,})\+)/m)
    m.each do |e|
      photo = Photo.find_by_id(e[1])
      unless photo.nil?
        a_photo = photo
        break
      end
    end
    a_photo
  end

  def scan_photos(mystr, n)
    photos = []
    k = 0
    m = mystr.scan(/(\+photo(\d{2,})\+)/m)
    m.each do |e|
      photo = Photo.find_by_id(e[1])
      unless photo.nil?
        k = k+1
        photos << photo
        if k == n
          break
        end
      end
    end
    photos
  end

  def thumb_here(something)
    photo = scan_photo(something.content)
    unless photo.nil?
      if something.is_a?(Note)
        #        href = note_path(something)
        id = "note_photo_#{photo.id}"
      elsif something.is_a?(Blog)
        #        href = blog_path(something)
        id = "blog_photo_#{photo.id}"
      end
      source_from = ""
      if !@user.nil? && photo.album.user_id!=@user.id
        source_from = raw "<span class='pl'><br/>#{t('source_from')}<a href='#{site(photo.album.user)}' target='_blank'>#{photo.album.user.name}</a>[<a href='#{site(photo.album.user)+ album_path(photo.album)}' target='_blank'>#{photo.album.name}</a>]</span>"
      end
      content_tag(:a, image_tag(photo.avatar.thumb.url), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.thumb.url}')", title: "#{t('click_enlarge')}") + source_from
    end
  end

  def thumbs_here(something, n)
    show = ""
    flag = false
    photos = scan_photos(something.content, n)
    photos.each do |photo|
      if @user.nil? or photo.album.user_id!=@user.id
        flag = true
        break
      end
    end

    if flag
      tab = "<table cellpadding='4'><tr style='vertical-align: middle;'>"
      photos.each do |photo|
        id = thumb_id(something, photo)
        source_from = ""
        if @user.nil? or photo.album.user_id!=@user.id
          source_from = raw "<br/><span class='pl'>#{t('source_from')}<a href='#{site(photo.album.user)}' target='_blank'>#{photo.album.user.name}</a>[<a href='#{site(photo.album.user)+ album_path(photo.album)}' target='_blank'>#{photo.album.name}</a>]</span>"
        end
        show += "<td>" + content_tag(:a, image_tag(photo.avatar.thumb.url), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.thumb.url}')", title: "#{t('click_enlarge')}") + source_from + "</td>"
      end
      raw tab + show + "</tr></table>"
    else
      photos.each do |photo|
        #TODO click show from which album!
        id = thumb_id(something, photo)
        p_ = content_tag(:a, image_tag(photo.avatar.thumb.url), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.thumb.url}')", title: "#{t('click_enlarge')}")
        if show == ""
          show = p_
        else
          show += raw("&nbsp;&nbsp;") + p_
        end
      end
      if photos.size > 0
        raw("<br/>") + show + raw("<br/>")
      else
        raw("<br/>")
      end
    end
  end

  def m_thumbs_here(something, n)
    show = ""
    flag = false
    photos = scan_photos(something.content, n)
    photos.each do |photo|
      if @user.nil? or photo.album.user_id!=@user.id
        flag = true
        break
      end
    end

    if flag
      tab = "<table cellpadding='4'><tr style='vertical-align: middle;'>"
      photos.each do |photo|
        id = thumb_id(something, photo)
        source_from = ""
        if @user.nil? or photo.album.user_id!=@user.id
          source_from = raw "<br/><span class='pl'>#{t('source_from')}<a href='#{site(photo.album.user)}'>#{photo.album.user.name}</a>[<a href='#{site(photo.album.user)+ album_path(photo.album)}'>#{photo.album.name}</a>]</span>"
        end
        show += "<td>" + content_tag(:a, image_tag(photo.avatar.mthumb.url), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.mthumb.url}')", title: "#{t('click_enlarge')}") + source_from + "</td>"
      end
      raw tab + show + "</tr></table>"
    else
      photos.each do |photo|
        #TODO click show from which album!
        id = thumb_id(something, photo)
        p_ = content_tag(:a, image_tag(photo.avatar.mthumb.url), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.mthumb.url}')", title: "#{t('click_enlarge')}")
        if show == ""
          show = p_
        else
          show += raw("&nbsp;&nbsp;") + p_
        end
      end
      if photos.size > 0
        raw("<br/>") + show        
      end
    end
  end

  def show_role user
    roles = user.roles
    if roles.blank?
      t'blog_master'
    else
      user.roles.order('created_at DESC').map{|t| t.name}.join(", ")
    end
  end

  def show_weibo
    link_name = raw "#{image_tag('/images/weibo16_16.png', width: 16, height: 16)}#{@user.name}"
    link_to link_name, "http://weibo.com/u/#{@user.weiboid}", target: "_blank", title: t('show_weibo_title')
  end

  def user_pic user
    content_tag(:a, image_tag(user.avatar.thumb.url, width: USER_THUMB_SIZE, height: USER_THUMB_SIZE), href: site(user), title: "#{user.city} #{user.jobs} #{user.maxim} #{user.memo}", target: '_blank')
  end

  private
  def thumb_id(something, photo)
    if something.is_a?(Note)
      id = "note_photo_#{photo.id}"
    elsif something.is_a?(Blog)
      id = "blog_photo_#{photo.id}"
    elsif something.is_a?(Memoir)
      id = "memoir_photo_#{photo.id}"
    end
    id
  end

  #  def thumbs_here(something, n)
  #    show = ""
  #    photos = scan_photos(something.content, n)
  #    photos.each do |photo|
  #      if something.is_a?(Note)
  #        id = "note_photo_#{photo.id}"
  #      elsif something.is_a?(Blog)
  #        id = "blog_photo_#{photo.id}"
  #      end
  #      source_from = ""
  #      if photo.album.user_id!=@user.id
  #        source_from = raw "<span class='pl'>#{t('source_from')}<a href='#{site(photo.album.user)}'>#{photo.album.user.name}</a>[<a href='#{site(photo.album.user)+ album_path(photo.album)}'>#{photo.album.name}</a>]</span>"
  #      end
  #      p_ = content_tag(:a, image_tag(photo.avatar.thumb.url, align: 'top'), href: 'javascript:;', id: id, onclick: "switchPhoto('#{id}', '#{photo.avatar.url}', '#{photo.avatar.thumb.url}')", title: "#{t('click_enlarge')}") + source_from
  #      if show == ""
  #        show = p_
  #      else
  #        show += raw("&nbsp;&nbsp;") + p_
  #      end
  #    end
  #    show
  #  end

end
