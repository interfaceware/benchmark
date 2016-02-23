
-- testing speed of table.insert vs Eliot's idiom

function main(Data)
   iguana.setTimeout(200)
   local T1 = {}
   local T2 = {}
   local Count = 250000
   if (not iguana.isTest()) then
      Count = Count * 200  -- Channels run faster in production
   end
   local Time0 = os.ts.time()
   for i =1, Count do 
      T1[#T1+1]= i
   end
   local Time1 = os.ts.time()
   iguana.logInfo("Eliot's insert style takes: " ..os.ts.difftime(Time1, Time0))
   for i =1, Count do 
      table.insert(T2, i)
   end
   local Time2 = os.ts.time()
   iguana.logInfo("Table.insert style takes: "..os.ts.difftime(Time2, Time1))
      
   trace(T1)
   trace(T2)
end
