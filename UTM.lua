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

function runTM(M,n,m)
  local tape,ix,state,iterations,reason,zeros,minix,maxix = {},0,"a",0,nil,0,0,0
  local get = function(tape,i)
    local v = tape[i]
    if v == nil then
      return "0"
    end
    return v
  end 
  while true do
    if ix ~= 0 and zeros == 0 then
      reason = "blank"
      break
    end
    if state == "z" then
      reason = "halted"
      break  
    end
    local v  = get(tape,ix)
    local at = M[state..v]
    if nil == at then
      reason = "incomplete"
      undef  = at
      break
    end
    local newv,dir,newstate = at:sub(1,1),at:sub(2,2),at:sub(3,3)
    if newv ~= "0" and v == "0" then
      zeros = zeros+1
    elseif newv == "0" and v ~= "0" then
      zeros = zeros-1
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
  return output,iterations,reason,undef,zeros
end
