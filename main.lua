require "UTM"

function symbol_choice(m,k)
  local t = k
  if k < m then t = t+1 end
  local sym = {}
  for c=1,t do
    table.insert(sym,symbols[c])
  end
  return sym
end

function state_choice(n,k)
  local t = k
  if k < n then t = t+1 end
  local sts = {}
  for c=1,t do
    table.insert(sts,states[c])
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
  local sts,sys = {},{}
  for x,_ in pairs(ST) do
    table.insert(sts,x)
  end
  for x,_ in pairs(SY) do
    table.insert(sys,x)
  end
  table.sort(sts)
  table.sort(sys)
  --[[ For Debuggin
  for a=1,#sts do
    if sts[a] ~= states[a] then
      print("mhhh")
    end
  end
  for a=1,#sys do
    if sys[a] ~= symbols[a] then
      print("ohhh")
    end
  end
  --]]
  return sts,sys
end

function zero_dextrous(M,n,m)
  for i=1,n do
    local v = M[states[i].."0"]
    if nil == v or v:sub(2,2) ~= "r" then
      return false
    end
  end
  return true
end

-- steps (1) and (2)
function generate(n,m,bound)
  local M = {["a0"]="1rb"}

  for _,ns in pairs {"a","b"} do
    for _,o in pairs(symbol_choice(m,2)) do
      M["b0"] = o.."l"..ns
      execution(M,n,m,bound)
      M["b0"] = nil
    end
  end

  if n >= 3 then
    for _,d in pairs {"l","r"} do
      for _,o in pairs(symbol_choice(m,2)) do
        M["b0"] = o..d.."c"
        execution(M,n,m,bound)
        M["b0"] = nil
      end
    end
  end
end

-- Step (3)
function execution(M,n,m,bound)
  local _,_,t,s,_ = runTM(M,n,m,bound)
  if t == "incomplete" then
    expand(M,n,m,bound,s)
  else
    output(M,n,m)
  end
end

-- Step (5)
function tryfix(M,n,m)
  local c,fix = 0,nil
  for i=1,n do
    for j=1,m do
      if M[states[i]..symbols[j]] == nil then
        fix = states[i]..symbols[j]
        c = c+1
      end
    end
  end
  return fix,c
end

-- Step (4)
function expand(M,n,m,bound,undef)
  local sts,sys = states_and_symbols(M,n,m)
  if n == #sts and m == #sys then
    M[undef] = "1rz"
    if not(zero_dextrous(M,n,m)) then
      output(M,n,m)
    end
    M[undef] = nil
  end

  for _,ns in pairs(state_choice(n,#sts)) do
    for _,o in pairs(symbol_choice(m,#sys)) do
      for _,d in pairs({"l","r"}) do
        M[undef] = o..d..ns
        if not (zero_dextrous(M,n,m)) then
          local fix,amount = tryfix(M,n,m)
          if amount == 1 then
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

---------------------------------------------------------------
C = 0
MACHINES = {}
file = io.open(arg[1].."-"..arg[2].."-"..arg[3]..".txt", "w")

-- Function called when a machine to be collected is found
function output(M,n,m)
  --table.insert(MACHINES,showTM(M,n,m))
  -- print(C,showTM(M,n,m))
  file:write(showTM(M,n,m).."\n") -- writes nm.txt with the machines generated.
  C = C+1
end

generate(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]))
print(C)
