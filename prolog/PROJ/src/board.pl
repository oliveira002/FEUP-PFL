% board matrix 5x6
:- use_module(library(lists)).
:- use_module(library(random)).
:- [input,game].

:- dynamic stonesLeft/2.

% initial board state
initBoard(L) :- L = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0]
      ].

% auxiliar predicate that has all matrix coordenates
initAllCords(L) :- L = [[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6]].


% initial menu
initialMenu(R) :-
    write(' _________________________________________'), nl,
    write('|                                        |'), nl,
    write('|      _____   _____   _____   _____     |'), nl,
    write('|     |     | |     | |     | |     |    |'), nl,
    write('|     |  W  | |  A  | |  L  | |  I  |    |'), nl,
    write('|     |_____| |_____| |_____| |_____|    |'), nl,
    write('|                                        |'), nl,
    write(' ----------------------------------------- '), nl,
    write('|                                        |'), nl,
    write('|          1. Player vs Player           |'), nl,
    write('|          2. Player vs Computer         |'), nl,
    write('|          3. Computer vs Computer       |'), nl,
    write('|                                        |'), nl,
    write(' -----------------------------------------'), nl,
    read(R),
    (   (R > 3; 1 > R) -> write('Invalid Input, Try Again!'),nl,
        initialMenu(Y),
        R = Y
    ;   true
    ).

% menu to choose CPU difficulty
difficultyMenu(R) :- 
     write('Choose the difficulty for the computer'),nl,
     write('1 - Easy'),nl,
     write('2 - Hard'),nl,
     write('3 - Easy vs Hard (only works for computer vs computer)'),nl,
     write('4 - Go Back'),nl,
     read(R),
     (   R > 4 , 1 > R -> write('Invalid Input, Try Again!'),nl,
        difficultyMenu(Y),
        R = Y
    ;   true
    ).


% displays the game depending on its state
display_game(Board) :-
    write('   A   B   C   D   E   F\n'),
    display_game(Board, 1).

% displays the game depending on its state
display_game([], _).
display_game([Row | Rows], RowNum) :-
    write(RowNum),
    write('| '),
    displayRow(Row),
    nl,
    write('  '),
    write('------------------------'),nl,
    NextRow is RowNum + 1,
    display_game(Rows, NextRow).

% displays a row of the matrix
displayRow([]).
displayRow([Cell | Cells]) :-
    ( Cell == 0 ->
        write(' ')
    ; Cell == 1 ->
        write('X')
    ; Cell == 2 ->
        write('O')
    ),
    write(' | '),
    displayRow(Cells).

% toggle between players, to know whose turn it is
nextPlayer(1, 2).
nextPlayer(2, 1).

% number of stones each player has initially to drop
stonesLeft(1, 12).
stonesLeft(2, 12).


