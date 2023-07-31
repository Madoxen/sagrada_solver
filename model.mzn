int: h = 5;
int: w = 6;
%0 - red, 1 - yellow, 2 - green, 3 - blue, 4 - purple
int: colors = 4;
int: numbers = 6;

%Total height and width (working height + padding)
set of int: HEIGHT = 0..h;
set of int: WIDTH = 0..w;
%Working height
set of int: CHEIGHT = 1..h-1;
%Working width
set of int: CWIDTH = 1..w-1;
% number of distinct colors available in the game
set of int: COLORS = 0..colors;
% number of pips on dices (we play with d6 in sagrada)
set of int: NUMBERS = 1..numbers;

array[CHEIGHT,CWIDTH] of opt COLORS: color_target;
array[CHEIGHT,CWIDTH] of opt NUMBERS: number_target;

% Representation of a board, divided into two separate arrays
% one is used for color checking and the second one for number checks
array[HEIGHT,WIDTH] of var opt COLORS: color_board;
array[HEIGHT,WIDTH] of var opt NUMBERS: number_board;
var int: points;

%setup boundary
constraint forall(i in HEIGHT)( color_board[i, 0] = <> /\
								color_board[i, w] = <> /\
								number_board[i, 0] = <> /\
								number_board[i, w] = <>);


constraint forall(j in WIDTH)( color_board[0, j] = <> /\
							   color_board[h, j] = <> /\
							   number_board[0, j] = <> /\
							   number_board[h, j] = <>);

% Make sure that working area is not none
% TODO: let's later allow empty placements and give a penalty of -1 point
% for each such empty place in a working area
constraint forall(i in CHEIGHT, j in CWIDTH) ( color_board[i,j] != <> /\
											   number_board[i,j] != <>);

% Sagrada adjacency rules
% 0. Adjacency is defined as von Neumann neighbourhood
% 1. Adjacent dices cannot be of the same color
% 2. Adjacent dices cannot have the same number of pips


constraint forall(i in CHEIGHT, j in CWIDTH)(
              color_board[i,j] != color_board[i-1,j] /\
              color_board[i,j] != color_board[i+1,j] /\
              color_board[i,j] != color_board[i,j-1] /\
			  color_board[i,j] != color_board[i,j+1]);

constraint forall(i in CHEIGHT, j in CWIDTH)(
              number_board[i,j] != number_board[i-1,j] /\
              number_board[i,j] != number_board[i+1,j] /\
              number_board[i,j] != number_board[i,j-1] /\
			  number_board[i,j] != number_board[i,j+1]);

% Additional placement rules
constraint forall(i in CHEIGHT, j in CWIDTH)(
			  number_board[i,j] ~= number_target[i,j] /\
			  color_board[i,j] ~= color_target[i,j]);



solve maximize points;
