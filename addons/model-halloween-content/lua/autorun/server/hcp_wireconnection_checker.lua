
-----------------------------------------------------------]]
function CheckMortarConnections()
  for i,k in pairs({"mortar_pumbkinblaster","mortar_candypuff","mortar_demonfuzz"}) do
    for x,y in pairs(ents.FindByClass(k)) do
      y:BodyGroupState()
    end
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
function CheckMortarTimerExist()
  if timer.Exists("CheckMortarTimerExist") == false then
    timer.Create("CheckMortarTimerExist",1,0,CheckMortarConnections)
  end
end
-----------------------------------------------------------]]



-----------------------------------------------------------]]
hook.Add("InitPostEntity","InitalizeTimer",CheckMortarTimerExist)
--CheckMortarTimerExist()-- Däfehllopmänt K0
-----------------------------------------------------------]]
