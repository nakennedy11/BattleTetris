Changes (2/11, night):

Added skeleton for rendering in game.ex
Added render piece in tetrismp.jsx, but didn't call it anywhere
  - need to fiure out React's tick stuff for ontick
Also changed some things with the way things are instantiated in game.ex.
  - lmk if these changes are confusing, but I tried to make them look a little cleaner.

Changes (2/12, morning):

Added rendering functions in game.ex, the logic is a little weird, but hopefully my comments make it clear
  - basically, every time we alter the index, we need to go back to the anchor point or else the indexes get messed up
  - lmk if this is wrong, and I'm just stupid, but it kinda makes sense in my head.

Added index calculations functions in game.ex

Added a function that would update the list at the given index with a 1 and then update the game.
Added some ontick stuff, looks like its working, need to add the rendering piece function to the ontick.

Changes (2/12, night - by Noah)

Added smaller side-board to have a place where we can render the next piece
      - Needs to be in a column div and not a row otherwise it just renders in a line
      - originally called render_next_piece() in on tick but it didn't really need that cause it renders every
        second and the next piece will just re-render when it gets changed assumedly
      - The render in game.ex is fairly manual but it doesn't really need any crazy logic
        - I feel like it would be much more work than it's worth to fully abstract all the other render functions
          for such a simple thing
