module Colony

  module Events

    module Ui
      BLOCK_SELECTED = :block_selected
    end

    module Ants
      SPAWNED = :ant_spawned
      KILLED = :ant_killed
      WALK_START = :ant_walk_start
      WALK_END = :ant_walk_end
      DIG_START = :ant_dig_start
      DIG_END = :ant_dig_end
      FILL_START = :ant_fill_start
      FILL_END = :ant_fill_end
    end

    module Network
      ANT = :ant
    end

    module Work
      ADDED = :work_added
      REMOVED = :work_removed
    end

    module Blocks
      DUG = :block_dug
      FILLED = :block_filled
      ATTACKED = :block_attacked
    end

  end

end
