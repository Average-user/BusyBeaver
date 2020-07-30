# Generating Candidates for the Busy Beaver function

Implementation of the algorithm showed in the paper "Generating Candidate Busy Beaver Machines (Or How to Build the Zany Zoo)",
which can be found in [arXiv](https://arxiv.org/abs/1610.03184), to generate candidates
for the Busy Beaver function.

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
The following results were all obtained with a bound of
`200` in a `i5-4300U CPU @ 1.90GHz` using [LuaJIT](https://luajit.org/).
By running the following command `time luajit main.lua n m 200`.


| Size (n x m) | Machines Generated | Time counting (s) | Output File Size (kB) |
|:------------:|-------------------:|------------------:|----------------------:|
| 2x2          |                 36 |              0.00 |                     1 |
| 3x2          |              3,508 |              0.02 |                    67 |
| 2x3          |              2,764 |              0.01 |                    53 |
| 4x2          |            511,162 |              2.79 |                12,780 |
| 2x4          |            342,532 |              1.93 |                 8,564 |
| 3x3          |         26,816,046 |            126.04 |               750,850 |
| 5x2          |        102,598,955 |            549.96 |             3,180,568 |
| 2x5          |         75,406,519 |            370.40 |             2,337,603 |

The compressed file with all of these outputs weights "only" `496MB`.

While for dimensions `2x2`, `3x2`, `2x3` this programs
outputs the exact same machines as theirs. For `4x2` the
output of this program is a superset of theirs, whit difference:

```
1rb --- 1rc 1rz 1ld 0lb 0la 0lc
1rb 1rz 1rc 0la 1ld 0lb 0la 0lc
1rb 1rz 1rc 0lb 1ld 0lb 0la 0lc
1rb 1rz 1rc 0lc 1ld 0lb 0la 0lc
1rb 1rz 1rc 0ld 1ld 0lb 0la 0lc
1rb 1rz 1rc 0ra 1ld 0lb 0la 0lc
1rb 1rz 1rc 0rb 1ld 0lb 0la 0lc
1rb 1rz 1rc 0rc 1ld 0lb 0la 0lc
1rb 1rz 1rc 0rd 1ld 0lb 0la 0lc
1rb 1rz 1rc 1la 1ld 0lb 0la 0lc
1rb 1rz 1rc 1lb 1ld 0lb 0la 0lc
1rb 1rz 1rc 1lc 1ld 0lb 0la 0lc
1rb 1rz 1rc 1ld 1ld 0lb 0la 0lc
1rb 1rz 1rc 1ra 1ld 0lb 0la 0lc
1rb 1rz 1rc 1rb 1ld 0lb 0la 0lc
1rb 1rz 1rc 1rc 1ld 0lb 0la 0lc
1rb 1rz 1rc 1rd 1ld 0lb 0la 0lc
```
And something similar for `2x4`
