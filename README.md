# Prolog Practice

## Envirenment
    Ubuntu 18.04 LTS

## Install prolog
```
$ sudo apt-get install swi-prolog
```

### problem 1 - Goldbach's conjecture

定義 factor isPrime(2) 代表 2 是質數
接著一個數值要是質數要符合三個條件
1.	整數
2.	必須比2大 ( 2 是最小的質數也是唯一的偶數且在 factor 已經定義 )
3.	只能被 1 和 自己整除
因此設定 clause :

```
isPrime(N) :- integer(N), N > 2, not(canDiv(N,2)).
```

其中 canDiv 用來判斷該數是否能夠被除了 1 和 自己的整數整除
定義成

```
canDiv(N,X) :- N mod X =:= 0, !.
canDiv(N,X) :- X * X < N, Y is X + 1, canDiv(N,Y).
```

根據尋找是否為質數的定義得知，從 2 到 x 的連續整數中
看有沒有能夠整除的數
若有，就不是質數
若無，就是質數
其中x 為 x * x < N 的最大值

主判斷式 :

```
goldbach(4, 3) :- write('2 2').
goldbach(N, P) :- N mod 2 =:= 0, N > 4, Q is N - P, Q >= P -> (pap(P,Q) -> print(P, Q), P1 is P + 2, goldbach(N, P1) ; P1 is P + 2, goldbach(N,P1)), !.
```

先設定 factor ，因為最小符合 goldbach ‘s conjecture 的組合為 4 [2 2] 且因為除了4 之外，
不會有其他的組合出現 2 ，因此後面我都是從 3 開始找 （3 為最小的奇數質數）
符合  goldbach ‘s conjecture  必須符合以下條件
1.	該數為偶數
2.	該數要大於 4 ( 因為 4 已經定義在 factor 中，因此接下來的例子都要比他大 )
3.	該數等於兩個質數的合

根據以上條件設定 clause :

```
goldbach(N, P) :- N mod 2 =:= 0, N > 4, Q is N - P, Q >= P -> (pap(P,Q) -> print(P, Q), P1 is P + 2, goldbach(N, P1) ; P1 is P + 2, goldbach(N,P1)), !.
```

goldbach 中，N 為指定的數
其中 Q = N – P ( 這樣確保 P + Q == N )
然後看 Q 和 P 是否為質數

其中的 pap 是用來判斷兩個數字是否都是質數
定義成

```
pap(P,Q) :- isPrime(P), isPrime(Q), !.
```

都符合的話就印出 P Q 並 P = P + 2 繼續迴圈 
否則就不印出，但 P = P + 2 繼續迴圈 
( P + 2 的原因是這樣能讓 P 保持奇數，因為除了 2 以外的質數都是奇數，因此會比較好找到質數 )
( 兩個結果都要繼續迴圈是為了把每個答案都找出來 )


呼叫 :

```
:- write('Input: '), read(X) , write('Output: '), goldbach(X, 3), !.
```

這邊的 goldbach(X, 3) 就是前面說到的從 3 開始找

**Commend line**

```
$ swipl problem1.pl

4.
```

### problem 2 - Lowest Common Ancestor

主程式 :

```
:- read(T), loop1(T), read(M), loop2(M), !.
```

先 read 有幾個(T) parent-child 關係，接著讓 loop1 跑 T 次
再 read 有幾組(M) node 要找 Lowest Common Ancestor，接著讓 loop2 跑 M 次

loop1 : 

```
loop1(T) :- T =:= 1, !.
loop1(T) :- T > 1, read(A), read(B), assert(isParent(A, B)), T1 is T - 1, loop1(T1).
```

讓 loop1 重複跑 T 次
每次都先 read 兩個數 A, B
這代表 A 是 B 的 parent
因此設定 factor :

```
isParent(A, B)
```

loop2 : 

```
loop2(M) :- M =:= 0, !.
loop2(M) :- M > 0, read(X), read(Y), common(X, Y), nl, M1 is M - 1 ,loop2(M1).
```

