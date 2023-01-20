% move(Player, Board, Row, Col, newBoard)

:- dynamic replace/4.

% replaces an element in a list
replace(1, [_|T], X, [X|T]).
replace(I, [H|T], X, [H|R]) :-
    I > 1,!,
    I1 is I - 1,
    replace(I1, T, X, R).

% puts a piece in the board, and returns the new game state in -NewBoard
putPiece(Player, Board, Row, Col, NewBoard) :- nth1(Row, Board, OldRow),
                                            replace(Col, OldRow, Player, NewRow),
                                            replace(Row,Board,NewRow,NewBoard).
                                            

% retrieves a row of the matrix based on its index                       
getRow(Board, NumRow, Row) :- nth1(NumRow, Board, Row).

% check if place at given coordenates is empty
checkPlace(Board,Row,Col) :- getPiece(Board,Row, Col,P),
                                  P == 0.                                   

% check if place at given coordenates matches Type
checkMovePiece(Board,Row,Col,Type) :- getPiece(Board,Row, Col,P),
                                      P == Type.

% gets a piece from the board
getMovePiece(Board, Row, Col, Piece) :- (
                                        (Row =< 0; Col =< 0; Row >= 6; Col >= 7) -> 
                                        Piece = -1;
                                        nth1(Row, Board, OldRow),
                                        nth1(Col, OldRow, Piece, R)
                                        ).

% gets a piece from the board
getPiece(Board, Row, Col, Piece) :- (
                                    (Row =< 0; Col =< 0; Row >= 6; Col >= 7) -> 
                                    Piece = -1;
                                    nth1(Row, Board, OldRow),
                                    nth1(Col, OldRow, Piece, R)
                                    ).

% check if place exactly above is not a friendly stone
checkUp(Player,Board,Row,Col) :- Up is Row - 1,
                                 getPiece(Board,Up, Col,P),
                                 Player \== P.

% check if place exactly beneath is not a friendly stone
checkDown(Player,Board,Row,Col) :- Down is Row + 1,
                                   getPiece(Board,Down, Col,P),
                                   Player \== P.

% check if place exactly at his left is not a friendly stone
checkLeft(Player,Board,Row,Col) :- Left is Col - 1,
                                   getPiece(Board,Row, Left,P),
                                   Player \== P.

% check if place exactly at his right is not a friendly stone
checkRight(Player,Board,Row,Col) :- Right is Col + 1,
                                   getPiece(Board,Row,Right,P),
                                   Player \== P.

% checks if its possible to drop a stone at given coordenates
checkDrop(Player,Board,Row,Col) :-
                        checkPlace(Board,Row,Col),
                        checkUp(Player,Board,Row, Col),
                        checkDown(Player,Board,Row, Col),
                        checkLeft(Player,Board, Row,Col),
                        checkRight(Player,Board, Row,Col).

% all valid drop phase moves for a player
findDropAll(Player,Board,Res) :-initAllCords(X),
                                numStones(Board,Player,NumStones),
                                include(aux(Player,Board),X,Tmp),
                                (NumStones >= 12 ->
                                Res = [];
                                Res = Tmp
                                ).                            


% auxiliar predicate to check a given position 
aux(Player,Board,[ROW, COL | TAIL]) :- checkDrop(Player,Board,ROW,COL).

% removes an opponent stone and returns the game state in -NewBoard
removeOpponentStone(Player, Board, NewBoard) :- getInput(Row,Col),
                                                (checkMovePiece(Board,Row,Col,Player) -> 
                                                putPiece(0, Board, Row, Col, NewBoard);
                                                write('Cant remove that coordenate. Try again!\n'),
                                                removeOpponentStone(Player, Board, NewBoard)
                                                ).

