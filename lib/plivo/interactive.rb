require_relative "template"

module Plivo
  class Interactive
    attr_accessor :type, :header, :body, :footer, :action

    def initialize(type: nil, header: nil, body: nil, footer: nil, action: nil)
      @type = type
      @header = header
      @body = body
      @footer = footer
      @action = action
    end

    def to_hash
      {
        type: @type,
        header: @header&.to_hash,
        body: @body&.to_hash,
        footer: @footer&.to_hash,
        action: @action&.to_hash
      }.reject { |_, v| v.nil? }
    end
  end

  class Header
    attr_accessor :type, :text, :media

    def initialize(type: nil, text: nil, media: nil)
      @type = type
      @text = text
      @media = media
    end

    def to_hash
      {
        type: @type,
        text: @text,
        media: @media
      }.reject { |_, v| v.nil? }
    end
  end

  class Body
    attr_accessor :text

    def initialize(text: nil)
      @text = text
    end

    def to_hash
      {
        text: @text
      }.reject { |_, v| v.nil? }
    end
  end

  class Footer
    attr_accessor :text

    def initialize(text: nil)
      @text = text
    end

    def to_hash
      {
        text: @text
      }.reject { |_, v| v.nil? }
    end
  end

  class Action
    attr_accessor :buttons, :sections

    def initialize(buttons: nil, sections: nil)
      @buttons = buttons ? buttons.map { |b| Buttons.new(**b) } : []
      @sections = sections ? sections.map { |s| Section.new(**s) } : []
    end

    def to_hash
      {
        buttons: @buttons.map(&:to_hash),
        sections: @sections.map(&:to_hash),
      }.reject { |_, v| v.nil? }
    end
  end

  class Buttons
    attr_accessor :id, :title, :cta_url

    def initialize(id: nil, title: nil, cta_url: nil)
      @id = id
      @title = title
      @cta_url = cta_url
    end

    def to_hash
      {
        id: @id,
        title: @title,
        cta_url: @cta_url
      }.reject { |_, v| v.nil? }
    end
  end

  class Section
    attr_accessor :title, :rows

    def initialize(title: nil, rows: nil)
      @title = title
      @rows = rows ? rows.map { |r| Row.new(**r) } : []
    end

    def to_hash
      {
        title: @title,
        rows: @rows.map(&:to_hash),
      }.reject { |_, v| v.nil? }
    end
  end

  class Row
    attr_accessor :id, :title, :description

    def initialize(id: nil, title: nil, description: nil)
      @id = id
      @title = title
      @description = description
    end

    def to_hash
      {
        id: @id,
        title: @title,
        description: @description
      }.reject { |_, v| v.nil? }
    end
  end
end
