ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent('matif_needs:keyPress')

lastPresses = {}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(50)
        local pressed = {}
        for k,v in pairs(Keys) do
            if IsControlPressed(0, v) then
                table.insert(pressed, {value = v, key = k})
            end
        end
        for i=1, #lastPresses, 1 do
            if lastPresses[i] ~= nil then 
                if not IsControlPressed(0, lastPresses[i]) then table.remove(lastPresses, i) end 
                for ii=1, #pressed, 1 do
                    if pressed[ii] ~= nil then
                        if lastPresses[i] == pressed[ii].value then 
                            pressed[ii] = nil
                        end
                    end
                end
            end
        end
        for i=1, #pressed, 1 do
            if pressed[i] ~= nil then
                table.insert(lastPresses, pressed[i]['value']) keyPressed(pressed[i]['key'])
            end
        end
    end
end)

queue = {}

function keyPressed(key)
    for i=1, #queue, 1 do
        if queue[i].key == key then print("desired key pressed") if queue[i].showText ~= nil then print('closing?') SendNUIMessage({ action = 'hideTopText'}) end TriggerEvent('matif_needs:callFunction', queue[i].fnc) table.remove(queue, i) end
    end 
end

RegisterNetEvent('matif_needs:waitForKey')
AddEventHandler('matif_needs:waitForKey', function(id, key, fnc, showText)
    if not alreadyWaiting(id) then
        table.insert(queue, {id = id, key = key, fnc = fnc, showText = showText})
        if showText ~= nil then SendNUIMessage({ action = 'showTopText', text = showText }) end
    else
        print("ERROR: You already have a wait with this id(" .. id .. ")")
    end
end)

function alreadyWaiting(id)
    local found = false
    for k,v in pairs(queue) do
        if v.id == id then found = true return found end
    end 
    return found
end

RegisterNetEvent('matif_needs:removeFromWait')
AddEventHandler('matif_needs:removeFromWait', function(id)
    for k,v in pairs(queue) do
        if v.id == id then table.remove(queue, k) if v.showText ~= nil then print('closing?') SendNUIMessage({ action = 'hideTopText'}) end end
    end
end)  

RegisterNetEvent('matif_needs:callFunction')
AddEventHandler('matif_needs:callFunction', function(fnc)
    fnc()
end)    

RegisterNetEvent('matif_needs:showMiddleText')
AddEventHandler('matif_needs:showMiddleText', function(txt)
    SendNUIMessage({
        action = 'showMiddleText',
        text = txt
    })
end) 

RegisterNetEvent('matif_needs:removeMiddleText')
AddEventHandler('matif_needs:removeMiddleText', function()
    SendNUIMessage({
        action = 'hideMiddleText'
    })
end) 

RegisterNetEvent('matif_needs:updateMiddleText')
AddEventHandler('matif_needs:updateMiddleText', function(txt)
    SendNUIMessage({
        action = 'updateMiddleText',
        text = txt
    })
end) 

RegisterNetEvent('matif_needs:showTopText')
AddEventHandler('matif_needs:showTopText', function(txt)
    SendNUIMessage({
        action = 'showTopText',
        text = txt
    })
end) 

RegisterNetEvent('matif_needs:removeTopText')
AddEventHandler('matif_needs:removeTopText', function()
    SendNUIMessage({
        action = 'hideTopText'
    })
end) 
