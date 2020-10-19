require_relative 'renderer'

module System
  class TextureRenderer < Renderer

    def draw(obj, opts={})
      super

      if obj.visible?
        color = opts[:color] || obj.color
        z = opts[:z] || obj.z
        x_offset = opts[:x_offset] || 0
        y_offset = opts[:y_offset] || 0

        obj.texture.draw_rot(
          obj.x + x_offset,
          obj.y + y_offset,
          z,
          obj.angle,
          0.5,
          0.5,
          obj.width / obj.texture.width,
          obj.height / obj.texture.height,
          color
        )
      end
    end

  end
end
