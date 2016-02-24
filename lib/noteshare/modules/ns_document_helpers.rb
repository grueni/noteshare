
module NSDocumentHelpers

  # These are methods that need have an
  # NSDocument as receiver but are not
  # of central functionality

  # Used only by method 'propagate' in conroler
  # Editor/UpdateOptions
  def set_format_of_render_option(value)
    self.render_options['format'] = value
    DocumentRepository.update self
  end



end