% drop phase of Player vs Player
dropPhase(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            write('Valid moves: '),
            write(Res),nl,
            getInput(Row,Col),
            getPiece(Board, Row, Col, Piece),
            (Piece == 0, checkDrop(Player, Board, Row, Col) ->
                putPiece(Player, Board, Row, Col, TempBoard),
                stonesLeft(Player, NumStonesLeft),
                NewNumStones is NumStonesLeft - 1,
                retract(stonesLeft(Player, _)),
                assertz(stonesLeft(Player, NewNumStones)),
                nextPlayer(Player, NextPlayer),
                dropPhase(NextPlayer, TempBoard, NewBoard)
            ;
                write('Invalid move. Please try again.\n'),
                dropPhase(Player, Board, NewBoard)
            )
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhase(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
        ).

% drop phase of Player vs Easy CPU
dropPhaseBotEasy(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            (Player == 2 ->
                botDropPhaseRandom(Player, Board, TempBoard),
                stonesLeft(Player, NumStonesLeft),
                NewNumStones is NumStonesLeft - 1,
                retract(stonesLeft(Player, _)),
                assertz(stonesLeft(Player, NewNumStones)),
                nextPlayer(Player, NextPlayer),
                dropPhaseBotEasy(NextPlayer, TempBoard, NewBoard)
            ;
                write('Valid moves: '),
                write(Res),nl,
                getInput(Row,Col),
                getPiece(Board, Row, Col, Piece),
                (Piece == 0, checkDrop(Player, Board, Row, Col) ->
                    putPiece(Player, Board, Row, Col, TempBoard),
                    stonesLeft(Player, NumStonesLeft),
                    NewNumStones is NumStonesLeft - 1,
                    retract(stonesLeft(Player, _)),
                    assertz(stonesLeft(Player, NewNumStones)),
                    nextPlayer(Player, NextPlayer),
                    %botDropPhaseRandom(NextPlayer, TempBoard, NewBoard1),
                    dropPhaseBotEasy(NextPlayer, TempBoard, NewBoard)
                ;
                    write('Invalid move. Please try again.\n'),
                    dropPhaseBotEasy(Player, Board, NewBoard)
                )
            )
            
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotEasy(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
    ).

% drop phase of Player vs Hard CPU
dropPhaseBotHard(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            (Player == 2 ->
                botDropPhaseHard(Player, Board, TempBoard),
                stonesLeft(Player, NumStonesLeft),
                NewNumStones is NumStonesLeft - 1,
                retract(stonesLeft(Player, _)),
                assertz(stonesLeft(Player, NewNumStones)),
                nextPlayer(Player, NextPlayer),
                dropPhaseBotHard(NextPlayer, TempBoard, NewBoard)
            ;
                write('Valid moves: '),
                write(Res),nl,
                getInput(Row,Col),
                getPiece(Board, Row, Col, Piece),
                (Piece == 0, checkDrop(Player, Board, Row, Col) ->
                    putPiece(Player, Board, Row, Col, TempBoard),
                    stonesLeft(Player, NumStonesLeft),
                    NewNumStones is NumStonesLeft - 1,
                    retract(stonesLeft(Player, _)),
                    assertz(stonesLeft(Player, NewNumStones)),
                    nextPlayer(Player, NextPlayer),
                    %botDropPhaseRandom(NextPlayer, TempBoard, NewBoard1),
                    dropPhaseBotHard(NextPlayer, TempBoard, NewBoard)
                ;
                    write('Invalid move. Please try again.\n'),
                    dropPhaseBotHard(Player, Board, NewBoard)
                )
            )
            
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotHard(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
    ).

% drop phase of Easy CPU vs Hard CPU
dropPhaseBotEasyHard(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            (Player == 2 ->
                botDropPhaseHard(Player, Board, TempBoard),
                stonesLeft(Player, NumStonesLeft),
                NewNumStones is NumStonesLeft - 1,
                retract(stonesLeft(Player, _)),
                assertz(stonesLeft(Player, NewNumStones)),
                nextPlayer(Player, NextPlayer),
                dropPhaseBotEasyHard(NextPlayer, TempBoard, NewBoard)
            ;
            Player == 1 ->
                botDropPhaseRandom(Player, Board, TempBoard),
                stonesLeft(Player, NumStonesLeft),
                NewNumStones is NumStonesLeft - 1,
                retract(stonesLeft(Player, _)),
                assertz(stonesLeft(Player, NewNumStones)),
                nextPlayer(Player, NextPlayer),
                dropPhaseBotEasyHard(NextPlayer, TempBoard, NewBoard)
            )
            
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotEasyHard(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
    ).

% drop phase of Easy CPU vs Easy CPU
dropPhaseBotBotEasy(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            botDropPhaseRandom(Player, Board, TempBoard),
            stonesLeft(Player, NumStonesLeft),
            NewNumStones is NumStonesLeft - 1,
            retract(stonesLeft(Player, _)),
            assertz(stonesLeft(Player, NewNumStones)),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotBotEasy(NextPlayer, TempBoard, NewBoard)
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotBotEasy(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
    ).

% drop phase of Hard CPU vs Hard CPU
dropPhaseBotBotHard(Player, Board, NewBoard) :-
    findDropAll(Player,Board,Res),
    length(Res, Len),
    write('DROP PHASE\n'),
    display_game(Board),
    stonesLeft(Player, NumStones),
    stonesLeft(1, NumStones1),
    stonesLeft(2, NumStones2),
    findDropAll(1,Board,Res1),
    findDropAll(2,Board,Res2),
    append(Res1,Res2,Res3),
    length(Res3,Len2),
    NumSum is NumStones1 + NumStones2,
    (Len2 \== 0 , NumSum \== 0 ->
        (NumStones > 0, Len > 0 ->
            botDropPhaseHard(Player, Board, TempBoard),
            stonesLeft(Player, NumStonesLeft),
            NewNumStones is NumStonesLeft - 1,
            retract(stonesLeft(Player, _)),
            assertz(stonesLeft(Player, NewNumStones)),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotBotHard(NextPlayer, TempBoard, NewBoard)
        ;
            write('No more stones can be placed. Passing turn.\n'),
            nextPlayer(Player, NextPlayer),
            dropPhaseBotBotHard(NextPlayer, Board, NewBoard)
        );
        write('No more stones can be placed. Moving to Move Phase.\n'),
        nextPlayer(Player, NextPlayer),
        NewBoard = Board
    ).

% move phase player vs Easy CPU
movePhaseBotEasy(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    valid_moves(Board,Player,Res12),
    length(Res12,Len12),
    (game_over(Board,Win) -> 
        Winner = Win;
    Len12 =< 0 ->
        write('No valid moves. Passing turn.\n'),
        nextPlayer(Player, NextPlayer),
        movePhaseBotEasy(NextPlayer, Board, NewBoard,Winner);
    (Player == 2 ->
        botMovePhaseRandom(Player, Board, TempBoard,Row,Col),
        nextPlayer(Player, NextPlayer),
        (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
            nextPlayer(Player, NextPlayer),
            botMovePhaseRandomThreeInRow(NextPlayer, TempBoard, NewNewBoard),
            movePhaseBotEasy(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotEasy(NextPlayer, TempBoard, NextBoard,Winner)
        )
    );
    valid_moves(Board,Player,Res12),
            write('Valid Moves: '),
            write(Res12),nl,
    (move(Player, Board, NewBoard,Row,Col) -> 
        (checkThreeMove(NewBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,NewBoard) ->
            write('You have made a three in a row. Remove any Opponent Stone!\n'),
            display_game(NewBoard),
            nextPlayer(Player, NextPlayer),
            removeOpponentStone(NextPlayer, NewBoard, NewNewBoard),
            movePhaseBotEasy(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotEasy(NextPlayer, NewBoard, NextBoard,Winner)
        );
        write('You are not allow to move that way. Try again\n'),
        movePhaseBotEasy(Player, Board, NewBoard,Winner)
    )).

% move phase player vs Hard CPU
movePhaseBotHard(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    valid_moves(Board,Player,Res12),
    length(Res12,Len12),
    (game_over(Board,Win) -> 
        Winner = Win;
    Len12 =< 0 ->
        write('No valid moves. Passing turn.\n'),
        nextPlayer(Player, NextPlayer),
        movePhaseBotHard(NextPlayer, Board, NewBoard,Winner);
    (Player == 2 ->
        botMovePhaseHard(Player, Board, TempBoard,Row,Col),
        nextPlayer(Player, NextPlayer),
        (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
            nextPlayer(Player, NextPlayer),
            botMovePhaseHardThreeInRow(NextPlayer, TempBoard, NewNewBoard),
            movePhaseBotHard(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotHard(NextPlayer, TempBoard, NextBoard,Winner)
        )
    );
    write('Valid Moves: '),
    write(Res12),nl,
    (move(Player, Board, NewBoard,Row,Col) -> 
        (checkThreeMove(NewBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,NewBoard) ->
            write('You have made a three in a row. Remove any Opponent Stone!\n'),
            display_game(NewBoard),
            nextPlayer(Player, NextPlayer),
            removeOpponentStone(NextPlayer, NewBoard, NewNewBoard),
            movePhaseBotHard(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotHard(NextPlayer, NewBoard, NextBoard,Winner)
        );
        write('You are not allow to move that way. Try again\n'),
        movePhaseBotHard(Player, Board, NewBoard,Winner)
    )).

% move phase Easy CPU vs Hard CPU
movePhaseBotEasyHard(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    valid_moves(Board,Player,Res12),
    length(Res12,Len12),
    (game_over(Board,Win) -> 
        Winner = Win;
    Len12 =< 0 ->
        write('No valid moves. Passing turn.\n'),
        nextPlayer(Player, NextPlayer),
        movePhaseBotEasyHard(NextPlayer, Board, NewBoard,Winner);
    (Player == 2 ->
        botMovePhaseHard(Player, Board, TempBoard,Row,Col),
        nextPlayer(Player, NextPlayer),
        (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
            nextPlayer(Player, NextPlayer),
            botMovePhaseHardThreeInRow(NextPlayer, TempBoard, NewNewBoard),
            movePhaseBotEasyHard(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotEasyHard(NextPlayer, TempBoard, NextBoard,Winner)
        )
    );
    (Player == 1 ->
        botMovePhaseRandom(Player, Board, TempBoard,Row,Col),
        nextPlayer(Player, NextPlayer),
        (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
            nextPlayer(Player, NextPlayer),
            botMovePhaseRandomThreeInRow(NextPlayer, TempBoard, NewNewBoard),
            movePhaseBotEasyHard(NextPlayer, NewNewBoard, NextBoard,Winner)
            ;
            nextPlayer(Player, NextPlayer),
            movePhaseBotEasyHard(NextPlayer, TempBoard, NextBoard,Winner)
        )
    )
    ).

% move phase Easy CPU vs Easy CPU
movePhaseBotBotEasy(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    valid_moves(Board,Player,Res12),
    length(Res12,Len12),
    (game_over(Board,Win) -> 
        Winner = Win;
    Len12 =< 0 ->
        write('You have no valid moves. You lose your turn!\n'),
        nextPlayer(Player, NextPlayer),
        movePhaseBotBotEasy(NextPlayer, Board, NewBoard,Winner);
    botMovePhaseRandom(Player, Board, TempBoard,Row,Col),
    nextPlayer(Player, NextPlayer),
    (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
        nextPlayer(Player, NextPlayer),
        botMovePhaseRandomThreeInRow(NextPlayer, TempBoard, NewNewBoard),
        movePhaseBotBotEasy(NextPlayer, NewNewBoard, NextBoard,Winner)
        ;
        nextPlayer(Player, NextPlayer),
        movePhaseBotBotEasy(NextPlayer, TempBoard, NextBoard,Winner)
    )
    ).


% move phase Hard CPU vs Hard CPU
movePhaseBotBotHard(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    valid_moves(Board,Player,Res12),
    length(Res12,Len12),
    (game_over(Board,Win) -> 
        Winner = Win;
    Len12 =< 0 ->
        write('You have no valid moves. You lose your turn!\n'),
        nextPlayer(Player, NextPlayer),
        movePhaseBotBotHard(NextPlayer, Board, NewBoard,Winner);
    botMovePhaseHard(Player, Board, TempBoard,Row,Col),
    nextPlayer(Player, NextPlayer),
    (checkThreeMove(TempBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,TempBoard) ->
        nextPlayer(Player, NextPlayer),
        botMovePhaseHardThreeInRow(NextPlayer, TempBoard, NewNewBoard),
        movePhaseBotBotHard(NextPlayer, NewNewBoard, NextBoard,Winner)
        ;
        nextPlayer(Player, NextPlayer),
        movePhaseBotBotHard(NextPlayer, TempBoard, NextBoard,Winner)
    )
    ).

% move phase Player vs Player
movePhase(Player, Board, NewBoard,Winner) :-
    write('MOVE PHASE\n'),
    display_game(Board),
    numStones(Board,1,NumStones1),
    numStones(Board,2,NumStones2),
    (game_over(Board,Win) -> 
        Winner = Win;
    valid_moves(Board,Player,Res12),
        write('Valid Moves: '),
        write(Res12),nl,
        length(Res12,Len12),
    (Len12 == 0 ->
        write('You have no valid moves. You lose your turn!\n'),
        nextPlayer(Player, NextPlayer),
        movePhase(NextPlayer, Board, NewBoard,Winner);
    
    (move(Player, Board, NewBoard,Row,Col) -> 
        (checkThreeMove(NewBoard,Player,Row,Col), checkThreeFail(Board,Player,Row,Col,NewBoard)  ->
            write('You have made a three in a row. Remove any Opponent Stone!\n'),
            display_game(NewBoard),
            nextPlayer(Player, NextPlayer),
            removeOpponentStone(NextPlayer, NewBoard, NewNewBoard),
            movePhase(NextPlayer, NewNewBoard, NextBoard,Winner);
            nextPlayer(Player, NextPlayer),
            movePhase(NextPlayer, NewBoard, NextBoard,Winner)
        );
        write('You are not allow to move that way. Try again\n'),
        movePhase(Player, Board, NewBoard,Winner)
    ))).

%play predicate play/0
play :-
    initBoard(L),
    retract(stonesLeft(1, _)),
    assertz(stonesLeft(1, 12)),
    retract(stonesLeft(2, _)),
    assertz(stonesLeft(2, 12)),
    initialMenu(Choice),
    (Choice \== 1 ->
        difficultyMenu(Difficulty),
        (Difficulty \== 4 ->
            play(L,Choice,Difficulty,1)
        ;
            play
        )
    ;
    play(L,Choice,-1,1)
    ).
    
% play predicate for player vs player
play(Board,1,-1, Player) :-
    dropPhase(Player, Board, TempBoard),
    movePhase(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

% play predicate for player vs easy bot
play(Board,2,1, Player) :-
    dropPhaseBotEasy(Player, Board, TempBoard),
    movePhaseBotEasy(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

% play predicate for player vs hard bot
play(Board,2,2, Player) :-
    dropPhaseBotHard(Player, Board, TempBoard),
    movePhaseBotHard(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

% play predicate for easy bot vs easy bot
play(Board,3,1, Player) :-
    dropPhaseBotBotEasy(Player, Board, TempBoard),
    movePhaseBotBotEasy(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

% play predicate for hard bot vs hard bot
play(Board,3,2, Player) :-
    dropPhaseBotBotHard(Player, Board, TempBoard),
    %dropPhaseBotBotEasy(Player, Board, TempBoard),
    movePhaseBotBotHard(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

% play predicate for hard bot vs easy bot
play(Board,3,3, Player) :-
    dropPhaseBotEasyHard(Player, Board, TempBoard),
    movePhaseBotEasyHard(1, TempBoard,NewBoard,Winner),
    write('Winner is : '),nl,
    write(Winner),nl.

test :- initBoard(L),
        game_over(L,1,Res),
        write(Res).

% retrieves a col of the matrix based on its index
findCol([], _, []).
findCol([Row|Rows], ColNum, [Elem|Elems]) :-
                                            nth1(ColNum, Row, Elem),
                                            findCol(Rows, ColNum, Elems).

% retrieves a row of the matrix based on its index
findRow(Board, RowNum, Res) :- nth1(RowNum, Board, Res).