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


end