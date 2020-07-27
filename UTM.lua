local states = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y"}
local symbols = {"0","1","2","3","4","5","6","7","8","9"}

function index(i,j)
  return states[i]..symbols[j]
end

function readTM (n,m,rules)
  local M={}
  local g = 1
  for i=1,n do
    for j=1,m do
      M[index(i,j)] = rules[g]
      g = g+1
    end
  end
  return M
end

function showTM(M,n,m)
  local s = {}
  for i=1,n do
    for j=1,m do
      local at = M[index(i,j)]
      if nil == at then
        at = "---"
      end
      table.insert(s,at)
    end
  end
  return table.concat(s," ")
end

function computation_code(tape,state,ix,minix,maxix)
  local s = {}
  for k=minix,maxix do
    table.insert(s,tape[k])
  end
  return table.concat(s)..state..tostring(ix)
end

-- Runs a TM in the empty input checking various conditions as in the paper
function runTM(M,n,m,bound,check_cycles)
  local tape,ix,state,iterations,reason,nzeros,minix,maxix,seen = {},0,"a",0,nil,0,0,0,{}
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
    if check_cycles then                    -- Cyclic machines do not halt
      local status = computation_code(tape,state,ix,minix,maxix)
      if seen[status] then
        reason = "cyclic"
        break
      end
      seen[status] = true
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
  local output = {}
  for i=minix,maxix do
    table.insert(output,tape[i])
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
  output,iters,reason,undef,prod = runTM(bb32,3,2,100,false)
  print(iters)
  print(reason)
  print(prod)
  print(table.concat(output))
--]]
