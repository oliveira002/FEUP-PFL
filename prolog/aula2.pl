% 1

fatorial(1,1).
fatorial(N, F) :- S is N - 1,
                  fatorial(S,R1),
                  F is S * N.


somaRec(1,1).
somaRec(N,Sum) :- S is N - 1,
                  somaRec(S,R1),
                  Sum is N + R1.


fib(0,0).
fib(1,1).
fib(N,F) :- N1 is N-1,
            N2 is N-2,
            fib(N1,R1),
            fib(N2,R2),
            F is R1 + R2.



%d
divisible(X,Y) :- 0 is X mod Y.
divisible(X,Y) :- Y < X - 1,
                  Y1 is Y+1,
                  divisible(X, Y1).

isPrime(2).
isPrime(X) :- X > 1, 
              \+divisible(X, 2).


%5 lists

list_size([],0).
list_size([X | XS], Size) :- list_size(XS,S1),
                             Size is 1 + S1.


list_sum([],0).
list_sum([X | XS], R) :- list_sum(XS,R1),
                         R is X + R1.

list_prod([],1).
list_prod([X | XS], R) :- list_sum(XS,R1),
                         R is X * R1.

inner_product([],[],0).
inner_product([X | XS], [Y | YS], R) :- inner_product(XS,YS,R1),
                                         R is (X*Y) + R1.

count(_,[],0).
count(N, [X |XS], R) :- count(N,XS,R1),
                        (N == X -> R is 1 + R1 ; R is 0 + R1).


%6
aux([],F,F).
aux([X | XS],Acc,F) :- aux(XS,[X | Acc],F).

invert(XS,F) :- aux(XS,[],F).

del_one(X, [X | XS], XS).
del_one(N,[X | XS],L2) :-
                         del_one(N,XS,R1),
                         L2 = [X | R1].


del_all(_, [], []).
del_all(X, [X | XS], F) :- del_all(X, XS,F).
del_all(N, [X | XS], F) :- N \= X,
                           del_all(N,XS,F1),
                           F = [X | F1].


del_all_list([],L,L).
del_all_list([X|XS], L2, R) :- del_all(X,L2,R2),
                               del_all_list(XS,R2,R).

del_dups([],[]).
del_dups([X | XS],R) :- del_all(X,XS,R2),
                        del_dups(R2,R3),
                        R = [X | R3].


replicate(0,_,[]).
replicate(CT,X,[X | XS]) :- CT2 is CT - 1,
                            replicate(CT2,X,XS).

intersperse(_,[X],[X]).
intersperse(E,[X | XS],[X,E | YS]) :- intersperse(E,XS,YS).

insert_elem(0,XS,Elem,[Elem | XS]).
insert_elem(IDX, [X | XS], Elem, [X | YS]) :- IDX2 is IDX - 1,
                                              insert_elem(IDX2,XS,Elem,YS).

del_elem(0,[X |XS],X,XS).
del_elem(IDX,[X | XS], Elem, [X | YS]) :- IDX2 is IDX - 1,
                                          del_elem(IDX2,XS,Elem,YS).

replace(XS,IDX,OLD,NEW,YS) :- del_elem(IDX,XS,OLD,Y2),
                              insert_elem(IDX,Y2,NEW,YS).

%7
list_append([],X,X).
list_append(X,[],X).
list_append([X | XS], YS, [X | ZS]) :- list_append(XS,YS,ZS).

list_member(Elem, XS) :- list_append(_, [Elem | _],XS).

list_last(XS,Last) :- list_append(_,[Last],XS).

list_nth(N,List,Elem):- list_append(_Inicio,[Elem|_Fim],List),  
                        write(_Inicio),
                        length(_Inicio,N).

auxappend([],Acc,Acc).
auxappend([X | XS],Acc,YS) :- list_append(Acc,X,R),
                              auxappend(XS,R,YS).

list2_append(XS,YS) :- auxappend(XS,[],YS).



