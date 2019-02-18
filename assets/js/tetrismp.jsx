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
      seconds: 0
    };

    this.channel
      .join()
      .receive("ok", resp => { console.log("Joined successfully", resp.game);
                            this.setState(resp.game);})
      .receive("error", resp => {console.log("Unable to join", resp);});
  }

  // on tick function
  tick() {
    this.setState(prevState => ({ seconds : prevState.seconds + 1}));
	  this.render_next_piece();
    
    this.render_piece();
    this.piece_fall();
	  this.elim_lines();

  }

  elim_lines() {
    let game = this.state.board;
   	
    for (let i = 0; i < 200; i += 10) {
	let all_ones = !game.slice(i, i + 10).includes(0);
	if (all_ones) {
	//	alert("HERE");
		let array0 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		let array1 = game.slice(0, i);
		let array2 = game.slice(i + 10, 200);
		let game = array0.concat(array1, array2);
	}
    }

    this.setState({ board: game});
  }

  // mounting component
  componentDidMount() {
    this.interval = setInterval(() => this.tick(), 500);
    document.addEventListener("keydown", (e) => {
	   let code = e.keyCode;
	   if (code == 38) { // up on arrow to rotate
             this.channel.push("rotate", {})
                 .receive("ok", resp => {console.log("rotate", resp.game);});
	   }
	   else if (code == 37) { // left on arrow to move left
             this.channel.push("move", {direction : "left"})
                 .receive("ok", resp => {console.log("move left", resp.game);});
           }
           else if (code == 39) { // right on arrow to rotate
             this.channel.push("move", {direction : "right"})
                 .receive("ok", resp => {console.log("move right", resp.game);});
           }
           this.setState(resp.game);
	   }
    , true);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
    document.removeEventListener("keydown",(e) => {
	                 alert(e.keyCode);
                         this.channel.push("rotate", {})
          .receive("ok", resp => {console.log("rotate", resp.game);
           this.setState(resp.game);});} );
  }

  // create the board
  create_board() {
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
        temp_row.push(<div key={key_count}> <Tile value={this.state.board[val]}/> </div>);
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
	  .receive("ok", resp => {console.log("rendered piece", resp.game);
		  this.setState(resp.game);});
  }

  render_next_piece() {
    this.channel.push("render_next_piece", {})
                .receive("ok", resp => {console.log("rendered next piece", resp.game);
                this.setState(resp.game);});
  }

  piece_fall() {
    this.channel.push("piece_fall", {})
                .receive("ok", resp => {console.log("dropped piece by 1", resp.game);
                this.setState(resp.game);});
  }
  

  render() {
    let board = this.create_board();
    let side_board = this.create_side_board();
   
    return (
	    <div className="row">
      <div className="column"> {board} </div>
		  <div className="column">  Lines: {this.state.lines_destroyed} </div>
		  <div className="column">
            <div className="row"> Next Piece: {this.state.next_piece} </div>
            <div className="column"> {side_board} </div>
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

