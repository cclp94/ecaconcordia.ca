# Document List Plugin
# by Emma Saboureau
# github @emsab
#
# 
# USAGE
# default: {% doc_list path/to/directory %}
# 
# OPTIONS
# --title="Foo Title"

module Jekyll
  class DocList < Liquid::Tag
    @path = nil
    @title = nil

    def initialize(tag_name, text, tokens)
      super

      @path = text.split(/\s+/)[0].strip
      @title = 'Default Title'

      if text =~ /--title="(.+)"/i
        @title = text.match(/--title="(.+)"/i)[1]
      end
    end

    def render(context)
      a_current_dir = @path.split("/").last
      a_id = "#{a_current_dir}"
      a_id = a_id.gsub("/", "-")

      source = "<section class='group' id='#{a_id}'>"
      source += "<h2>#{@title}</h2>"
      source += "<ul class='#{@container_class}'>\n" 
      source += "#{@container_tag}"
      sub_source = ""

      path = File.join(context.registers[:site].config['source'], @path, "*")

      Dir.glob(path).each do |entry|
        filename = Pathname.new(entry).basename
        url = File.join('/', @path, filename)

        current_dir = @path.split("/").last
        id = "#{current_dir}-#{filename}"
        id = id.gsub("/", "-")
        
        # Look through Subdirectories
        if File.directory?(entry)
          sub_source += "<div class='subgroup' id='#{id}'>"
          sub_source += "<h4>#{filename}</h4>"
          sub_source += "<ul>"
          sub_path = File.join(entry, "*")

          Dir.glob(sub_path).each do |sub_entry|
            sub_filename = Pathname.new(sub_entry).basename
            sub_url = File.join('/', @path, filename, sub_filename)
            sub_source += "<li><a href='#{sub_url}'>#{sub_filename}</a></li>"
          end

          sub_source += "</ul>"
          sub_source += "</div>"
        # Endif
          
        # Else
        else
          source += "<li><a href='#{url}'>#{filename}</a></li>"
        end
        # Endelse

      end

      source += sub_source
      source += "</ul></section>"
      source
    end

  end
end

Liquid::Template.register_tag('doc_list', Jekyll::DocList)
