% columns definition
col('a',1).
col('b',2).
col('c',3).
col('d',4).
col('e',5).
col('f',6).

col('A',1).
col('B',2).
col('C',3).
col('D',4).
col('E',5).
col('F',6).

player(1).
player(2).

% get row and col input from user
getInput(Row,Col) :- write('Coordinates? (e.g: A2)'),
                     nl,
                     read(Input),
                     atom_chars(Input,L),
                     [X,Y] = L,
                     char_code(X,Res),
                     char_code(Y,Res2),
                     Row is Res2 - 48,
                     Col is Res - 64.

% get direction to move a piece
pieceToMove(Dir) :- write('1 - Move Up'),nl,
                    write('2 - Move Left'),nl,
                    write('3 - Move Down'),nl,
                    write('4 - Move Right'),nl,
                    read(Dir).