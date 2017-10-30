require_relative 'renderer'

module System
  class TextureRenderer < Renderer

    def draw(obj, opts={})
      super

      if obj.visible?
        color = opts[:color] || obj.color
        z = opts[:z] || obj.z
        obj.texture.draw_rot(obj.x, obj.y, z, obj.angle, 0.5, 0.5, obj.scale_x, obj.scale_y, color)
      end
    end

  end
end