% moves a piece given its coordenates and direction by the player, returns the new game state in -NBoard
move(Player,Board,NBoard,NewRow,NewCol) :-getInput(Row,Col),
                            pieceToMove(Dir),
                            (Dir == 1 ->
                            NewRow is Row - 1,
                            NewCol is Col
                            ;Dir == 2 ->
                            NewCol is Col - 1,
                            NewRow is Row
                            ;
                            Dir == 3 ->
                            NewRow is Row + 1,
                            NewCol is Col
                            ;
                            Dir == 4 ->
                            NewCol is Col + 1,
                            NewRow is Row
                            ),
                            % ver se o sitio novo é valido
                            checkMovePiece(Board,NewRow,NewCol,0),
                            % ver se as coordenadas do input são uma peça do player
                            checkMovePiece(Board,Row,Col,Player),
                            putPiece(0, Board, Row, Col, NewBoard),
                            putPiece(Player, NewBoard, NewRow, NewCol, Last),
                            NBoard = Last.

% check if there is a 3 in a row p1
consecutive(List) :-
    consecutive(List, 0).

% check if there is a 3 in a row p1
consecutive([], Count) :- Count = 3.

% check if there is a 3 in a row p1
consecutive([1|T], Count) :-
    Count1 is Count + 1,
    consecutive(T, Count1).

% check if there is a 3 in a row p1
consecutive([0|T], Count) :-
    Count = 3,
    true.

% check if there is a 3 in a row p1
consecutive([0|T], Count) :-
    Count \= 3,
    consecutive(T, 0).

% check if there is a 3 in a row p1
consecutive([2|T], Count) :-
    Count = 3,
    true.
    
% check if there is a 3 in a row p1
consecutive([2|T], Count) :-
    Count \= 3,
    consecutive(T, 0).

% check if there is a 3 in a row p2
consecutive2(List) :-
    consecutive2(List, 0).

% check if there is a 3 in a row p2
consecutive2([], Count) :- Count = 6.

% check if there is a 3 in a row p2
consecutive2([2|T], Count) :-
    Count1 is Count + 2,
    consecutive2(T, Count1).

% check if there is a 3 in a row p2
consecutive2([0|T], Count) :-
    Count = 6,
    true.

% check if there is a 3 in a row p2
consecutive2([0|T], Count) :-
    Count \= 6,
    consecutive2(T, 0).

% check if there is a 3 in a row p2
consecutive2([1|T], Count) :-
    Count = 6,
    true.
    
% check if there is a 3 in a row p2
consecutive2([1|T], Count) :-
    Count \= 6,
    consecutive2(T, 0).

% counts the number of stones of a given player
numStones(Matrix, Number, Count) :-
    numStones(Matrix, Number, 0, Count),!.

% counts the number of stones of a given player
numStones([], _, Acc, Acc).
numStones([Row|Rows], Number, Acc, Count) :-
    numStonesRow(Row, Number, RowCount),
    NewAcc is Acc + RowCount,
    numStones(Rows, Number, NewAcc, Count).

% counts the number of stones of a given player
numStonesRow([], _, 0).
numStonesRow([Number|Numbers], Number, Count) :-
    numStonesRow(Numbers, Number, RestCount),
    Count is RestCount + 1.
    
% counts the number of stones of a given player
numStonesRow([Other|Numbers], Number, Count) :-
    Other \= Number,
    numStonesRow(Numbers, Number, Count).

% check if there is a 3-in-a-row in a row
checkThreeHorizontal(Board, Player,RowNum) :- findRow(Board,RowNum,Res),
                                              (Player == 1 -> consecutive(Res) ; consecutive2(Res)).

% check if there is a 3-in-a-row in a col
checkThreeVertical(Board, Player,ColNum) :- findCol(Board,ColNum,Res),
                                              (Player == 1 -> consecutive(Res) ; consecutive2(Res)).

% check if there is a 3-in-a-row
checkThreeMove(Board,Player,RowNum,ColNum) :- checkThreeHorizontal(Board, Player,RowNum);
                                              checkThreeVertical(Board, Player,ColNum).

checkThreeFail(Board,Player,RowNum,ColNum, NewBoard) :- (checkThreeMove(Board,Player,RowNum,ColNum) -> 
                                                            (checkThreeHorizontal(Board,Player,RowNum) ->
                                                                checkThreeVertical(NewBoard,Player,ColNum);
                                                            checkThreeVertical(Board,Player,ColNum) ->
                                                                checkThreeHorizontal(NewBoard,Player,RowNum)
                                                            );
                                                            true
                                                        ).

