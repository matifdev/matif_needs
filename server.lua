version = 2.0

Citizen.CreateThread(function()
  PerformHttpRequest("https://raw.githubusercontent.com/matifdev/matif_needs/master/version", function(err,responseText, headers)
    if version == tonumber(responseText) then
      print("matif_needs: your script is up to date.")
    else
      print("############## MATIF NEEDS ##########")
      print("matif_needs: your script out of date, update it at https://github.com/matifdev/matif_needs")
      print("#####################################")
    end 
  end, "GET")
end)

-- CHANGE HERE -- 

function getPlayerNameFromId(id)
  -- default fivem Name
  return GetPlayerName(id)
end

-- Group System -- 

Cache = {}
Cache["groups"] = {}
Cache["players"] = {}
Cache["invites"] = {}

AddEventHandler('playerDropped', function (reason)
  local id = source
  if Cache["players"][id] then
      local group = Cache["groups"][Cache["players"][id]]["members"]
      groupIndex = Cache["players"][id]
      group[id] = nil
      Cache["players"][id] = nil
      for playerId,details in pairs(group) do
          TriggerClientEvent('chat:addMessage', playerId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["player_left_group"], GetPlayerName(id),id)}})
      end
      refreshGroup(groupIndex)
  end
end)

RegisterCommand('mygroup', function(source, args, rawCommand)
  local id = source
  if Cache["players"][id] then
      local group = Cache["groups"][Cache["players"][id]]["members"]
      local groupString = ""
      for playerId,details in pairs(group) do
          if #groupString > 0 then groupString = groupString .. ", " end
          groupString = groupString .. details["playerName"] .. "[" .. playerId .. "]"
      end
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["your_group"], groupString)}})
  else
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["not_in_a_group_with_suggestion"]}})
  end
end)

RegisterCommand('leavegroup', function(source, args, rawCommand)
  local id = source

  if Cache["players"][id] then
      local group = Cache["groups"][Cache["players"][id]]
      groupIndex = Cache["players"][id]
      if Cache["groups"][groupIndex]["status"] then
        TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["error_in_a_mission"]}})
        return 
      end
      group["members"][id] = nil
      Cache["players"][id] = nil
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["you_left_group"]}})
      for playerId,details in pairs(group["members"]) do
          TriggerClientEvent('chat:addMessage', playerId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["player_left_group"], GetPlayerName(id),id)}})
      end
      refreshGroup(groupIndex)
  else
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["not_in_a_group"]}})
  end
end)

RegisterCommand('invitetogroup', function(source, args, rawCommand)
  local id = source
  local targetId = tonumber(args[1])
  if not targetId or targetId == id or not GetPlayerName(targetId) then
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["invalid_player_id"]}})
      return 
  end

  if Cache["players"][id] then
      local group = Cache["groups"][Cache["players"][id]]["members"]
      if Cache["groups"][Cache["players"][id]]["status"] then
        TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["cannot_invite_in_mission"]}})
        return 
      end
      if group[id]["isLeader"] then
          if group[targetId] then
              TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["error_player_already_in_group"], GetPlayerName(id),id)}})
              return 
          end
          invitePlayer(id, targetId)
      else
          TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["not_group_leader"]}})
      end
  else
      local groupIndex = #Cache["groups"] + 1
      Cache["groups"][groupIndex] = {}
      Cache["groups"][groupIndex]["members"] = {}
      Cache["groups"][groupIndex]["members"][id] = {playerName = GetPlayerName(id), isLeader = true, joinedAt = os.time()}
      Cache["players"][id] = groupIndex

      invitePlayer(id, targetId)
  end
end)


function invitePlayer(sourceId, targetId)
  local groupIndex = Cache["players"][sourceId]
  if not Cache["invites"][targetId] then Cache["invites"][targetId] = {} end
  for k,v in pairs(Cache["invites"][targetId]) do
      if v.sourceId == sourceId and v.invitedAt > (os.time() - 30) then
          TriggerClientEvent('chat:addMessage', sourceId, { args = {Config.Groups_ChatPrefix, Config.Translation["already_invited_player"]}})
          return
      end
  end
  table.insert(Cache["invites"][targetId], {sourceId = sourceId, groupIndex = groupIndex, invitedAt = os.time()})

  TriggerClientEvent('chat:addMessage', targetId, { args = {Config.Groups_ChatPrefix,  string.format(Config.Translation["been_invited"], GetPlayerName(sourceId),sourceId)}})
  TriggerClientEvent('chat:addMessage', sourceId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["invited"], GetPlayerName(targetId),targetId)}})
end

