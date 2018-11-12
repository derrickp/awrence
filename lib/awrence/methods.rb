# frozen_string_literal: true

module Awrence
  module Methods

    # Recursively converts Rubyish snake_case hash keys to camelBack JSON-style
    # hash keys suitable for use with a JSON API.
    #
    def to_camelback_keys(acronyms = {}, value = self)
      case value
        when Array
          value.map { |v| to_camelback_keys(acronyms, v) }
        when Hash
          Hash[value.map { |k, v| [camelize_key(k, acronyms, false), to_camelback_keys(acronyms, v)] }]
        else
          value
      end
    end

    # Recursively converts Rubyish snake_case hash keys to CamelCase JSON-style
    # hash keys suitable for use with a JSON API.
    #
    def to_camel_keys(acronyms = {}, value = self)
      case value
        when Array
          value.map { |v| to_camel_keys(acronyms, v) }
        when Hash
          Hash[value.map { |k, v| [camelize_key(k, acronyms), to_camel_keys(acronyms, v)] }]
        else
          value
      end
    end

    private

    def camelize_key(k, acronyms, first_upper = true)
      if k.is_a? Symbol
        camelize(k.to_s, acronyms, first_upper).to_sym
      elsif k.is_a? String
        camelize(k, acronyms, first_upper)
      else
        k # Awrence can't camelize anything except strings and symbols
      end
    end

    def camelize(snake_word, acronyms, first_upper = true)
      if first_upper
        snake_word.to_s
          .gsub(/(?:^|_)([^_\s]+)/) { acronyms[$1] || $1.capitalize }
          .gsub(%r|/([^/]*)|) { "::" + (acronyms[$1] || $1.capitalize) }
      else
        parts = snake_word.split("_", 2)
        parts[0] << camelize(parts[1], acronyms) if parts.size > 1
        parts[0] || ""
      end
    end

  end
end
