require_relative 'activity'
require_relative 'author'
require_relative 'thread'
require_relative 'link'

require 'ostatus/atom/entry'

module OStatus
  # Holds information about an individual entry in the Feed.
  class Entry
    # Holds a String containing the title of the entry.
    attr_reader :title

    # Holds an OStatus::Author.
    attr_reader :author

    # Holds the content.
    attr_reader :content

    # Holds the MIME type of the content.
    attr_reader :content_type

    # Holds the id that uniquely identifies this entry.
    attr_reader :id

    # Holds the url that represents the entry.
    attr_reader :url

    # Holds the DateTime of when the entry was published originally.
    attr_reader :published

    # Holds the DateTime of when the entry was last modified.
    attr_reader :updated

    # Create a new entry with the given content.
    #
    # options:
    #   :title        => The title of the entry. Defaults: "Untitled"
    #   :author       => A OStatus::Author responsible for generating this entry.
    #   :content      => The content of the entry. Defaults: ""
    #   :content_type => The MIME type of the content.
    #   :published    => The DateTime depicting when the entry was originally
    #                    published. Defaults: DateTime.now
    #   :updated      => The DateTime depicting when the entry was modified.
    #   :url          => The canonical url of the entry.
    #   :id           => The unique id that identifies this entry.
    def initialize(options = {})
      @title = options[:title] || "Untitled"
      @content = options[:content] || ""
      @content_type = options[:content_type]
      @published = options[:published] || DateTime.now
      @updated = options[:updated]
      @url = options[:url]
      @id = options[:id]
    end

    # Yield the OStatus::Activity associated with this entry.
    def activity
      @activity ||= Activity.new(self)
    end

    # Assign the activity associated with this entry.
    #def activity= value
    #  if value.object_type
    #    self.activity_object_type = OStatus::Activity::SCHEMA_ROOT + value.object_type.to_s
    #  end
    #  self.activity_object = value.activity_object if value.object
    #  if value.verb
    #    self.activity_verb = OStatus::Activity::SCHEMA_ROOT + value.activity_verb.to_s
    #  end
    #  self.activity_target = value.activity_target if value.target
    #end

    # Assign the url associated with this entry.
    #def url
    #  if links.alternate
    #    links.alternate.href
    #  elsif links.self
    #    links.self.href
    #  else
    #    links.map.each do |l|
    #      l.href
    #    end.compact.first
    #  end
    #end

    #def url= value
    #  links << Atom::Link.new(:rel => "alternate", :href => value)
    #end

    #def link
    #  links.group_by { |l| l.rel.intern }
    #end

    #def link= options
    #  links.clear << Atom::Link.new(options)
    #end

    # Returns a Hash of all fields.
    def info
      {
        :activity => self.activity.info,
        :id => self.id,
        :title => self.title,
        :content => self.content,
        :link => self.link,
        :published => self.published,
        :updated => self.updated
      }
    end

    def to_atom
      OStatus::Atom::Entry.new(self)
    end
  end
end
