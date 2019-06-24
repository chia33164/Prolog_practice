% filename: problem3.pl

graph(X, Y, L) :- edge(X, A), not(member(A, L))-> graph(A, Y, [A|L]).
graph(X, Y, L) :- member(Y, L).

isReachable(X, Y) :- graph(X, Y, []) -> write('Yes'), !.
isReachable(X, Y) :- write('No'), !.

loop1(E) :- E =:= 0, !.
loop1(E) :- E > 0, read(X), read(Y), assert(edge(X, Y)), assert(edge(Y, X)), E1 is E - 1, loop1(E1). 

loop2(M) :- M =:= 0, !.
loop2(M) :- M > 0, read(X), read(Y), isReachable(X, Y) , nl, M1 is M - 1, loop2(M1).


:- read(N), read(E), loop1(E), read(M), loop2(M), !.