# matif_needs
FiveM resourced aimed to optimize scripts coded by me.

# Usage

* Key Press Optimization

```
TriggerEvent('matif_needs:waitForKey', id, key, function, text)

id - > unique id for request
key - > key you want to use to trigger the function example: "E"
function - > function to be triggered
text -> if this is set top text will be enabled (discover what top text is below)
```

```
TriggerEvent('matif_needs:removeFromWait', id)

id - > unique id you used to create request
```

* Optimized Top Text

![image](https://user-images.githubusercontent.com/25308309/86548794-960fa100-bf35-11ea-83d3-8585a2e23e06.png)

```
TriggerEvent('matif_needs:showTopText', text)

text - > text to appear in top text
```

```
TriggerEvent('matif_needs:removeTopText')

# this will remove the current Top Text
```

* Optimized Center Bottom Text

![image](https://user-images.githubusercontent.com/25308309/86548995-3796f280-bf36-11ea-9bfb-caf359de36b8.png)

```
TriggerEvent('matif_needs:showMiddletext', text)

text - > text to appear in optimized middle bottom text
```

```
TriggerEvent('matif_needs:updateMiddleText', text)

text -> text to update then current middle bottom text
```

```
TriggerEvent('matif_needs:removeMiddleText')

# this will remove the current Middle Text
```

* Markers

```
TriggerEvent('matif_needs:addMarker', name, info)

name -> marker reference name
info -> table: type, coords, scaleX, scaleY, scaleZ, red, green, blue, alpha

# Add new marker
```

```
TriggerEvent('matif_needs:removeMarker', name)

# Remove marker by name
```

* Groups

```
exports['matif_needs']:getPlayerGroup(id)

id - > Player Id

# Returns groupIndex
```

```
exports['matif_needs']:isGroupBusy(groupIndex)

groupIndex - > Group Index

# Returns groupIndex
```

```
exports['matif_needs']:setGroupBusy(groupIndex)

groupIndex - > Group Index

# Sets group busy by groupIndex.
```

```
exports['matif_needs']:getGroupLeader(groupIndex)

groupIndex - > Group Index

# Returns group leader by groupIndex.
```

```
exports['matif_needs']:getGroupMembers(groupIndex)

groupIndex - > Group Index

# Returns group members by groupIndex.
```