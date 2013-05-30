"use strict"

chrome.runtime.onMessage.addListener (req, sender, sendResp) ->
  return unless req.type == "getUser"

  stateJson = localStorage["/player/playerState"]
  unless stateJson
    sendResp needsLogin: true
    return

  state = JSON.parse stateJson

  sendResp
    needsLogin: false
    user: state.station.user
