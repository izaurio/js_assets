module JsAssets
  class List
    class << self
      attr_accessor :exclude, :allow
    end
    @exclude = ['application.js']
    @allow = ['*.html']
    def self.fetch
      project_assets = {}
      assets_filters = ::Rails.application.config.assets.precompile
      ::Rails.application.assets.each_file do |filename|
        if logical_path = ::Rails.application.assets.send(:logical_path_for_filename, filename, assets_filters)
          next if matches_filter(@exclude, logical_path, filename)
          next unless matches_filter(@allow, logical_path, filename)
          if ::Rails.env.development? || ::Rails.env.test?
            project_assets[logical_path] = '/assets/' + logical_path
          elsif ::Rails.env.production?
            project_assets[logical_path] = '/assets/' + ::Rails.application.assets[logical_path].digest_path
          end
        end
      end
      return project_assets
    end

  protected
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
