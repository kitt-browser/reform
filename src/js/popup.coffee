$ = require('../vendor/jquery/jquery')
_ = require('../vendor/underscore/underscore')

require('../vendor/bootstrap/bootstrap')
require('../vendor/bootstrap/bootstrap.css')


sendMessage = (msg, callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
    LOG('sending message to', tabs[0], msg)
    chrome.tabs.sendMessage tabs[0].id, msg, callback


__i = 1

LOG = ->
  args = (a for a in arguments)
  args.unshift(__i++)
  console.log.apply(console, args)


# Returns a "unique enough" selector for given `$elem` (combine classes and
# id f the element to create the selector).
getSelector = ($elem) ->
  selector = ""
  if $elem.attr('class')
    classes = (".#{c}" for c in $elem.attr('class').split(' '))
    selector += "#{classes.join('')}"
  if $elem.attr('id')
    selector += "##{$elem.attr('id')}"
  return selector


sendMessage {cmd: 'getForms'}, ({forms}) ->
  $inputs = $()
  state = {}

  for $form in _.map(forms, $)
    [$wrapper, $_inputs] = api.getWrappedInputs($form)
    $inputs = $inputs.add $_inputs

    $('body').append($wrapper.html())
    $('body').append('<hr></hr>')

  # Add a `done` button.
  $('body').append """
    <div class="salsita-ReForm-done">
      <button type="button" class="btn btn-default">Done</button>
    </div>
  """

  # Remember current state of the forms.
  $inputs.each ->
    selector = getSelector $(this)
    state[selector] = $(this).val()

  $('.salsita-ReForm-done button').on 'click', ->
    res = {}

    # Read the new forms state.
    $inputs.each ->
      selector = getSelector $(this)
      res[selector] = $(selector).val()

    # We're only interested in modified fields.
    for key of res
      if state[key] == res[key]
        delete res[key]

    LOG 'new inputs state', JSON.stringify res, null, 2

    sendMessage({cmd: "fillInputs", data: res})


# Returns the closest common ancestor for a set of elements.
# Taken from [http://stackoverflow.com/questions/3217147/jquery-first-parent-containing-all-children](Stack Overflow).
$.fn.commonAncestor = ->
  parents = []
  minlen = Infinity
  $(this).each ->
    curparents = $(this).parents()
    parents.push curparents
    minlen = Math.min(minlen, curparents.length)

  for i of parents
    parents[i] = parents[i].slice(parents[i].length - minlen)
  
  # Iterate until equality is found
  i = 0

  while i < parents[0].length
    equal = true
    for j of parents
      if parents[j][i] != parents[0][i]
        equal = false
        break
    if equal
      return $(parents[0][i])
    i++
  $([])


api = {
  # Returns `[wrapper, inputs]` where `wrapper` is the closest common ancestor
  # of inputs in `$form` and inputs are, well, the inputs, duh.
  getWrappedInputs: ($form) ->
    $form.find('script').remove()
    $form.find('input[type="image"]').remove()
    $form.find('input[type="hidden"]').remove()
    $form.find('img').remove()
    $inputs = $form.find('input')
    $ancestor = $inputs.commonAncestor()
    return [$ancestor, $inputs]
}


module.exports = api
