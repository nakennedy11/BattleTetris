import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';


export default function game_init(root, channel) {
    ReactDOM.render(<TetrisBoard channel={channel} />, root);
}


class TetrisBoard extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = { // these values don't matter; they'll be overwritten by game.ex
            board: [],
            current_piece: [],
            next_piece: [],
            side_board: [],
            lines_destroyed: 0,
            seconds: 0,
            enemy_board: [],
            enemy_lines_destroyed: 0,
            id: ""
        };
        
        this.channel
            .join()
            .receive("ok", resp => { console.log("Joined successfully", resp.game);
                                     this.setState(resp.game);})
            .receive("error", resp => {console.log("Unable to join", resp);});

        this.channel.on("update", this.gotView.bind(this));
    }

    gotView(view) {
      let game = view.game;

	      console.log("game ID: " + game.id + "state ID: " + this.state.id);
      if (game.id == this.state.id) {
      this.channel.push("update_game", {game: game})
                    .receive("ok", resp => {
                        this.setState(resp.game);});
       
      }
      else {
        let new_enemy_board = view.game.board;
        let new_enemy_lines = view.game.lines_destroyed;

        this.setState(prevState => ({enemy_board : new_enemy_board, enemy_lines_destroyed : new_enemy_lines}));
      }
    }   
    
    // on tick function
    tick() {
        this.setState(prevState => ({ seconds : prevState.seconds + 1}));
        
        this.piece_fall();
        this.render_piece();
        this.elim_lines();
        this.render_next_piece();
        //this.game_over();
    }

    game_over() {
      let lines_elim = this.state.lines_destroyed;
      let enemy_elims = this.state.enemy_lines_destroyed;

      if (lines_elim >= 5) {
         alert("You won! Eliminated " + lines_elim + " lines and your opponent eliminated " + enemy_elims + ".");
      } else if (enemy_elims >= 5) {
         alert("You lost :( Eliminated " + lines_elim + " lines and your opponent eliminated " + enemy_elims + ".");  
      }
    }
    
    elim_lines() {
        let game = this.state.board;
   	
        for (let i = 0; i < 200; i += 10) {
	    let all_ones = !game.slice(i, i + 10).includes(0);
	    if (all_ones) {
		let array0 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		let array1 = game.slice(0, i);
		let array2 = game.slice(i + 10, 200);
		game = array0.concat(array1, array2);
                this.channel.push("update_board", {board: game})
                    .receive("ok", resp => {
                        this.setState(resp.game);});
	    }
            
        }
	
        
    }
    
    // mounting component
    componentDidMount() {
        this.interval = setInterval(() => this.tick(), 750);
        document.addEventListener("keyup", (e) => {
	    let code = e.keyCode;
	    if (code == 87) { // up on arrow to rotate
                this.channel.push("rotate", {})
                    .receive("ok", resp => {
                        this.setState(resp.game);});
	    }
	    else if (code == 65) { // left on arrow to move left
                this.channel.push("move", {direction : "left"})
                    .receive("ok", resp => {
                        this.setState(resp.game);});
            }
            else if (code == 68) { // right on arrow to rotate
                this.channel.push("move", {direction : "right"})
                    .receive("ok", resp => {
	                this.setState(resp.game);});
            }
            else if (code == 83) { // right on arrow to rotate
	        this.piece_fall(); 
            }
            
            
	}
                                  , true);
    }
    
    componentWillUnmount() {
        clearInterval(this.interval);
        document.removeEventListener("keyup",(e) => {
	    alert(e.keyCode);
            this.channel.push("rotate", {})
                .receive("ok", resp => {console.log("rotate", resp.game);
                                        this.setState(resp.game);});} );
    }
    
    // create the board
    create_board(game_board) {
        let board = [];
        let i;
        let j;
        let key_count = 0;
        let key_count2 = 0;
        for (i = 0 ; i < 20; i++) {
            board[i] = [];
            let temp_row = [];
            for (j = 0; j < 10; j++ ) {
	        let val = 10 * i + j; // this is the corresponding index in game.ex's board
                temp_row.push(<div key={key_count}> <Tile value={game_board[val]}/> </div>);
	        key_count = key_count + 1;
            }
            board[i].push(<div className="row" key={key_count2}> {temp_row} </div>);
            key_count2 = key_count2 + 1;   
        }
        return board;
    }
    
    create_side_board() {
        let board = [];
        let i;
        let j;
        let key_count = 0;
        let key_count2 = 0;
        for (i = 0; i < 4; i++) {
            board[i] = [];
            let temp_row = [];
            for (j = 0; j < 4; j++ ) {
	        let val = 4 * i + j; // this is the corresponding index in game.ex's side_board
                temp_row.push(<div key={key_count}> <Tile value={this.state.side_board[val]}/> </div>);
	        key_count = key_count + 1;
            }
            board[i].push(<div className="row" key={key_count2}> {temp_row} </div>);
            key_count2 = key_count2 + 1;
            
        }
        return board;    
    }
    
    // render the current piece
    render_piece() {
        this.channel.push("render_piece", {})
	    .receive("ok", resp => {
		this.setState(resp.game);});
    }
    
    render_next_piece() {
        this.channel.push("render_next_piece", {})
            .receive("ok", resp => {
                this.setState(resp.game);});
    }
    
    piece_fall() {
    this.channel.push("piece_fall", {})
            .receive("ok", resp => {
                this.setState(resp.game);});
    }
    
    
    render() {
        let player_board = this.create_board(this.state.board);
        let side_board = this.create_side_board();
        let enemy_board = this.create_board(this.state.enemy_board);
        
        return (
	    <div className="row">
              <div className="column">
                <div className="row">
                  <div className="column">{player_board}</div>
                  <div className="coulumn">
                    <div className="row"> Next Piece:</div>
                    <div className="column"> {side_board}</div>
                    <div className="row"> Lines Eliminated: {this.state.lines_destroyed}</div>
                  </div>
                </div>
              </div>
              
              <div className="column">
                <div className="row">
                  <div className="row">Enemy's board:</div>
                  <div className="column">{enemy_board}</div>
                  <div className="row">Lines Eliminated: {this.state.enemy_lines_destroyed}</div>
                </div>
              </div>
            </div>);
    }
}


function Tile(props) {
    let value = props.value;
    if (value == 0 || value == null) {
        return <div className="e-square"></div>
    }
    else {
        return <div className="f-square"></div>
    }
}

