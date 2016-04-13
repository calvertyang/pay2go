module Pay2go
  # Generic Pay2Go exception class.
  class Pay2goError < StandardError; end
  class MissingOption < Pay2goError; end
  class MissingParameter < Pay2goError; end
  class InvalidMode < Pay2goError; end
  class UnsupportedType < Pay2goError; end
end
