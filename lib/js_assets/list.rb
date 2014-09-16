module JsAssets
  class List
    class << self
      attr_accessor :exclude, :allow
    end
    @exclude          = ['application.js']
    @allow            = ['*.html']
    @use_file_filter  = true

    def self.to_json
      fetch.to_json
    end

    def self.fetch
      return assets.each_file.reduce({}) do |res, filename|
        if (logical_path = get_logical_path(filename))
          if file_allowed?(logical_path, filename)
            res[logical_path] = asset_path(logical_path)
          end
        end
        res
      end
    end

  protected

    def self.file_allowed?(path, name)
      return false if matches_filter(@exclude, path, name)
      return false if !matches_filter(@allow, path, name)
      return true
    end

    def self.asset_path(path)
      ActionController::Base.helpers.asset_path(path)
    end

    # will return logical path for the asset
    def self.get_logical_path(file)
      filter = @use_file_filter ? config.assets.precompile : []
      assets.send(:logical_path_for_filename, file, filter)
    end

    def self.config
      ::Rails.application.config
    end

    def self.assets
      ::Rails.application.assets
    end

    # from 
    # https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/base.rb:418
    def self.matches_filter(filters, logical_path, filename)
      return true if filters.nil? || filters.empty?

      filters.any? do |filter|
        if filter.is_a?(Regexp)
          filter.match(logical_path)
        elsif filter.respond_to?(:call)
          if filter.arity == 1
            filter.call(logical_path)
          else
            filter.call(logical_path, filename.to_s)
          end
        else
          # puts filter
          File.fnmatch(filter.to_s, logical_path)
        end
      end
    end
  end
end
