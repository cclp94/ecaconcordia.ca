# ImageSet Liquid Plugin
# by Erik Dungan
# erik.dungan@gmail.com / @callmeed
# 
# Takes a dir, gets all the images from it, and creates HTML image and container tags
# Useful for creating an image gallery and the like 
# 
# USAGE
# default: {% image_set images/gallery1 %}
# (this will create a UL, then LI and IMG tags for each image in images/gallery1)
# 
# with options: {% image_set images/gallery2 --class=img-responsive --container-tag=div --wrap-tag=div %}
# (this will set the class for the <img> tags and use <div>s for the container and wrap)
# 
# OPTIONS
# --class=some_class (sets the class for the <img> tags, default is 'image')
# --wrap_tag=some_tag (sets the tag to wrap around each <img>, default is 'li')
# --wrap_class=some_class (sets the class for wrap_tag, default is 'image-item')
# --container_tag=some_tag (sets the tag to contain all <img>s, default is 'ul')
# --container_class=some_class (sets the class for container_tag, default is 'image-set')


module Jekyll
  class ImageSet < Liquid::Tag
    @path = nil

    @class = nil
    @wrap_class = nil
    @wrap_tag = nil
    @container_tag = nil
    @container_class = nil

    def initialize(tag_name, text, tokens)
      super

      # The path we're getting images from (a dir inside your jekyll dir)
      @path = text.split(/\s+/)[0].strip # splits the string (params) when whitespace and takes the 1st element

      # Defaults
      @container_tag = 'ul'
      @container_class = 'image-set'

      # Parse Options
      # ie REGEX to recognize options submitted
      if text =~ /--container-tag=(\S+)/i
        @container_tag = text.match(/--container-tag=(\S+)/i)[1]
      end
      if text =~ /--container-class=(\S+)/i
        @container_class = text.match(/--container-class=(\S+)/i)[1]
      end

    end

    def render(context)
      # Get the full path to the dir
      # Include a filter for JPG and PNG images
      # Creates a pattern for the different file types
      full_path = File.join(context.registers[:site].config['source'], @path, "*")

      #TODO: replace with path of files I want

      # Start building tags
      source = "<ul class='#{@container_class}'>\n" # = <ul class="image-item">

      # Glob the path and create tags for all images
      # Creates the list of file, and iterates over them
      Dir.glob(full_path).each do |image|
        file = Pathname.new(image).basename
        src = File.join('/', @path, file)
        source += "<li>\n" 
        source += "<a href='#{src}'>"
        source += "#{file}"
        source += "</a>\n"
        source += "</li>\n" 

      end
      # Close it up 
      source += "</ul>\n"
      source

    end
  end
end

Liquid::Template.register_tag('image_set', Jekyll::ImageSet)
