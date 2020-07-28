# Generating Candidates for the Busy Beaver function

Implementation of the algorithm showed in the paper "Generating Candidate Busy Beaver Machines (Or How to Build the Zany Zoo)",
which can be found in [arXiv](https://arxiv.org/abs/1610.03184), to generate candidates
for the Busy Beaver function.

## Things to Note
-  I do not get the exact amount of machines for higher dimensions as those reported by the paper.
   I think this is because they do not specify what bound on the iterations when running
   machines they were using. And thus a machine that my have undefined transition in some part of the
   computation may get cut off because of the bound being to low.
-  As an advice for people trying to read the paper, look carefully at the notation
   of `symbol_choice(m,x)` and `state_choice(n,x)` which is presented just before
   `generate(n,m)`. Really weird choice on notation, although I understand why they
   did it.
-  They use a filtering criteria, called the blank-tape condition. It is shown that
   might be that the machine(s) with highest activity does not satisfy this condition,
   but that there exists a highest productivity machine which does. Thus it should be
   used only if searching for productivity champions.
-  They define a class of `irrelevant` (to the busy beaver problem) but they decide
   to still keep some of those in the output.

## The Basics
There are several ways to define the `BB(n,m)` of an n-state m-symbols Turing
Machine, the choices here (as in the paper) are the following:

First, we adopt the model of quintuple machines. That is transition rules are
of the form

```
(state,symbol,new_symbol,direction,new_state)
```
where direction can be either `l` or `r`. They also label
the halting state as `z`, and other states as `a,b,c ...`. The blank
symbol is always `0` and the rest of them are taken in order
from `1,2 ...`. Worth noting `z` can't be in the first entry of the tuple. And thus
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

## Results
The following results were all obtained with a `bound` of
100 in a `i5-4300U CPU @ 1.90GHz` using [LuaJit](https://luajit.org/).
By running the following command `time luajit main.lua n m 100`.


| Size (n x m) | Machines Generated | Time counting (s) |
|:------------:|-------------------:|------------------:|
| 2x2          |                 36 | 0.005             |
| 3x2          |              3,508 | 0.021             |
| 2x3          |              2,764 | 0.020             |
| 4x2          |            511,162 | 1,957             |
| 2x4          |            342,516 | 1,347             |
| 3x3          |         26,814,336 | 95,437            |

Of this table, the only differences with the paper
are that for `4x2` they get `511,145` and for `3x4` they get
`26,813,197` (page 23).
