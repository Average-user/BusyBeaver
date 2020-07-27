require "UTM"

local states = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y"}
local symbols = {"0","1","2","3","4","5","6","7","8","9"}
  

function symbol_choice(m,sym)
  local k = #sym
  if k < m then
    table.insert(sym,symbols[k+1])
  end
  return sym
end

function state_choice(m,sts)
  local k = #sts
  if k < m then
    table.insert(sts,states[k+1])
  end
  return sts
end

function states_and_symbols(M,n,m)
  local ST,SY = {}, {}
  for i=1,n do
    for j=1,m do
      local v = M[states[i]..symbols[j]]
      if v ~= nil then
        ST[v:sub(3,3)] = true
        ST[states[i]] = true
        SY[v:sub(1,1)] = true
        SY[symbols[j]] = true
      end
    end
  end
  ST["z"] = nil
  local sts,c1,sys,c2 = {},0,{},0
  for x,_ in pairs(ST) do
    c1 = c1+1
    table.insert(sts,x)
  end
  for x,_ in pairs(SY) do
    c2 = c2+1
    table.insert(sys,x)
  end
  return sts,c1,sys,c2
end
      
function zero_dextrous(M,n,m)
  local c1 = 0
  local c2 = 0
  for i=1,n do
    local v = M[states[i].."0"]
    if v ~= nil then
      c1 = c1+1
      if v:sub(2,2) == "r" then
        c2 = c2+1
      end
    end
  end
  return c1 == n and c2 == n
end


C = 1
file,_ = io.open(arg[1]..arg[2]..".txt", "w")

function output(M,n,m)
 -- print(C,showTM(M,n,m))
  file:write(showTM(M,n,m).."\n") -- writes nm.txt with the machines generated.
  C = C+1
end  

-- steps (1) and (2)
function generate(n,m,bound)
  local M = {["a0"]="1rb"}

  for _,ns in pairs {"a","b"} do
    for _,o in pairs(symbol_choice(m,{"0","1"})) do
      M["b0"] = o.."l"..ns
      execution(M,n,m,bound)
      M["b0"] = nil
    end
  end

  if n >= 3 then
    for _,d in pairs {"l","r"} do
      for _,o in pairs(symbol_choice(m,{"0","1"})) do
        M["b0"] = o..d.."c"
        execution(M,n,m,bound)
        M["b0"] = nil
      end
    end
  end
end

-- Step (3) 
function execution(M,n,m,bound)
  local _,_,t,s,_ = runTM(M,n,m,bound,false)
  if t == "incomplete" then
    expand(M,n,m,bound,s)
  else
    output(M,n,m)
  end
end

-- Step (5)
function tryfix(M,n,m)
  local c = 0
  local fix = nil
  for i=1,n do
    for j=1,m do
      if M[states[i]..symbols[j]] ~= nil then
        c = c+1
      else
        fix = states[i]..symbols[j]
      end
    end
  end
  if c == (n*m) -1 then
    return fix
  end
  return nil
end      

-- Step (4) 
function expand(M,n,m,bound,undef)
  local sts,c1,sys,c2 = states_and_symbols(M,n,m)
  if n == c1 and m == c2 then
    M[undef] = "1rz"
    if not(zero_dextrous(M,n,m)) then
      output(M,n,m)
    end
    M[undef] = nil
  end

  for _,ns in pairs(state_choice(n,sts)) do
    for _,o in pairs(symbol_choice(m,sys)) do
      for _,d in pairs({"l","r"}) do
        M[undef] = o..d..ns
        if not (zero_dextrous(M,n,m)) then
          local fix = tryfix(M,n,m)
          if fix then
            M[fix] = "1rz"
            output(M,n,m)
            M[fix] = nil
          else
            execution(M,n,m,bound)
          end
        end
        M[undef] = nil
      end
    end
  end
end

generate(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]))
print(C-1)
