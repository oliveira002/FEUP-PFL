:- dynamic played/4.

%player(Name, Username, Age)
player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Manny', 'The Player', 14).
player('Jonny', 'A Player', 16).

%game(Name, Categories, MinAge)
game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16).
game('Duas Botas', [action, free, strategy, moba], 12).

%played(Player, Game, HoursPlayed, PercentUnlocked)
played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player', 'Carrier Shift: Game Over', 48, 24).
played('A-Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 33, 22).


achievedALot(Player) :- played(Player,_,_,X),
                        X >= 80.

isAgeAppropriate(Name,Game) :- player(Name,_,Age),
                               game(Game,_,Min),
                               Age > Min.


timePlayingGames(_,[],[],0).
timePlayingGames(Player,[H | T],[Time | Rest],SumTimes) :- timePlayingGames(Player,T,Rest,R2),  
                                                           played(Player,H,Time,_),
                                                           SumTimes is R2 + Time.


listCat(Cat) :- game(Name,Lista,Min),
                member(Cat,Lista),
                write(Name),
                write(' '),
                write('('),
                write(Min),
                write(')'),nl,
                fail.

listCat(_).

updatePlayer(Player,Game,Hours,Percentage) :- retract(played(Player,Game,OldH,OldP)),
                                              FH is Hours + OldH,
                                              FP is OldP + Percentage,
                                              assertz(played(Player,Game,FH,FP)).

updatePlayer(Player,Game,Hours,Percentage) :- assertz(played(Player,Game,Hours,Percentage)).


aux(Player,Acc,Res) :- played(Player,Game,Hours,Percentage),
                       Hours < 10,
                       \+member(Game,Acc),
                       New = [Game | Acc],
                       !,
                       aux(Player,New,Res).
aux(Player,Acc,Acc).

fewHours(Player,Games) :- aux(Player,[],Games).



aux2(Min,Max,Acc,Res) :- player(Person,_,Age),
                        Age >= Min,
                        Age =< Max,
                        \+member(Person,Acc),
                        New = [Person | Acc],
                        !,
                        aux2(Min,Max,New,Res).

aux2(_,_,Res,Res).

ageRange(Min,Max,Players) :- aux2(Min, Max,[],Players).

aux3(Game,Acc,Res) :- player(_,Nick,Age),
                      played(Nick,Game,_,_),
                      \+member(Nick-Age,Acc),
                      New = [Nick-Age | Acc],
                      !,
                      aux3(Game,New,Res).
aux3(Game,Res,Res).

calAvg([],0).
calAvg([_-Age | T],X) :- calAvg(T,Y),
                         X is Y + Age.

avgAge(Game,Avg) :- aux3(Game,[],Lista),
                    length(Lista,Div),
                    calAvg(Lista,Res),
                    Avg is Res / Div.

:- use_module(library(lists)).

age2(Min,Max,Players) :- findall(Person,(player(Person,_,Age), Age >= Min, Age =< Max),Players).

ageAvg(Game,Avg) :- findall(Age,(player(_,Nick,Age), played(Nick,Game,_,_)),Lista),
                    length(Lista,X),
                    sumlist(Lista,Res),
                    Avg is Res / X.

getMax([Max-Nick | T],Max,[Nick | T2]) :- getMax(T,Max,T2),!.
getMax([H-Nick | T],Max,X) :- getMax(T,Max,X),!.
getMax([],Max,[]).

mostEffective(Game,Players) :- setof(Conta-Nick,((Game,Horas,Percentage)^(played(Nick,Game,Horas,Percentage), Conta is Percentage / Horas)),Lista),
                               Lista = [Maxi-Nick | T],
                               getMax(Lista,Maxi,Players).
