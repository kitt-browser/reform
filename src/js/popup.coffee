
sendMessage = (msg, callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
    console.log('sending message to', tabs[0], msg)
    chrome.tabs.sendMessage tabs[0].id, msg, callback

sendMessage {cmd: 'getForms'}, (forms) ->
  console.log 'forms', forms.length
