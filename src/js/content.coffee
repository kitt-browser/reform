$ = require('../vendor/jquery/jquery')
_ = require('../vendor/underscore/underscore')

require('../css/content.css')


_jQuery = $.noConflict(true)

(($) ->
  console.log 'content script ready'
  chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    console.log('message received:', request)
    switch request.cmd
      when 'getForms'
        res = []
        api.getForms().each ->
          outerHTML = $('<p>').append($(this).eq(0).clone()).html()
          res.push outerHTML
        sendResponse({forms: res})
        return
      when 'fillInputs'
        #console.log 'filling inputs', _.filter _.keys(request.data), (item) ->
        #  request.data[item]?
        for sel, val of request.data
          api.getForms().find(sel).val(val)

)(_jQuery)

api = {

  getPageSource: ->
    return $('html')

  getForms: ->
    return @getPageSource().find('form')

}

module.exports = api
