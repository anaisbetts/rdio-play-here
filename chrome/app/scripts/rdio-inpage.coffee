"use strict"

afterSetup = -> 
  stateJson = localStorage["/player/playerState"]

  state = JSON.parse stateJson
  console.log(JSON.stringify(state.station.user))

window.setTimeout afterSetup, 250
