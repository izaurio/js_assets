module JsAssets
  class List
    class << self
      attr_accessor :exclude, :allow
    end
    @exclude = ['application.js']
    @allow = ['*.html']
    def self.fetch
      project_assets = {}
      env = Sprockets::Railtie.build_environment(::Rails.application)
      env.logical_paths do |logical_path, filename|
        next if matches_filter(@exclude, logical_path, filename)
        next unless matches_filter(@allow, logical_path, filename)

        assets_root = ::Rails.application.config.action_controller.asset_host.present? ? ::Rails.application.config.action_controller.asset_host : '/'
        if env.file_digest(filename)
          project_assets[logical_path] = File.join(assets_root, ::Rails.application.config.assets.prefix,
            env[logical_path].digest_path)
        else
          project_assets[logical_path] = File.join(assets_root, ::Rails.application.config.assets.prefix,
            logical_path)
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
