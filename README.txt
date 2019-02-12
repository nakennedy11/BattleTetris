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
