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
# --reverse (default=false)

module Jekyll
  class DocNav < Liquid::Tag
    @path = nil
    @reverse = nil
    @title = nil

    def initialize(tag_name, text, tokens)
      super

      @path = text.split(/\s+/)[0].strip

      @reverse = false
      if text =~ /--reverse/i
        @reverse = true
      end

      @title = verboseCurrentWorkingDirectory()
      if text =~ /--title="(.+)"/i
        @title = text.match(/--title="(.+)"/i)[1]
      end
    end

    def render(context)
      source = "<li>"
      source += "<a href='##{currentWorkingDirectory()}'>#{@title}</a>"
      source += "<ul class='nav nav-stacked'>"

      path = File.join(context.registers[:site].config['source'], @path, "*")
      file_array = Dir.glob(path)
      if @reverse
        file_array = file_array.reverse
      end

      file_array.each do |entry|
        entryname = Pathname.new(entry).basename

        # Get all subdirectories
        if File.directory?(entry)
          source += "<li><a href='##{idForSubdirectory(entryname)}'>#{entryname}</a></li>"
        end
      end

      source += "</ul></li>"
      source
    end

    def currentWorkingDirectory()
      return @path.split("/").last
    end

    def verboseCurrentWorkingDirectory()
      return currentWorkingDirectory().capitalize
    end

    def idForSubdirectory(directory)
      id = "#{currentWorkingDirectory()}-#{directory}"
      return id.gsub(/\s/i, "").gsub(/\W/i, "-").downcase;
    end

  end
end

Liquid::Template.register_tag('doc_nav', Jekyll::DocNav)