% check if its possible for the piece to move
checkMovement(Board,Player,Row,Col) :- checkMovePiece(Board,Row,Col,Player),
                                       checkMoveUp(Board,Player,Row,Col);
                                       checkMoveDown(Board,Player,Row,Col);
                                       checkMoveLeft(Board,Player,Row,Col);
                                       checkMoveRight(Board,Player,Row,Col).

% check if its possible for the piece to move up                     
checkMoveUp(Board,Player,Row,Col) :- X is Row - 1,
                                     checkMovePiece(Board,X,Col,0).


% check if its possible for the piece to move down
checkMoveDown(Board,Player,Row,Col) :- X is Row + 1,
                                     checkMovePiece(Board,X,Col,0).

% check if its possible for the piece to move left
checkMoveLeft(Board,Player,Row,Col) :- X is Col - 1,
                                     checkMovePiece(Board,Row,X,0).

% check if its possible for the piece to move right
checkMoveRight(Board,Player,Row,Col) :- X is Col + 1,
                                     checkMovePiece(Board,Row,X,0).

% finds all pieces that can move
findMoveAll(Player,Board,Res) :- initAllCords(X),
                                 findPlayer(Player,Board,X,R2),
                                 include(aux2(Player,Board),R2,Tmp),
                                 Res = Tmp.

% finds all possible directions for a piece to move
findDirectionMoveAll(Player,Board,Row,Col,Res) :-   
                                                    X1 is Col+1,
                                                    X2 is Col-1,
                                                    X3 is Row+1,
                                                    X4 is Row - 1,
                                                    R2 = [[Row,X1],[Row,X2],[X3,Col],[X4,Col]],
                                                    include(aux3(Player,Board),R2,Tmp),
                                                    Res = Tmp.

% auxiliar function for a piece movement                                                 
aux3(Player,Board,[ROW, COL | TAIL]) :- checkMovePiece(Board,ROW,COL,0).

% finds all player coordenates
getPlayerCoords(Player,Board,[ROW, COL | TAIL]) :- checkMovePiece(Board,ROW,COL,Player).

% finds all player coordenates
findPlayer(Player,Board,X,Res) :- 
                                 include(getPlayerCoords(Player,Board),X,Tmp),
                                 Res = Tmp.  

% auxiliar function for a piece movement    
aux2(Player,Board, [ROW, COL | TAIL]) :- checkMovement(Board,Player,ROW,COL).

% choose random member of list
choose([], []):- !.
choose(List, Elt) :-
        length(List, Length),
        random_member(Elt,List).

% randomly choose a place to drop a stone (easy mode)
botDropPhaseRandom(Player, Board, NewBoard) :-
    findDropAll(Player, Board, CoordsList),
    choose(CoordsList,[Row,Col]),
    putPiece(Player, Board, Row, Col, NewBoard).

% randomly move a piece
botMovePhaseRandom(Player, Board, NewBoard,R,C) :-
    findMoveAll(Player, Board, CoordsList),
    choose(CoordsList,[Row,Col]),
    findDirectionMoveAll(Player,Board,Row,Col,CoordsList2),
    choose(CoordsList2,[Row1,Col1]),
    putPiece(0, Board, Row, Col, NewBoard1),
    putPiece(Player, NewBoard1, Row1, Col1, Last),
    R = Row1,
    C = Col1,
    NewBoard = Last.

% randomly remove a piece from the opponent (easy mode)
botMovePhaseRandomThreeInRow(Player, Board, NewBoard) :-
    initAllCords(X),
    findPlayer(Player,Board,X,CoordsList),
    choose(CoordsList,[Row,Col]),
    putPiece(0, Board, Row, Col, Last),
    NewBoard = Last.


% greedy approach to choose a place to drop a stone (hard mode)
greedyDropPhase(Player,Board,[H | T],NewBoard) :- (greedyDropPhaseCol(Player, Board, H, [1,2,3,4,5,6], NBoard) -> NewBoard = NBoard;
                                                      greedyDropPhase(Player,Board,T,NewBoard)
                                                     ).

