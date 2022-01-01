module Colony

  module Events

    module Ants
      SPAWNED = :ant_spawned
      KILLED = :ant_killed
      WALK_START = :ant_walk_start
      WALK_END = :ant_walk_end
      DIG_START = :ant_dig_start
      DIG_END = :ant_dig_end
      FILL_START = :ant_fill_start
      FILL_END = :ant_fill_end

      SELECTED = :ant_selected
    end

    module Selection
      CLEAR = :selection_clear
    end

    module Dig
      CLEAR = :dig_clear
      MOUSE_MOVE = :dig_mouse_move
    end

    module Network
      ANT = :network_ant
    end

    module Work
      ADDED = :work_added
      REMOVED = :work_removed
    end

    module Blocks
      DUG = :block_dug
      FILLED = :block_filled
      ATTACKED = :block_attacked

      CLICKED = :block_clicked
    end

    module Camera
      MOVE = :camera_move
      MOUSE_MOVE = :camera_mouse_move
      MOUSE_LEFT = :camera_mouse_left
      MOUSE_RIGHT = :camera_mouse_right
      MOUSE_OUT = :camera_mouse_out
    end

  end

end
