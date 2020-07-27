require "UTM"

bb32D = {"1rb","1rz","0rc","1rb","1lc","1la"} -- activity 14 and productivity 6
bb52D = {"1rb","1lc","1rc","1rb","1rd","0le","1la","1ld","1rz","0la"} -- 4098 "1"s with 8191 "0"s interspersed in 47,176,870 steps
bb24D = {"1rb","2la","1ra","1ra","1lb","1la","3rb","1rz"} -- This should give  3,932,964 steps with 2,050 ones final tape
bb32 = readTM(3,2,bb32D)
bb52 = readTM(5,2,bb52D)
bb24 = readTM(2,4,bb24D)

output,iters,reason,undef,prod = runTM(bb24,2,4)
print(iters)
print(reason)
print(prod)
print(table.concat(output))
