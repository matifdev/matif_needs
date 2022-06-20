TriggerEvent('chat:addSuggestion', '/invitetogroup', 'Invite player to group', {
    { name="player_id", help="Player Id" }
})

TriggerEvent('chat:addSuggestion', '/mygroup', 'Get your group details')

TriggerEvent('chat:addSuggestion', '/leavegroup', 'Leave current group')

TriggerEvent('chat:addSuggestion', '/leavegroup', 'Leave current group')

TriggerEvent('chat:addSuggestion', '/acceptinvite', 'Accept invite to group', {
    { name="inviter_id", help="Id of the inviter" }
})