% greedy approach to choose a place to drop a stone (hard mode)
greedyDropPhaseCol(Player, Board, RowNum, [H | T], NewBoard) :- (checkDrop(Player,Board,RowNum,H) -> putPiece(Player,Board,RowNum,H,Novo), NewBoard = Novo;
                                                      greedyDropPhaseCol(Player, Board, RowNum, T,NewBoard)
                                                      ).

% calculate distance of a coordinate
dis([X,Y], D) :- D is sqrt(X*X + Y*Y).

% find coordenate that is the furthest from the start
further(Coords, Furthest) :-
  maplist(dis, Coords, Distances),
  maplist(pair, Distances, Coords, Pairs),
  keysort(Pairs, Sorted),
  reverse(Sorted, Reversed),
  nth0(0, Reversed, _-Furthest).

pair(X, Y, X-Y).

% find coordenate that is the closest from the start
closer(Coords, Closer) :-
  maplist(dis, Coords, Distances),
  maplist(pair, Distances, Coords, Pairs),
  keysort(Pairs, Sorted),
  nth0(0, Sorted, _-Closer).

% greedy approach to find pieces to move
getGreedyMoveCords(Player, Board,GList) :-   findMoveAll(Player,Board,CoordsList),
                                        include(aux4(Player,Board),CoordsList,Tmp),
                                        length(Tmp,X),
                                        (X == 0 -> GList1 = CoordsList; GList1 = Tmp),
                                        further(GList1,Tmp1),
                                        GList = Tmp1.


aux4(Player,Board,[ROW, COL | TAIL]) :- predictAllThree(Player, Board, ROW, COL).

%check if any movement can make a three in a row
predictAllThree(Player,Board,Row,Col) :- predictThreeDOWN(Player, Board, Row, Col);
                                         predictThreeUP(Player, Board, Row, Col);
                                         predictThreeLEFT(Player, Board, Row, Col);
                                         predictThreeRIGHT(Player, Board, Row, Col).

%check if by moving down a 3-in-a-row is made
predictThreeDOWN(Player, Board, Row, Col) :- X is Row + 1,
                                           checkMovePiece(Board,X,Col,0),
                                           putPiece(0, Board, Row, Col, NewBoard),
                                           putPiece(Player, NewBoard, X, Col, Last),
                                           checkThreeMove(Last,Player,X,Col).
%check if by moving up a 3-in-a-row is made
predictThreeUP(Player, Board, Row, Col) :- X is Row - 1,
                                           checkMovePiece(Board,X,Col,0),
                                           putPiece(0, Board, Row, Col, NewBoard),
                                           putPiece(Player, NewBoard, X, Col, Last),
                                           checkThreeMove(Last,Player,X,Col).
%check if by moving left a 3-in-a-row is made
predictThreeLEFT(Player, Board, Row, Col) :- X is Col - 1,
                                           checkMovePiece(Board,Row,X,0),
                                           putPiece(0, Board, Row, Col, NewBoard),
                                           putPiece(Player, NewBoard, Row, X, Last),
                                           checkThreeMove(Last,Player,Row,X).
%check if by moving right a 3-in-a-row is made
predictThreeRIGHT(Player, Board, Row, Col) :- X is Col + 1,
                                           checkMovePiece(Board,Row,X,0),
                                           putPiece(0, Board, Row, Col, NewBoard),
                                           putPiece(Player, NewBoard, Row, X, Last),
                                           checkThreeMove(Last,Player,Row,X).

