module AdminUtilities

    def self.fix_author_credentials(option)

    string_count = 0
    hash_count = 0

    case option
      when 'inspect'
        DocumentRepository.all.each do |document|
          if document.author_credentials.class.name == 'Hash'
            hash_count +=1
          elsif document.author_credentials.class.name == 'String'
            string_count += 1
          else
            puts "Error: document #{document.title} (#{document.id}) has weird credential #{document.author_credentials.class.name}"
          end
        end
      when 'verify'
        DocumentRepository.all.each do |document|
          if document.author_credentials2.class.name == 'Hash'
            hash_count +=1
          elsif document.author_credentials2.class.name == 'String'
            string_count += 1
          else
            puts "Error: document #{document.title} (#{document.id}) has weird credential #{document.author_credentials.class.name}"
          end
        end
      when 'fix'
        DocumentRepository.all.each do |document|
          if document.author_credentials.class.name == 'Hash'
            hash_count +=1
            document.author_credentials2 = document.author_credentials
            DocumentRepository.update document
          elsif document.author_credentials.class.name == 'String'
            string_count += 1
            h = document.author_credentials.hash_value ':,'
            id = h["{\"id\""].gsub("\"", '')
            first_name = h["\"first_name\""].gsub("\"", '')
            last_name = h["\"last_name\""].gsub("\"", '')
            identifier = h["\"identifier\""].gsub("\"", '').sub("}", '')
            hash = {'id' => id, 'first_name' => first_name, 'last_name' => last_name, 'identifier' => identifier}
            puts hash.to_s
            document.author_credentials2 = hash
            DocumentRepository.update document
          else
            puts "Error: document #{document.title} (#{document.id}) has weird credential #{document.author_credentials.class.name}"
            hash = {'id' => '9', 'first_name' => 'James', 'last_name' => 'Carlson', 'identifier' => '80ea7a7125dc796ae42b'}
            document.author_credentials2 = hash
            DocumentRepository.update document
          end
        end

    end
    "hash: #{hash_count}, string: #{string_count}"


    end

  def self.fix_author_id(option)

    count = 0
    count_root = 0

    DocumentRepository.all.each do |doc|

      case option
        when 'inspect'
          if doc.author_id == nil
            count += 1
            if doc.is_root_document?
              puts "#{doc.id}\t #{doc.title}".red
            else
              count_root += 1
              puts "#{doc.id}\t #{doc.title}".cyan
            end
          end
        when 'fix'
          if doc.author_id == nil
            if doc.author_credentials2['id']
              doc.author_id =  doc.author_credentials2['id'].to_i
              DocumentRepository.update doc
            else
              count += 1
              puts "NO id in credentials: #{doc.id}\t #{doc.title}".red
            end
          end
      end

    end

    [count, count_root]
  end


    def self.process_orphan(document, option)
      result = 0
      if document.root_document_id != 0
        root_doc = DocumentRepository.find document.root_document_id
        if root_doc == nil
          puts "BAD: #{document.id}: #{document.title}".cyan
          result = 1
          if option == 'fix'
            DocumentRepository.delete document
          end
        else
          result = 0
        end
      end
      result
    end

  def self.process_orphans(option='')
    docs = DocumentRepository.all
    count = 0
    docs.each do |document|
      result =  self.process_orphan(document, option)
      count += result
    end
    count
  end


  def self.process_bozo(document, option)
    if document.title == nil or document.title == ''
      if option == 'fix'
        document.delete
      end
      return 1
    end
    return 0
  end


  def self.process_bozos(option='')
    docs = DocumentRepository.all
    count = 0
    docs.each do |document|
      result =  self.process_bozo(document, option)
      count += result
    end
    count
  end

  def self.set_user_attribute(key, value)
    puts "user.dict2[#{key}] => #{value}"
    count = 0
    UserRepository.all.each do |user|
      user.dict2[key] = value
      UserRepository.update user
      puts user.full_name
      count = count + 1
    end
    count
  end


  def self.fix_dates
    UserRepository.all.each do |user|
      if user.created_at == nil or user.updated_at == nil
        user.created_at = DateTime.now - 3
        user.updated_at = DateTime.now - 2
        UserRepository.update user
        puts "fixing #{user.full_name}".red
      end
    end
  end

  def self.generate_notebooks
    count = 0
    @content = "This is a place to practice writing. _Go for it!_\n"
    UserRepository.all.each do |user|
      count += 1
      sd = SetupDocument.new(author: user, title: "#{user.screen_name.capitalize}'s Notebook", content: @content)
      sd.make
      puts user
    end
    count
  end

  def self.change_author_id(from_id, to_id, option='test')
    count = 0
    DocumentRepository.all.each do |doc|
      if doc.author_id == from_id
        count = count + 1
        puts "#{doc.id}: #{doc.title}"
        if option == 'fix'
          doc.author_id = to_id
          DocumentRepository.update doc
        end
      end
    end
    count
  end



end
