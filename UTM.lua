states = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y"}
symbols = {"0","1","2","3","4","5","6","7","8","9"}

function readTM (n,m,rules)
  local M={}
  local g = 1
  for i=1,n do
    for j=1,m do
      M[states[i]..symbols[j]] = rules[g]
      g = g+1
    end
  end
  return M
end

function showTM(M,n,m)
  local s = {}
  for i=1,n do
    for j=1,m do
      local at = M[states[i]..symbols[j]]
      if nil == at then at = "---" end
      table.insert(s,at)
    end
  end
  return s
end

-- Runs a TM in the empty input checking various conditions as in the paper
function runTM(M,n,m,bound)
  local tape,ix,state,iterations,reason,nzeros,minix,maxix = {},0,"a",0,nil,0,0,0
  local get = function(tape,i)
    local v = tape[i]
    if v == nil then
      return "0"
    end
    return v
  end 
  while true do
    if iterations > 0 and nzeros == 0 then  -- blank-tape condition
      reason = "blank"
      break
    end
    if state == "z" then
      reason = "halted"
      break  
    end
    if iterations >= bound then
      reason = "bound"
      break
    end
    local v  = get(tape,ix)
    local at = M[state..v]
    if nil == at then            -- Undefined transition
      reason = "incomplete"
      undef  = state..v          -- which one is it
      break
    end
    local newv,dir,newstate = at:sub(1,1),at:sub(2,2),at:sub(3,3)
    if newv ~= "0" and v == "0" then
      nzeros = nzeros+1
    elseif newv == "0" and v ~= "0" then
      nzeros = nzeros-1
    end
    tape[ix] = newv
    state = newstate
    if dir == "l" then
      ix = ix-1
    elseif dir == "r" then
      ix = ix+1
    end
    iterations = iterations+1
    minix = math.min(ix,minix)
    maxix = math.max(ix,maxix)
  end
  return output,iterations,reason,undef,nzeros
end

-- For testing

bb32D = {"1rb","1rz","0rc","1rb","1lc","1la"} -- activity 14 and productivity 6
bb52D = {"1rb","1lc","1rc","1rb","1rd","0le","1la","1ld","1rz","0la"} -- 4098 "1"s with 8191 "0"s interspersed in 47,176,870 steps
bb24D = {"1rb","2la","1ra","1ra","1lb","1la","3rb","1rz"} -- This should give  3,932,964 steps with 2,050 ones final tape
bb32 = readTM(3,2,bb32D)
bb52 = readTM(5,2,bb52D)
bb24 = readTM(2,4,bb24D)
--[[
output,iters,reason,undef,prod = runTM(bb52,5,2,100^10)
print(iters)
print(reason)
print(prod)
--]]
