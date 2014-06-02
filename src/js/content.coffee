$ = require('../vendor/jquery/jquery')
_ = require('../vendor/underscore/underscore')

require('../vendor/bootstrap/bootstrap')
require('../vendor/bootstrap/bootstrap.css')


require('../css/content.css')


_jQuery = $.noConflict(true)

(($) ->
  console.log 'content script ready'
  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    console.log('message received:', request)
    sendResponse({forms: api.getForms()})

)(_jQuery)

api = {

  getPageSource: ->
    return $('html')

  getForms: ->
    return @getPageSource().find('form')

}

module.exports = api
