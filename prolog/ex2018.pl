%airport (Name, ICAO, Country).
airport('Aeroporto Francisco Sá Carneiro', 'LPPR', 'Portugal').
airport('Aeroporto Humberto Delgado', 'LPPT', 'Portugal').
airport('Aeropuerto Adolfo Suárez Madrid-Barajas', 'LEMD', 'Spain').
airport('Aéroport de Paris-Charles-de-Gaulle Roissy Airport', 'LFPG', 'France').
airport('Aeroporto Internazionale di Roma-Fiumicino Leonardo da Vinci', 'LIRF', 'Italy').

%company (ICAO, Name, Year, Country).
company('TAP', 'TAP Air Portugal', 1945, 'Portugal').
company('RYR', 'Ryanair', 1984, 'Ireland').
company('AFR', 'Société Air France, S.A.', 1933, 'France'). 
company('BAW', 'British Airways', 1974, 'United Kingdom').

%flight (Designation, Origin, Destination, DepartureTime, Duration, Company).
flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
flight('TP1968', 'LPPT', 'LPPR', 2235, 55, 'TAP').
flight('TP842', 'LPPT', 'LIRF', 1450, 195, 'TAP').
flight('TP843', 'LIRF', 'LPPT', 1935, 195, 'TAP').
flight('FR5483', 'LPPR', 'LEMD', 630, 105, 'RYR').
flight('FR5484', 'LEMD', 'LP PR', 1935, 105, 'RYR').
flight('AF1024', 'LFPG', 'LPPT', 940, 155, 'AFR').
flight('AF1025', 'LPPT', 'LFPG', 1310, 155, 'AFR').


% 1
% short('TP842').
% short('TP1923').

short(Flight) :- flight(Flight,_,_,_,Dur,_),
                 Dur < 90.  % TODO


% 2
% shorter('TP842', 'TP1923', Shorter).
% shorter('TP843', 'TP842', Shorter).

shorter(Flight1, Flight2, ShorterFlight) :- flight(Flight1,_,_,_,Dur,_),
                                            flight(Flight2,_,_,_,Dur2,_),
                                            ((Dur < Dur2 -> ShorterFlight = Flight1);
                                            (Dur > Dur2 -> ShorterFlight = Flight2);
                                            (Dur == Dur2 -> fail)).


% 3
% arrivalTime('TP1923', Arrival).
% arrivalTime('TP843', Arrival).

arrivalTime(Flight, ArrivalTime) :- flight(Flight,_,_,Start,Dur,_),
                                    Min is Start mod 100,
                                    H is Start div 100,
                                    SumH is Dur div 60,
                                    SumM is Dur mod 60,
                                    LastH is H + SumH,
                                    LastM is Min + SumM,
                                    FM is LastM mod 60,
                                    FSH is LastM div 60,        
                                    ResH is LastH + FSH,
                                    (ResH > 24 -> X is ResH mod 24; X is ResH),
                                    ArrivalTime is X * 100 + FM.
                                    


% 4
% countries('TAP', List).
% countries('AAL', List).

aux(Brand,Country) :- flight(_,ST,END,_,_,Brand),
                      airport(_,ST,X),
                      airport(_,END,Y),
                      (
                      X == Country;
                      Y == Country).


countriesAux(Company,Acc,Res) :- airport(_,_,Country),
                                 aux(Company,Country),
                                 \+ member(Country, Acc),
                                 X = [Country | Acc],
                                 !,
                                 countriesAux(Company,X,Res).

countriesAux(_,L,L).

countries(Company, List) :- countriesAux(Company,[],List).



% 5
%pairableFlights.

hourToMinute(Hora,Res) :- H is Hora div 100,
                          M is Hora mod 100,
                          Res is H*60 + M.
 
hourDiff(H1,H2,Res) :- hourToMinute(H1,R1),
                   hourToMinute(H2,R2),
                   ((R1 > R2 -> Res is R1-R2);
                   (R1 < R2 -> Res is R2-R1)).    

pairableFlights :- flight(F1,_,Air,_,_,_),
                   flight(F2,Air,_,H2,_,_),
                   F1 \== F2,
                   arrivalTime(F1,H1),
                   hourDiff(H2,H1,R),
                   R >= 30,
                   R =< 90,
                   write(Air),
                   write(' - '),
                   write(F1),
                   write(' \\ '),
                   write(F2),
                   nl,
                   fail.

pairableFlights.
            

                   


% 6


                                            
% 7
% avgFlightLengthFromAirport('LPPR', Avg) :- true. % TODO
:-use_module(library(lists)).

somar([],0).
somar([H | T], Res) :- somar(T,X),
                       Res is H + X.
avgFlightLengthFromAirport(Airport, AvgLength) :- findall(Time,Airport^(flight(_,Airport,_,_,Time,_)),List),
                                                  somar(List,X),
                                                  length(List,Z),
                                                  AvgLength is X / Z.


% 8
%mostInternational(Companies).

findMax([],-1).
findMax([H | T], Res) :- findMax(T,R2),
                         (H > R2 -> Res is H; Res is R2).

mostInternational(ListOfCompanies) :- 
                                      findall(Nr,(company(X,_,_,_),countries(X,Paises),length(Paises,Nr)),Lista),
                                      findMax(Lista,Z),
                                      findall(W,(company(W,_,_,_),countries(W,Paises2),length(Paises2,Nr2),Nr2 == Z),Lista2),
                                      ListOfCompanies = Lista2.


% 9

%:- use_module (library (lists)).

make_pairs(L, P, [X-Y|Zs]) :-
    select(X, L, L2),
    select(Y, L2, L3),
    G =.. [P, X, Y], G,
    !,
    make_pairs(L3, P, Zs).

make_pairs([], _, []).

dif_max_2(X, Y) :- X < Y, X >= Y-2.

make_pairs_order(L, P, [X-Y|Zs]) :- true. % TODO


% 10

make_pairs_size(L, P, [X-Y|Zs]) :- true. % TODO


% 11
% make_max_pairs([1,3,4,5,2,6], dif_max_2, S).

make_max_pairs(L, P, S) :- true. % TODO


% 12
% whitoff(3, L).
% whitoff(7, L).
% whitoff(10, L).

whitoff(N, W) :- true. % TODO