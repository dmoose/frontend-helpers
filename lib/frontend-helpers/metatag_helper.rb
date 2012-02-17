module FrontendHelpers
  module MetatagHelper

    def meta_tags
      options = opts
      buffer = ''
      settings
      @settings[:site].each do |s, k|
        meta(buffer, s, options)
      end
      buffer
    end

  private ##########

    def settings
      @settings ||= YAML.load_file(File.join(Rails.root, 'config', 'settings.yml')) rescue {}
    end

    def setting(setting)
      ENV["SITE_#{setting.to_s.upcase}"] || @settings[:site][setting]
    end

    def meta(buffer, name, options)
      if !name.blank? && !setting(name).blank? || options.include?(name) && options[name]
        content = options[name] ? options[name] : setting(name)
        content.gsub!(/['"]/,'') # remove quotes so they don't screw up html
        buffer << "<meta content='#{content}' name='#{name.to_s}' />"
      end
    end

    def opts
      {
        :title => @meta_title,
        :keywords => @meta_keywords,
        :description => @meta_description,
        :author => @meta_author,
        :email => @meta_email,
        :copyright => @meta_copyright,
        :generator => @meta_generator,
        :rating => @meta_rating,
        :language => @meta_language,
        :distribution => @meta_distribution,
        :robots => @robots,
        :"fb:app_id" => @meta_fb_app_id,
        :"fb:admins" => @meta_fb_admins,
        :"og:title" => @meta_og_title,
        :"og:description" => @meta_og_description,
        :"og:url" => request.url.gsub(/([^:])\/\//, '\1/'), # remove double slash since bug in rails with engines mounted at root
        :"og:site_name" => @meta_og_site_name,
        :"og:type" => @meta_og_type,  # website, blog, article
        :"og:image" => @meta_og_image,
        :"og:locality" => @meta_og_locality,
        :"og:region" => @meta_og_region,
        :"og:country_name" => @meta_og_country_name,
        :"og:phone_number" => @meta_og_phone_number
      }
    end
  end
end

ActionView::Base.send :include, FrontendHelpers::MetatagHelper
