require_relative '../system/object_factory'
require_relative 'events'
require_relative 'objects/block'

module Colony

  class BlockFactory < System::ObjectFactory

    def initialize(media)
      super(Block)

      @media = media
    end

    def dirt
      block = build
      block.texture = @media.image(:dirt)
      block.fill

      block
    end

    def grass
      block = build
      block.texture = @media.image(:grass)
      block.grassify

      block
    end

    def tunnel
      block = build
      block.texture = @media.image(:dirt)
      block.excavate

      block
    end

  end

end