讓 loop2 重複跑 M 次
每次都先 read 兩個數 X, Y
這代表要尋找 X, Y 兩個 node 的  Lowest Common Ancestor
因此呼叫 common(X, Y)

```
common(X, Y ) :
common(X, Y) :- X =:= Y -> write(X).
common(X, Y) :- isAncestor(X, Y) -> write(X).
common(X, Y) :- isParent(A, X), common(A, Y).
```

第一條
	若 X == Y，那他們的 Lowest Common Ancestor 就是自己
第二條
	若 X 就是 Y 的 Ancestor，那 Lowest Common Ancestor 就是 X
第三條
	若以上兩條都不符合，就直接用 X 的 parent 取代 X，就是變成
	找 X 的 parent 和 Y 的 Lowest Common Ancestor 
	( 這是因為X 的 parent 和 Y 的 Lowest Common Ancestor 與 X 和 Y 的  Lowest Common Ancestor 相同 )
	直到找到符合上面兩條的其中一條才停止，停止時也會印出  Lowest Common Ancestor

其中 isAncestor :

```
isAncestor(X, Y) :- isParent(X, Y).
isAncestor(X, Y) :- isParent(M, Y), isAncestor(X, M).
```

只要 X 是 Y 的 parent，也就代表 X 是 Y 的 ancestor
第二條是用遞移關係來確認 ancestor 的關係
ex : M 是  Y 的 parent， X 是 M 的 ancestor，推出 X 是 Y 的 ancestor

**Commend line**

```
$ swipl problem2.pl

6.
1. 2.
2. 3.
1. 4.
4. 5.
4. 6.
3.
3. 4.
5. 6.
1. 2.
```


### problem 3 - Reachable

主程式:

```
:- read(N), read(E), loop1(E), read(M), loop2(M), !.
```

先 read 有幾個(N) node 再 read 有幾個(E) edge 關係，接著讓 loop1 跑 E 次
再 read 有幾組(M) node 要判斷是否可相連，接著讓 loop2 跑 M 次


loop1:

```
loop1(E) :- E =:= 0, !.
loop1(E) :- E > 0, read(X), read(Y), assert(edge(X, Y)), assert(edge(Y, X)), E1 is E - 1, loop1(E1).
```

讓 loop1 重複跑 E 次
每次都先 read 兩個數 X, Y
這代表 X, Y 擁有互通的 edge
因此設定 factor :
edge(X, Y)
edge(Y, X)

loop2:

```
loop2(M) :- M =:= 0, !.
loop2(M) :- M > 0, read(X), read(Y), isReachable(X, Y) , nl, M1 is M - 1, loop2(M1).
```

讓 loop2 重複跑 M 次
每次都先 read 兩個數 X, Y
這代表要判斷 X, Y 兩個 node 是否可相通
因此呼叫 isReachable(X, Y)

isReachable :

```
isReachable(X, Y) :- graph(X, Y, []) -> write('Yes'), !.
isReachable(X, Y) :- write('No'), !.
```

這邊要先解釋 graph(X, Y, [])
graph :

```
graph(X, Y, L) :- edge(X, A), not(member(A, L))-> graph(A, Y, [A|L]).
graph(X, Y, L) :- member(Y, L).
```

要看放入的 X, Y 是否相連的話
只要先把可以和 X 相連的所有 node 放進 list 中
最後再看 Y 有沒有在 list 中即可
因此 graph 就是將所有和 X 相通的 node 都放進 list 中
且 list 中不會有重複的 element
若遇到重複的 element 代表已經找到全部和 X 相通得 node
因此就可以判斷 Y 是否在 list 中
若有，對應到 isReachable 就會印出 Yes
否則就會印出 No

**Commend line**

```
$ swipl problem3.pl
6. 6.
1. 2.
2. 3.
3. 1.
4. 5.
5. 6.
6. 4.
2.
1. 3.
1. 5.
```