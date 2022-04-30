require 'middleman-core'
require 'parallel'
require 'vips'
require 'uri'

class AutoOGP < ::Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
  end

  def after_build(builder)
    puts "auto OGP start"
    files = Dir.glob(File.join(app.config[:build_dir], "**", "*.html"))
    Parallel.map(files) do |file|
      doc = Nokogiri::HTML(File.read(file))
      if doc.at('body section.article')
        elem = doc.css('body section.article img').first
        next unless elem

        next if elem[:src].start_with?('http')
        img_path = File.join(app.config[:build_dir], elem[:src])
        next unless File.exist?(img_path)
        img = Vips::Image.new_from_file(File.join(app.config[:build_dir], elem[:src]))
        next if img.width < 200

        img_url = URI.join('https://blog.unasuke.com/', elem[:src]).to_s
        doc.at_xpath(
          './/meta[@property="og:title"]'
        ).add_next_sibling("<meta property='og:image' content='#{img_url}' >")

        File.open(file, 'w') do |f|
          puts "write #{file}"
          f.write doc.to_html
        end
      end
    end
    puts "auto OGP end"
  end
end

::Middleman::Extensions.register(:auto_ogp, AutoOGP)
