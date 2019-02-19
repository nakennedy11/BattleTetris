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

Changes (2/13 - Bach)
- Got rendering to work for everything except for the L pieces for some reason. Maybe the socket was rendering 
  an old game state? I'll take a look at it later today.
- Moved piece rendering to ontick, but I'm really not sure where to put it.
- TODO: falling, collision, line destruction (in order of difficulty)


Changes (2/13 evening, ya boi n$$$)
- everything seems to be rendering fine for me
  - The L piece was rendering backwards but thats because you were recursively
  calling rev_l_piece instead of l_piece in the function, i'm assuming you
  copied and pasted and just never changed it lmao (i'm such a goddamn idiot... - Bach)
- abstracted rendering functions to take a parameter x, that way we can use it
  to un-render an old piece as it moves as well
- added falling, still need to make it stop at the bottom but I feel that should be handled at collision. We are on our way to finding the wild things (i havent heard that phrase in years)
- There can be another condition for falling, when i == 20.

- TODO: also need to add turning the piece which will mightily mess up our rendering but thats ok because we still have each other
  - Will it? I thought since we render based off of the anchor point, if we pass a rotated anchor point, it'll be fine? We just need to
     - calculate rotations on that point?

Changes (2/15) noah

added collision? and check collision
pieces stop at the bottom but will go through each other
render next piece is struggling, im not sure exactly with what
I think if statements don't like having multiple conditions?? maybe add a function that evaluates or something idk

Changes 2/16, Bach
Changed axis of rotation, looks a lot better now.
Changed the tick rate, looks smoother now.

Changes 2/18 early morning, Mozart

Got collision on falling, we were using the 0 or 1 value of the index on the board instead of the index which messed things up for a while, but I think in the end I got a cleaner function anyways so whatever

Added a function get_outermost - it gives the left or rightmost j value in the piece.
      - we're going to need to use this to determine if a piece can be moved left or right based on hitting the edge
      - right now its a bit tough because we don't get the index list in move
      - I think we should add a function to return an idx_list because there are at least 2 places already that have the 7-armed-cond (decent band name btw) to check a piece and get its index list

Definitely an issue with eliminating lines too - idk what rn, might end up being better to just check in javascript and handle the actual changes in elixir?
or just move it all to elixir because we are a couple of back end savages and we all know you love ~pattern matching~

Noah 2/19 crack of dawn

     -Made a function to get the idx_list which helped with moving and also made render and collision functions cleaner

     - I changed elim_lines() just from having it say let game = in the loop to game = because I think it was messing with it. I added a bunch of console.logs to check the function and it is definitely noticing when a line is full and trying to remove it -- at this time it seems like it almost does but my game board just sort of glitches and shows both the previous board and the one with removed lines, but pieces are colliding with old pieces. Not sure why its updating so weirdly like that.


Bach 2/19 Morning
GOT COLLISION - we weren't updating the game state on the server side, so I added a function in the games channel to do that.
Moved the buttons to WASD because I didn't like the page moving when I used the arrwo keys
Set up skeleton for MP: supervisor and stack files in lib/tetrismp
Pressing D accelerates the falling.
