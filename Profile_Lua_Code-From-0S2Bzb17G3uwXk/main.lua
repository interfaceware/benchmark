local pepperfish = require 'profiler.pepperfish'  
 
-- This channel shows the use of the pepperfish profiler.  

-- It takes a while to run.  I would recommend turning off
-- annotations and just using the run button before increasing the number
-- of repetitions.  Also running the channel in production rather than in
-- the editor will give different results since the overhead of generating
-- annotations will be eliminated.

-- When the channel is run it will write output into a file called 
-- profilerResults.txt in the working directory of this Iguana instance.

function main()
   -- Try increasing repetitions to 100000
   local Repetitions = 5000
   local S, E
   -- First we show profiling using os.clock() timing
   S = os.clock()
   func1(Repetitions)
   E = os.clock() 
   trace("Function 1 time: "..E-S)
   S = os.clock()
   func2(Repetitions)
   E = os.clock()
   trace("Function 2 time: "..E-S)
   S = os.clock()
   func3(Repetitions)
   E = os.clock()
   trace("Function 3 time: "..E-S)
   S = os.clock()
   func4(Repetitions)
   E = os.clock()
   trace("Function 4 time: "..E-S)  
   S = os.clock()
   func5(Repetitions)
   E = os.clock()
   trace("Function 5 time: "..E-S)

   
   local OutputFile = iguana.workingDir()..'profilerResults.txt'
   local LogCommand = "Performance info in "..OutputFile
   trace(LogCommand)
   
   -- Now we measure execution times using Pepperfish profiler
   debug.sethook() 
   -- Say bye bye to annotations after this - the pepperfile
   -- profiller is taking over the debug hook.
   profiler = newProfiler()
    -- By default profiler will measure times, not calls
   profiler:start() 

   func1(Repetitions)
   func2(Repetitions)
   func3(Repetitions)
   func4(Repetitions)
   func5(Repetitions)
   
   profiler:stop()

   local F = io.open(OutputFile,'w+') 
   profiler:report(F)
   F:close() 
   
   iguana.logInfo(LogCommand)
end 

-- 1st example -------------------------------------
-- func1 compiles code in script itself
function func1(Repetitions)
   local max = Repetitions
   local s = {}
   for i = 1, max do
      s[i]=loadstring(string.format("return %d", i))
   end
   trace(s[max]())    
end

-- func2 avoids compiling code in script itself
function func2(Repetitions)
   local function assign(i)
      return function () return i end
   end
   local max = Repetitions
   local s = {}
   for i = 1, max do 
      s[i] = assign(i) 
   end
   trace(s[max]())    
end

-- 2nd example ------------------------------------------------------------------
-- func3 creates Local tables with four (next power of 2) slots in its hash part, 
-- it is wasting memory and CPU 
function func3(Repetitions)
   local max = Repetitions
   for i = 1, max do
      local a = {}
      a[1], a[2], a[3] = 1, 2, 3
   end
end

-- func4 creates the Local tables with the needed size
function func4(Repetitions)
   local max = Repetitions
   for i = 1, max do
      local a = {true, true, true}
      a[1], a[2], a[3] = 1, 2, 3
   end
end

-- func5 creates the Global tables with the needed size, but wasting time 
-- because tables not Local
function func5(Repetitions)
   local max = Repetitions
   for i = 1, max do
      a = {true, true, true}
      a[1], a[2], a[3] = 1, 2, 3
   end
end