RegisterCommand('acceptinvite', function(source, args, rawCommand)
  local id = source
  local targetInvite = tonumber(args[1])

  if not Cache["invites"][id] or not targetInvite or not GetPlayerName(targetInvite) then
      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["invalid_invite"]}})
      return
  end

  for k,v in pairs(Cache["invites"][id]) do
      if v.sourceId == targetInvite then
          if Cache["players"][targetInvite] == v.groupIndex then

              if not Cache["players"][id] or (Cache["players"][id] and v.groupIndex ~= Cache["players"][id]) then

                  if Cache["players"][id] then
                      local group = Cache["groups"][Cache["players"][id]]
                      groupIndex = Cache["players"][id]
                      if Cache["groups"][Cache["players"][id]]["status"] then
                        TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["error_in_a_mission"]}})
                        return 
                      end
                      group["members"][id] = nil
                      Cache["players"][id] = nil
                      TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["you_left_group"]}})
                      for playerId,details in pairs(group["members"]) do
                          TriggerClientEvent('chat:addMessage', playerId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["player_left_group"], GetPlayerName(id),id)}})
                      end
                      refreshGroup(groupIndex)
                  end

                  if Cache["groups"][v.groupIndex]["status"] then
                    TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["invalid_invite"]}})
                    return 
                  end

                  for playerId,details in pairs(Cache["groups"][v.groupIndex]["members"]) do
                      TriggerClientEvent('chat:addMessage', playerId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["player_joined_group"], GetPlayerName(id),id)}})
                  end
                  Cache["groups"][v.groupIndex]["members"][id] = {playerName = GetPlayerName(id), isLeader = false, joinedAt = os.time()}
                  Cache["players"][id] = v.groupIndex
                  Cache["invites"][id][k] = nil
                  TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Tranlation["joined_group"]}})
                  return
              else
                  TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Tranlation["you_already_in_group"]}})
                  return
              end
          else
              TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["invalid_invite"]}})
              return
          end
      end
  end

  TriggerClientEvent('chat:addMessage', id, { args = {Config.Groups_ChatPrefix, Config.Translation["invalid_invite"]}})
end)

function refreshGroup(groupIndex)
  local group = Cache["groups"][groupIndex]["members"]
  deleteOldInvites(groupIndex)
  
  local groupSize = 0
  for k,v in pairs(group) do
      groupSize = groupSize + 1
  end

  if groupSize > 0 then
      local oldestMember = {id = 0, joinedAt = 0}
      for k,v in pairs(group) do
          if oldestMember.joinedAt == 0 or v.joinedAt < oldestMember.joinedAt then
              oldestMember.id = k
              oldestMember.joinedAt = v.joinedAt
          end
      end
      if oldestMember ~= 0 then
        if not Cache["groups"][groupIndex]["members"][oldestMember.id]["isLeader"] then
          Cache["groups"][groupIndex]["members"][oldestMember.id]["isLeader"] = true
          TriggerClientEvent('chat:addMessage', oldestMember.id, Config.Translation["you_are_group_leader"])
          for playerId,details in pairs(Cache["groups"][groupIndex]["members"]) do
              if playerId ~= oldestMember.id then
                  TriggerClientEvent('chat:addMessage', playerId, { args = {Config.Groups_ChatPrefix, string.format(Config.Translation["new_group_leader"], GetPlayerName(oldestMember.id), oldestMember.id)}})
              end
          end
        end
      end
  else 
      print("Group dismantled.")
  end
end

function deleteOldInvites(groupIndex)
  for player,tb in pairs(Cache["invites"]) do
      for k,v in pairs(tb) do
          if v.groupIndex == groupIndex then
              Cache["invites"][player][k] = nil
          end
      end
  end
end

function forceGroupCreation(id)
  local groupIndex = #Cache["groups"] + 1
  Cache["groups"][groupIndex] = {}
  Cache["groups"][groupIndex]["status"] = false
  Cache["groups"][groupIndex]["members"] = {}
  Cache["groups"][groupIndex]["members"][id] = {playerName = GetPlayerName(id), isLeader = true, joinedAt = os.time()}
  Cache["players"][id] = groupIndex
end

function getPlayerGroup(id)
  if not Cache["players"][id] then forceGroupCreation(id) end
  return Cache["players"][id]
end

function setGroupBusy(groupIndex, bool)
  if bool then Cache["groups"]["userResource"] = GetInvokingResource() end
  Cache["groups"][groupIndex]["status"] = bool
end

function isGroupBusy(groupIndex)
  if not Cache["groups"][groupIndex] then print("Error: tried to get status from invalid group, id: " .. groupIndex) return end
  return Cache["groups"][groupIndex]["status"]
end

function getGroupLeader(groupIndex)
  if not Cache["groups"][groupIndex] then print("Error: tried to get owner from invalid group, id: " .. groupIndex) return end
  for id, details in pairs(Cache["groups"][groupIndex]["members"]) do
    if details.isLeader then
      return id
    end
  end
end

function getGroupMembers(groupIndex)
  if not Cache["groups"][groupIndex] then print("Error: tried to get status from invalid group, id: " .. groupIndex) return end
  return Cache["groups"][groupIndex]["members"]
end

exports("getPlayerGroup", getPlayerGroup)
exports("isGroupBusy", isGroupBusy)
exports("setGroupBusy", setGroupBusy)
exports("getGroupLeader", getGroupLeader)
exports("getGroupMembers", getGroupMembers)

