require "jammit"
require "middleman-core"

module Middleman
  module Jammit

    class << self
      include Thor::Actions
      def registered(app)
        app.send :include, InstanceMethods

        app.after_configuration do
          full_build_dir = File.join(root, build_dir)

          FileUtils.mkdir_p File.join(full_build_dir, js_dir)
          FileUtils.mkdir_p File.join(full_build_dir, css_dir)

          jammit_config_file = File.join(root, 'config', 'assets.yml')
          raise ConfigurationNotFound, "could not find \"#{jammit_config_file}\" " unless File.exists?(jammit_config_file)
          jammit_conf = YAML.load(ERB.new(File.read(jammit_config_file)).result)

          touch_asset_files jammit_conf['javascripts']
          touch_asset_files jammit_conf['stylesheets']

          ::Jammit.load_configuration(jammit_config_file)
        end

        app.after_build "jammit" do |build|
          full_package_path = File.join(File.join(root, build_dir), ::Jammit.package_path)
          ::Jammit.packager.precache_all(full_package_path, root)
          build.say_status "Jammit", "build/assets"
        end

        app.helpers Helpers

      end
      alias :included :registered

    end

    module InstanceMethods
      def touch_asset_files(asset_files)
        if asset_files.present?
          asset_files.each do |name, files|
            files.each do |f|
              next if f["*"].present?
              FileUtils.touch File.join(root, f)
            end
          end
        end
      end
    end

    module Helpers

      def include_javascripts(*packages)
        generate_asset_tags(packages, :js)
      end

      def include_stylesheets(*packages)
        generate_asset_tags(packages, :css)
      end

      protected
        def generate_asset_tags(packages, type)
          packages.map do |pack|
            if ENV['MM_ENV'] == "build"
              url = asset_url(::Jammit.asset_url(pack, type.to_sym))
              generate_tag(type, url)
            else
              ::Jammit.packager.individual_urls(pack.to_sym, type.to_sym).map do |file|
                url = file.gsub(%r(^.*build/), '/')
                generate_tag(type, url)
              end
            end
          end.join("\n")
        end

        def generate_tag(type, url)
          self.method("#{type.to_s}_tag").call(url)
        end

        def js_tag(url)
          javascript_include_tag url
        end

        def css_tag(url)
          stylesheet_link_tag url
        end

    end

  end
end
::Middleman::Extensions.register(:jammit, Middleman::Jammit)
