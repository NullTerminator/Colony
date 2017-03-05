module Game
  module Ui
    class Menu < Container
      attr_accessor :item_gap
      attr_reader :parent

      def initialize(x, y, tex=nil, parent=nil)
        super(x, y, tex)
        @parent = parent
        @item_gap = 10
        set_item_locations
      end

      def root
        menu = self
        while menu.parent
          menu = menu.parent
        end
        menu
      end

      def x=(val)
        @x = val
        set_item_locations
      end

      def y=(val)
        @y = val
        set_item_locations
      end

      def item_gap=(val)
        @item_gap = val
        set_item_locations
      end

      def add(item)
        super(item)
        set_item_locations
      end

      def hide
        super
        root.set_item_locations
      end

      def show
        super
        root.set_item_locations
      end

      def toggle_visible
        super
        root.set_item_locations
      end

      def width
        @width
      end

      def height
        @height
      end

      def set_item_locations
        last_item_bottom = y
        @width = 0
        @height = 0
        objects.each_with_index do |item, index|
          next unless item.visible?
          item.y = last_item_bottom
          last_item_bottom = item.bottom + item_gap

          @height += item.height
          @width = item.width if item.width > width
        end
        @height += item_gap * (objects.select(&:visible).count - 1)
      end
    end
  end
end
