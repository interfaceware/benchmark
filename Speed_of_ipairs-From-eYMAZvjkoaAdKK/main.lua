
function main()
   iguana.setTimeout(200)
   local T = {}
   local Target = 50000
   -- Outside of editor things are faster - so run test for longer
   if (not iguana.isTest()) then Target = Target * 500 end
   for i=1,Target do
      T[#T+1] = i      
   end
   local Time0 = os.ts.time()
   for i=1, #T do
      trace(i)
   end
   local Time1 = os.ts.time()
   for _,V in ipairs(T) do
      trace(V)
   end
   local Time2 = os.ts.time()
   
   iguana.logInfo("Simple for loop: "..os.ts.difftime(Time2, Time1))
   iguana.logInfo("Ipairs loop: "..os.ts.difftime(Time1, Time0))
   
end