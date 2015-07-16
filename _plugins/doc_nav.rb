# Document Navigation Plugin
# by Emma Saboureau
# github @emsab
#
# 
# USAGE
# default: {% doc_nav path/to/directory %}
# 
# OPTIONS
# --title="Foo Title"

module Jekyll
  class DocNav < Liquid::Tag
    @path = nil
    @title = nil

    def initialize(tag_name, text, tokens)
      super

      @path = text.split(/\s+/)[0].strip # splits the string (params) when whitespace and takes the 1st element
      @title = 'Default Title'

      if text =~ /--title="(.+)"/i
        @title = text.match(/--title="(.+)"/i)[1]
      end
    end

    def render(context)
      a_current_dir = @path.split("/").last
      a_id = "#{a_current_dir}"
      a_id = a_id.gsub("/", "-")

      source = "<li>"
      source += "<a href='##{a_id}'>#{@title}</a>"
      source += "<ul class='nav nav-stacked #{@container_class}'>\n"
      sub_source = ""

      path = File.join(context.registers[:site].config['source'], @path, "*")

      Dir.glob(path).each do |entry|
        filename = Pathname.new(entry).basename
        current_dir = @path.split("/").last
        id = "##{current_dir}-#{filename}"
        id = id.gsub("/", "-")

        # Get all subdirectories
        if File.directory?(entry)
          source += "<li><a href='#{id}'>#{filename}</a></li>"
        end
      end

      source += sub_source
      source += "</ul></li>"
      source
    end

  end
end

Liquid::Template.register_tag('doc_nav', Jekyll::DocNav)
