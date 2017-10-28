module Game
  module Ui
    class FileMenu < Menu
      def initialize(x, y, tex=nil, parent=nil, path_or_stepper=Dir.pwd)
        super(x, y, tex, parent)
        @dir_stepper = path_or_stepper.is_a?(String) ? DirectoryStepper.new(path_or_stepper) : path_or_stepper

        @dir_stepper.entries.each do |entry|
          menu_item_from_entry(entry)
        end
      end

      def menu_item_from_entry(entry)
        b = Button.new x, y, MediaManager.instance.image_from_text(entry.display, 25, font: "Menio")
        add b

        if entry.dir?
          menu = FileMenu.new x + 25, y, nil, self, entry
          menu.hide
          add menu
          b.click = lambda {
            MediaManager.instance.sound(:beep).play
            puts "clicked: #{entry.display}" if Game.instance.debug
            menu.toggle_visible
          }
        else
          b.click = lambda { MediaManager.instance.sound(:beep).play }
        end
        b
      end
    end
  end
end
