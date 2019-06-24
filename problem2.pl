% filename: problem2.pl

isAncestor(X, Y) :- isParent(X, Y).
isAncestor(X, Y) :- isParent(M, Y), isAncestor(X, M).

common(X, Y) :- X =:= Y -> write(X).
common(X, Y) :- isAncestor(X, Y) -> write(X).
common(X, Y) :- isParent(A, X), common(A, Y).

loop1(T) :- T =:= 1, !.
loop1(T) :- T > 1, read(A), read(B), assert(isParent(A, B)), T1 is T - 1, loop1(T1).

loop2(M) :- M =:= 0, !.
loop2(M) :- M > 0, read(X), read(Y), common(X, Y), nl, M1 is M - 1 ,loop2(M1).

:- read(T), loop1(T), read(M), loop2(M), !.