"use strict"
chrome.runtime.onInstalled.addListener (details) ->
  console.log "previousVersion", details.previousVersion
  chrome.alarms.create "test",
    delayInMinutes: 1.0 / 60.0


chrome.tabs.onUpdated.addListener (tabId) ->
  chrome.pageAction.show tabId

chrome.alarms.onAlarm.addListener (alarm) ->
  console.log "click"
