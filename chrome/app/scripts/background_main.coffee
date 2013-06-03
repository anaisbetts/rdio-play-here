"use strict"

serverConnection = null

connectToServer = (user) ->
  return if serverConnection

  browserUuid = localStorage["uuid"]
  unless browserUuid
    browserUuid = Math.uuid()
    localStorage["uuid"] = browserUuid

  dataToSend =
    userUrl: user
    browserUuid: browserUuid

  serverConnection = io.connect 'http://localhost:7000'
  serverConnection.on 'connect', -> 
    serverConnection.emit 'hostMachine', dataToSend
  
  serverConnection.on 'activate', ->
    console.log "activating Rdio now!"

sendMessage = (tabId) -> 
  chrome.tabs.sendMessage tabId, type: "getUser", (resp) ->
    unless resp
      # NB: It could be the case where there is a Rdio tab present but
      # our content script isn't loaded in it (i.e. the user had a Rdio
      # tab open when they installed the extension)
      return

    if resp.needsLogin
      console.log "Tab failed to get user info"
      localStorage["user"] = "{}"
    else
      localStorage["user"] = JSON.stringify resp.user
      connectToServer(resp.user) unless serverConnection

chrome.tabs.onUpdated.addListener (tabId, changeInfo, tab) ->
  return unless changeInfo.url and changeInfo.url =~ /http:\/\/www.rdio.com/
  window.setTimeout (-> sendMessage(tabId, false)), 2500

user = JSON.parse localStorage["user"] || "{}"

if user and user.url
  connectToServer()
  return

chrome.tabs.query url: "http://www.rdio.com/*", (tabs) ->
  rdioTab = null
  rdioTab = tabs[0].id if tabs.length > 0

  if rdioTab 
    sendMessage(rdioTab, false)
  else
    chrome.tabs.create url: "http://www.rdio.com"
