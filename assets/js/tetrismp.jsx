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
    this.state = {
    }

    this.channel
      .join()
      .receive("ok", resp => { console.log("Joined successfully", resp.game);
                            this.setState(resp.game);})
      .receive("error", resp => {console.log("Unable to join", resp);});
  }

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
        temp_row.push(<div  key={key_count}> <Tile value={0}/> </div>);
	key_count = key_count + 1;
      }
      board[i].push(<div className="row" key={key_count2}> {temp_row} </div>);
      key_count2 = key_count2 + 1;

    }
    return board;
  }


  render() {
    let board = this.create_board();
    return board;
  }
}


function Tile(props) {
  
  return <div className="square"></div>

}
