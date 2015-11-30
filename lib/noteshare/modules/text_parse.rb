module TextParse

  # Usage for public interface (grab)

  # text = "121foo212"
  # TextParse.grab text: text, regex: /121(.*)212/
  # => foo

  # text = "yuk:foobar."
  # TextParse.grab text: text, begin: 'yuk:', end: '.'
  # => foobar

  # text = "<p>Hello there!</p>"
  # textParse.grab text: text, begin: '\\<p\\>', end: '\\</p\\>'
  # => Hello there!

  # text = "<p>Hello there!</p>"
  # TextParse.grab text: text, html: 'p'
  # => Hello there!

  # text = "[env.blah]\n--\nfoobar\n--\n"
  # TextParse.grab text: text, ad_prefix: 'env', ad_suffix: 'blah'
  # tm =TextParse.grab text: c.course_attributes, ad_prefix: 'doc', ad_suffix: 'texmacros'
  # => foobar

  def grab(hash)
    pt = ParseTool.new
    text = hash[:text]
    if hash[:ad_prefix]
      pt.get_ad_element(text, hash[:ad_prefix], hash[:ad_suffix])
    elsif hash[:begin]
      pt.get_element(text, hash[:begin], hash[:end])
    elsif hash[:regex]
      pt.extract(text, hash[:regex])
    elsif hash[:html]
      pt.get_html_element(text, hash[:html])
    else
      text
    end
  end

  # Private:
  class ParseTool

    def extract(text, regex)
      match = regex.match text
      match ? match[1] : ''
    end

    def get_element(text, begin_tag, end_tag)
      re = Regexp.new "#{begin_tag}(.*)#{end_tag}"
      match = re.match text
      match ? match[1] : ''
    end

    def get_html_element(text, tag)
      re = Regexp.new "\\<#{tag}\\>(.*?)\\</#{tag}\\>"
      match = re.match text
      match ? match[1] : ''
    end

    def get_ad_element(text, tag_prefix, tag_suffix=nil)
      get_ad_element1(text, tag_prefix, tag_suffix)  ||  get_ad_element2(text, tag_prefix, tag_suffix)
    end

    def get_ad_element1(text, tag_prefix, tag_suffix)

      # if Rails.env =='development' or Rails.env =='test'
      end_string = "\r\n--\r\n(.*?)\r\n--\r\n" # ENV[END_STRING]
     #  if Rails.env =='test'
     #   end_string = "\n--\n(.*?)\n--\n"
     # else
     #    end_string = "\r\n--\r\n(.*?)\r\n--\r\n"


      if tag_suffix
        regex_string = "\\[#{tag_prefix}\\.#{tag_suffix}\\]#{end_string}"
      else
        regex_string = "\\[#{tag_prefix}\\]#{end_string}"
      end

      re = Regexp.new regex_string, Regexp::MULTILINE
      match = re.match text
      match ? match[1] : nil
    end


    def get_ad_element2(text, tag_prefix, tag_suffix)

      # if Rails.env =='development' or Rails.env =='test'
      # if Rails.env =='test'
      #   end_string = "\n(.*?)\n\n"
      # else
        end_string = "\r\n(.*?)\r\n\r\n"
      # end

      if tag_suffix
        regex_string = "\\[#{tag_prefix}\\.#{tag_suffix}\\]#{end_string}"
      else
        regex_string = "\\[#{tag_prefix}\\]#{end_string}"
      end

      re = Regexp.new regex_string, Regexp::MULTILINE
      match = re.match text
      match ? match[1] : nil
    end

  end

end

