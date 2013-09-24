module JsAssets
  class List
    @exclude = ['application.js']
    @allow = ['.eof']
    def self.fetch
      project_assets ={}
      ::Rails.application.assets.each_logical_path(::Rails.application.config.assets.precompile) do |lp|
        puts lp
        next if matches_filter(@exclude, lp)
        next unless matches_filter(@allow, lp)
        project_assets[lp] = ::ApplicationController.helpers.asset_path(lp)
      end
      return project_assets
    end

  protected

    # from 
    # https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/base.rb:418
    def matches_filter(filters, logical_path, filename)
      return true if filters.empty?

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
          File.fnmatch(filter.to_s, logical_path)
        end
      end
    end
  end
end
