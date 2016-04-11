class SetupDocument

  include Noteshare::Core::Document

  def initialize(hash)
    @author = hash[:author]
    @title = hash[:title]
    @content = hash[:content]
  end


  def make

    # set up document
    @document = NSDocument.create(title: @title, author_credentials: @author.credentials)
    @document.content = "= #{@title}\n\n\n"
    # @document.content << "This document was created on #{good_date(DateTime.now)}\n"
    @document.author = @author.full_name

    #Fixme: the following is to be deleted when author_id is retired
    @document.author_id = @author.credentials[:id].to_i

    format_hash = {"format"=>"adoc-latex"}
    @document.render_options = format_hash
    make_first_section
    update_user_dict
    @document.compiled_dirty = false
    update_user_node
    DocumentRepository.update @document
    @document.acl_set_permissions!('rw', 'r', '-')
    cm = ContentManager.new(@document)
    cm.update_content
    @document.id
  end

  def make_first_section
    @first_section = NSDocument.create(title: 'First section', content: @content, author_credentials: @author.credentials)
    # cm = ContentManager.new(@first_section)
    # cm.update_content
    DocumentManager.new(@document).append(@first_section)
  end

  def update_user_dict
    @author.dict2['root_documents_created'] = @author.dict2['root_documents_created'].to_i + 1
    UserRepository.update @author
  end

  def update_user_node
    user_node = @author.node
    if user_node
      user_node.publish_document(id: @document.id, type: 'author')
      NSNodeRepository.update user_node
    end
  end

  def good_date(date_time)
    week_day = { 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday', 7 => 'Sunday' }
    if date_time
      hour = date_time.hour
      wday = date_time.wday
      if hour < 5
        wday = wday - 1
        if wday < 1
          wday = 7
        end
      end
      hour = hour - 5
      hour = hour + 24 if hour < 0
      minutes = date_time.minute.to_s
      if minutes.length == 1
        minutes = "0#{minutes}"
      end
      "#{week_day[wday]}, #{date_time.month}/#{date_time.day}/#{date_time.year}"
    else
      '-'
    end

  end



end