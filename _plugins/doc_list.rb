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
# --reverse (default=false)

module Jekyll
  class DocList < Liquid::Tag
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
      source = "<section class='group' id='#{currentWorkingDirectory()}'>"
      source += "<h2>#{@title}</h2>"
      source += "<ul>"
      sub_source = ""

      path = File.join(context.registers[:site].config['source'], @path, "*")
      file_array = Dir.glob(path)
      if @reverse
        file_array = file_array.reverse
      end

      file_array.each do |entry|
        entryname = Pathname.new(entry).basename
        url = File.join('/', @path, entryname)

        # Look through Subdirectories
        if File.directory?(entry)
          sub_source += "<div class='subgroup' id='#{idForSubdirectory(entryname)}'>"
          sub_source += "<h4>#{entryname}</h4>"
          sub_source += "<ul>"

          sub_path = File.join(entry, "*")
          sub_file_array = Dir.glob(sub_path)
          if @reverse
            sub_file_array = sub_file_array.reverse
          end

          sub_file_array.each do |sub_entry|
            sub_entryname = Pathname.new(sub_entry).basename
            sub_url = File.join('/', @path, entryname, sub_entryname)

            sub_source += "<li><a href='#{sub_url}'>#{sub_entryname}</a></li>"
          end

          sub_source += "</ul>"
          sub_source += "</div>"
        # Endif
          
        # Else
        else
          source += "<li><a href='#{url}'>#{entryname}</a></li>"
        end
        # Endelse

      end

      source += sub_source
      source += "</ul></section>"
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

Liquid::Template.register_tag('doc_list', Jekyll::DocList)
