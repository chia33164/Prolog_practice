% filename: problem1.pl

% prime must be
% 1. integer
% 2. larger than 2 (except 2)
% 3. has no factors

isPrime(2).
isPrime(N) :- integer(N), N > 2, not(canDiv(N,2)).

% how to know the number has factors?
% if any x that number mod x == 0, x from 2 to x*x < number

canDiv(N,X) :- N mod X =:= 0, !.
canDiv(N,X) :- X * X < N, Y is X + 1, canDiv(N,Y).

% check the two numbers are prime or not
pap(P,Q) :- isPrime(P), isPrime(Q), !.

print(H,T) :- write('\n'), write(H), write(" "), write(T).

% if P > Q then do nothing because of duplicating value,
% else check both numbers are prime or not 
% if yes print both and find next
% if no find next

goldbach(4, 3) :- write('\n'), write('2 2').
goldbach(N, P) :- N mod 2 =:= 0, N > 4, Q is N - P, Q >= P -> (pap(P,Q) -> print(P, Q), P1 is P + 2, goldbach(N, P1) ; P1 is P + 2, goldbach(N,P1)), !.

:- write('Input: '), read(X) , write('Output: '), goldbach(X, 3), halt, !.