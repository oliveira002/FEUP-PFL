:- use_module(library(lists)).

jogo(1, sporting, porto, 1-2). 
jogo(1, maritimo, benfica, 2-0). 
jogo(2, sporting, benfica, 0-2). 
jogo(2, porto, maritimo, 1-0). 
jogo(3, maritimo, sporting, 1-1).
jogo(3, benfica, porto, 8-2).
treinadores(porto, [[1-3]-sergio_conceicao]).
treinadores(sporting, [[1-2]-silas, [3-3]-ruben_amorim]). 
treinadores(benfica, [[1-3]-bruno_lage]).
treinadores(maritimo, [[1-3]-jose_gomes]).

n_treinadores(Equipa,Nr) :- treinadores(Equipa,X),
                            length(X,Nr).


aux1(Treinador,[[S-F]-Treinador | XS],[S-F]).
aux1(Treinador,[[S-F]-Random | XS], YS) :- aux1(Treinador,XS,YS).



n_jornadas_treinador(Treinador,Nr) :- treinadores(_,Y),
                                      aux1(Treinador,Y,[S-F]),
                                      T is F - S + 1,
                                      T == Nr.

ganhou(Jornada,Vencedor,Derrotado) :- jogo(Jornada,Vencedor,Derrotado,A-B),
                                      A > B.

ganhou(Jornada,Vencedor,Derrotado) :- jogo(Jornada,Derrotado,Vencedor,A-B),
                                      B > A.



% chamar para fim + 1
aux2(Equipa,X,X).
aux2(Equipa,Inicio,Fim) :- ganhou(Inicio,Equipa,Z),
                           Nxt is Inicio + 1,
                           aux2(Equipa,Nxt,Fim).


treinador_bom(Treinador) :- treinadores(X,Y),
                            aux1(Treinador,Y,[S-F]),
                            N is F + 1,
                            aux2(X,S,N).

imprime_totobola(1, '1').

imprime_totobola(0, 'X').

imprime_totobola(-1, '2').

imprime_texto(X,'vitoria da casa'):-
                                    X = 1.
imprime_texto(X,'empate'):-
                                    X = 0.
imprime_texto(X,'derrota da casa'):-
                                    X = -1.



imprime_linha(Num,E1,E2,G1-G2,F) :- write('Jornada '),
                                  write(Num),
                                  write(': '),
                                  write(E1),
                                  write(' X '),
                                  write(E2),
                                  write(' - '),
                                  imprime_ganhou(E1,E2,G1-G2, WIN),
                                  X =.. [F,WIN,Y],X,
                                  write(Y).


imprime_ganhou(E1,E2,G1-G2, WIN) :- (G1 > G2 -> WIN = 1);
                                    (G1 < G2 -> WIN = -1);
                                    (G1 == G2 -> WIN = 0).



imprime_jogos(F) :- jogo(Num,Equipa1,Equipa2,G1-G2),
                    imprime_linha(Num,Equipa1,Equipa2,G1-G2,F),nl,
                    fail.


imprime_jogos(_).




lista_treinadores(L) :- findall(Treinador,(treinadores(_,Todos),aux1(Treinador,Todos,X)),L). 

duracao_treinadores(L) :- findall(Tot-Treinador,(treinadores(_,Todos),aux1(Treinador,Todos,[F-S]),Tot is S- F +1),List),
                          sort(List,New),
                          reverse(New,L).