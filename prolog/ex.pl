:- dynamic round/4.

% round(RoundNumber, DanceStyle, Minutes, [Dancer1-Dancer2 | DancerPairs])
% round/4 indica, para cada ronda, o estilo de dança, a sua duração, e os pares de dançarinos participantes.
round(1, waltz, 8, [eugene-fernanda]).
round(2, quickstep, 4, [asdrubal-bruna,cathy-dennis,eugene-fernanda]).
round(3, foxtrot, 6, [bruna-dennis,eugene-fernanda]).
round(4, samba, 4, [cathy-asdrubal,bruna-dennis,eugene-fernanda]).
round(5, rhumba, 5, [bruna-asdrubal,eugene-fernanda]).

% tempo(DanceStyle, Speed).
% tempo/2 indica a velocidade de cada estilo de dança.
tempo(waltz, slow).
tempo(quickstep, fast).
tempo(foxtrot, slow).
tempo(samba, fast).
tempo(rhumba, slow).


% 1
style_round_number(DanceStyle, RoundNumber) :- round(RoundNumber,DanceStyle,_,_).


% 2
n_dancers(Round, NDancers) :- round(Round,_,_,X),
                              length(X,Size),
                              NDancers is Size * 2.


% 3
aux([P1-P2 | T], P1).
aux([P1-P2 | T], P2).
aux([P1-P2 | T], Dancer) :- aux(T,Dancer).

danced_in_round(RoundNumber, Dancer) :- round(RoundNumber,_,_,Lista),
                                        aux(Lista,Dancer).


% 4


aux2(Acc,Res) :- round(X,_,_,_),
                 \+member(X,Acc),
                 NewAcc = [X | Acc],
                 !,
                 aux2(NewAcc,Res).

aux2(R,R).

n_rounds(NRounds) :- aux2([],[NRounds | T]).
                     


% 5
add_dancer_pair(RoundNumber, Dancer1, Dancer2) :- 
                                                  round(RoundNumber,_,_,_),
                                                  \+danced_in_round(RoundNumber,Dancer1),
                                                   \+danced_in_round(RoundNumber,Dancer2),
                                                  retract(round(RoundNumber,X,Y,Old)),
                                                  assertz(round(RoundNumber,X,Y,[Dancer1-Dancer2 | Old])).


% 6
aux3(Dancer,Acc,Res) :- round(ID,_,Dur,_),
                        danced_in_round(ID,Dancer),
                        \+member(ID-Dur,Acc),
                        NewAcc = [ID-Dur | Acc],
                        !,
                        aux3(Dancer,NewAcc,Res).

aux3(Dancer,R,R).

sumLista([],0).
sumLista([ID-Dur | T],Res) :- sumLista(T,R2),
                              Res is R2 + Dur.

total_dance_time(Dancer, Time) :- aux3(Dancer,[],Lista),
                                  sumLista(Lista,Time).


% 7
print_program :- round(Id,Style,Dur,Dancers),
                 write(Style),
                 write(' ('),
                 write(Dur),
                 write(') '),
                 write('- '),
                 length(Dancers,X),
                 write(X),nl,
                 fail.
print_program.


% 8
dancer_n_dances(Dancer, NDances) :- findall(Dancer-Id,round(Id,_,_,_),danced_in_round(Id,Dancer),Res),
                                    length(Res,NDances).


% 9
:- use_module(library(lists)).

most_tireless_dancer(Tireless) :- setof(Time-Dancer,Round^(danced_in_round(Round,Dancer),total_dance_time(Dancer, Time)),Res),
                                  sort(Res,Sortado),
                                  reverse(Sortado,[Tempo-Guy | T]),
                                  Tireless = Guy.


% "2nd part"
predX([],0).
predX([X|Xs],N):-
    X =.. [_|T],
    length(T,2),
    !,
    predX(Xs,N1),
    N is N1 + 1.
predX([_|Xs],N):-
    predX(Xs,N).

% 10
% 11
% 12
% 13

% "3rd part"

% 14
% 15

% "4th part"

% 16
shortest_safe_path(Origin, Destination, ProhibitedNodes, Path) :- true. % TODO


% 17
all_shortest_safe_paths(Origin, Destination, ProhibitedNodes, ListOfPaths) :- true. % TODO