# Generating Candidates for the Busy Beaver function

Implementation of the algorithm showed in the paper "Generating Candidate Busy Beaver Machines (Or How to Build the Zany Zoo)",
which can be found in [arXiv](https://arxiv.org/abs/1610.03184), to generate candidates
for the Busy Beaver function.

## Things to Note
-  Their implementation is in Prolog and is very slow, and that is if you
   somehow manage to first find the code and secondly manage to actually run it.
-  I do not get the same amount of machines for higher dimensions as theirs.
   This is because they do not specify what bound on the iterations when running
   machines they were using. And thus a machine that my have undefined transition in some part of the
   computation may get cut off because of the bound being to low. That considered, with large-enough bounds
   the number must become stable, and in my experience it usually does with just a few extra
   machines of those reported by the paper.
-  As an advice for people trying to read the paper, look carefully at the notation
   of `symbol_choice(m,x)` and `state_choice(n,c)` which is presented just before
   `generate(n,m)`. Really weird choice on notation, although I understand why they
   did it.
-  They use a filtering criteria, called the blank-tape condition. It is shown that
   might be that the machine(s) with highest activity does not satisfy this condition,
   but that there exists a highest productivity machine which does. Thus it should be
   used only if searching for productivity champions.

## The Basics
There are several ways to define the `BB(n,m)` of an n-state m-symbols Turing
Machine, the choices here (as in the paper) are the following:

First, we adopt the model of quintuple machines. That is transition rules are
of the form

```
(state,symbol,new_symbol,direction,new_state)
```
where direction can be either `l` or `r`. They also label
the hating state as `z`, and other states as `a,b,c ...`. The blank
symbol is always `0` and the rest of them are taken in order
from `1,2 ...`. Were `z` can't be in the first entry of the tuple. And thus
when we say n-state machine we men n-states apart from the halting one. A machine
is also considered halting if and only if at some point reaches the halting state.

Thus, given `n` and `m` a single machine can be specified as a list
of `n*m` blocks of three symbols. For example, the 3-states 2-symbols Turing
Machine found in examples of [Busy Beaver Wikipedia](https://en.wikipedia.org/wiki/Busy_beaver)
which is specified as:

|  | A | B | C |
|--|---|---|---|
|0 |1RB|0RC|1LC|
|1 |1RH|1RB|1LA|

we would specify as

```
1rb 1rz 0rc 1rb 1lc 1la
```

Note that we changed 'H' by 'z'. Once agreed on the model, they
define the productivity of a halting machine as the amount of
non-`0` symbols that are in the final tape configuration. And
the `BB(n,m)` to be the productivity of the n-states m-symbols
halting Turing Machine with higher productivity.
