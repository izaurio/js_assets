module JsAssets
  class List
    class << self
      attr_accessor :exclude, :allow, :use_file_filter
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
      !matches_filter(@exclude, path, name) && matches_filter(@allow, path, name)
    end

    def self.asset_path(path)
      if digest?
        file_path = ::Rails.application.assets[path].digest_path
      else
        file_path = path
      end
      return File.join('/', config.assets.prefix, file_path)
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
    
    def self.digest?
      config.assets.digest
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