% greedy approach to move a stone (hard mode)
greedyMovePhaseM(Player, Board,R,C,NewBoard) :- getGreedyMoveCords(Player, Board,[Row,Col]),
                                            (
                                            predictThreeDOWN(Player, Board, Row, Col) -> 
                                                                                         X is Row + 1,
                                                                                         putPiece(0, Board, Row, Col, NewBoard1),
                                                                                         putPiece(Player, NewBoard1, X, Col, NewBoard2),
                                                                                         NewBoard = NewBoard2,
                                                                                         R = X,
                                                                                         C = Col
                                                                                        ;
                                            predictThreeUP(Player, Board, Row, Col) ->  
                                                                                        X is Row - 1,
                                                                                        putPiece(0, Board, Row, Col, NewBoard1),
                                                                                        putPiece(Player, NewBoard1, X, Col, NewBoard2),
                                                                                        NewBoard = NewBoard2,
                                                                                        R = X,
                                                                                        C = Col
                                                                                        ;
                                            predictThreeLEFT(Player, Board, Row, Col) -> 
                                                                                         X is Col - 1,
                                                                                         putPiece(0, Board, Row, Col, NewBoard1),
                                                                                         putPiece(Player, NewBoard1, Row, X, NewBoard2),
                                                                                         NewBoard = NewBoard2,
                                                                                         R = Row,
                                                                                         C = X
                                                                                        ;
                                            predictThreeRIGHT(Player, Board, Row, Col) -> X is Col + 1,
                                                                                          putPiece(0, Board, Row, Col, NewBoard1),
                                                                                          putPiece(Player, NewBoard1, Row, X, NewBoard2),
                                                                                          NewBoard = NewBoard2,
                                                                                          R = Row,
                                                                                          C = X
                                                                                          ;
                                            findDirectionMoveAll(Player,Board,Row,Col,CoordsList2),
                                            closer(CoordsList2,[Row1,Col1]),
                                            putPiece(0, Board, Row, Col, NewBoard1),
                                            putPiece(Player, NewBoard1, Row1, Col1, NewBoard2),
                                            NewBoard = NewBoard2,
                                            R = Row1,
                                            C = Col1
                                            ).

% greedy approach to choose a place to drop a stone (hard mode)
botDropPhaseHard(Player, Board, NewBoard) :-
    greedyDropPhase(Player, Board,[1,2,3,4,5], NewBoard1),
    NewBoard = NewBoard1.

% greedy approach to move a stone (hard mode)
botMovePhaseHard(Player, Board, NewBoard,R,C) :-
    greedyMovePhaseM(Player, Board,Row,Col, NewBoard1),
    NewBoard = NewBoard1,
    R = Row,
    C = Col.

% greedy approach to move a stone (hard mode)
botMovePhaseHardThreeInRow(Player, Board, NewBoard) :-
    initAllCords(Y),
    findPlayer(Player,Board,Y,ALL),
    findMoveAll(Player,Board,CoordsList),
    length(CoordsList,Z),
    (Z == 0 ->  GList = ALL,
                choose(GList, [Row,Col]),
                putPiece(0, Board, Row, Col, NewBoard1),
                NewBoard = NewBoard1;
                include(aux4(Player,Board),CoordsList,Tmp),
                length(Tmp,X),
                (X == 0 -> GList = CoordsList; GList = Tmp),
                choose(GList, [Row,Col]),
                putPiece(0, Board, Row, Col, NewBoard1),
                NewBoard = NewBoard1
    ).

% find all valid directions
valid_Directions(Board, Player, [], []).
valid_Directions(Board, Player, [[Row,Col] | T], List) :-
    findDirectionMoveAll(Player,Board,Row,Col,CoordsList),
    valid_Directions(Board, Player, T, List1),
    append([Row,Col] , CoordsList ,Var),
    append([Var], List1, List2),
    List = List2.

% all valid moves for a turn of a player
valid_moves(Board, Player, ListOfMoves) :-
    findMoveAll(Player,Board,CoordsList),
    valid_Directions(Board, Player, CoordsList, List),
    ListOfMoves = List.

% check if a game is over
game_over(Board, Winner) :-
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    (
    NumStones1 =< 0 -> 
        write('White has no more stones. Black wins! \n'),
        Winner = 2;
    NumStones2 =< 0 ->
        write('Black has no more stones. White wins! \n'),
        Winner = 1;
    NumStones1 < 3, NumStones2 < 3 ->
        write('Both players have less than 3 stones. Game ends in a draw! \n'),
        Winner = 0;
    fail
    ).


