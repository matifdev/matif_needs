ESX = nil

version = 1.0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
  PerformHttpRequest("https://raw.githubusercontent.com/matifdev/matif_needs/master/version", function(err,responseText, headers)
    if version == tonumber(responseText) then
      print("matif_needs: your script is up to date.")
    else
      print("##############")
      print("matif_needs: your script out of date, update it in https://github.com/matifdev/matif_needs")
      print("##############")
    end 
  end, "GET")
end)
