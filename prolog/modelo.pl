%participant(id, Age, Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,120,120]).
performance(8937,[97,101,105,110]).

madeit(Guy) :- performance(Guy,List),
               member(120,List).


%aux(Guy,Juri)

aux2([H | T], 1, H).
aux2([H| T], Juri, Tempo) :- Oi is Juri - 1,
                             aux2(T,Oi, Tempo).

juriTimes([],_,[],0). 
juriTimes([Guy | Guys],Juri,Times,Total) :- juriTimes(Guys,Juri,Tmp,T2),
                                            performance(Guy,Lista),
                                            aux2(Lista,Juri,Time),
                                            Total is T2 + Time,
                                            Times = [Time | Tmp].



patientJuri(Juri) :- performance(A,X),
                     performance(B,Y),
                     A \== B,
                     aux2(X,Juri,Tempo),
                     aux2(Y,Juri,Tempo2),
                     Tempo == 120,
                     Tempo2 == 120.

sumTimes([],0).
sumTimes([H | T],Res) :- sumTimes(T,R2),
                         Res is R2 + H.


bPart(P1,P2,Z) :- performance(P1,X),
                  performance(P2,Y),
                  sumTimes(X,R1),
                  sumTimes(Y,R2),
                  ((R1 > R2 -> Z is P1);
                  (R2 > R1 -> Z is P2);
                  (R1 == R2 -> fail)).

allPerfs :- participant(X,_,Nome),
            performance(X,Lista),
            write(X),write(':'),
            write(Nome),nl,
            fail.

allPerfs.


aux4(_,5,[]).

aux4([120 | T],Idx,Res) :- Nxt is Idx + 1, 
                            aux4(T,Nxt,R),
                            Res = [Idx | R],
                            !. % para dar so 1 solucao
                                    
aux4([H | T],Idx,Res) :- Nxt is Idx + 1, 
                        aux4(T,Nxt,Res).
                             
                         

nSUC(T) :- findall(Res,(performance(_,Todos),sumTimes(Todos,Res),Res == 480),Lista),
           write(Lista),
           length(Lista,T).


juriFans(L) :- findall(Guy-Juris,(performance(Guy,Todos),aux4(Todos,1,Juris)),Lista),
               L = Lista.

:- use_module(library(lists)).

eligibleOutcome(Id, Perf, TT) :-
                performance(Id, Times),
                madeit(Id),
                participant(Id, _, Perf),
                sumlist(Times, TT).

nextPhase(N,Participants) :- setof(TT-Id-Perf, Age^(participant(Id,Age,Perf), eligibleOutcome(Id,Perf,TT)),Res),
                             length(Participants,N),
                             append(Participants,_,Res).
