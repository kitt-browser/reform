chai = require('../../node_modules/chai')
chai.should()
$ = require('../vendor/jquery/jquery')
sinon = require('../../node_modules/sinon')

require('./mocks.coffee')

content = require('./content.coffee')


describe "on page ready", ->

  beforeEach (done) ->
    $ -> done()

  it "should listen for a message from the popup", ->
    chrome.runtime.onMessage.addListener.should.have.been.called

describe "getPageSource", ->

  it "should be a function", ->
    content.getPageSource.should.be.a.function

  it "should return the HTML of the current page", ->
    content.getPageSource().should.eql $('html')

describe "getForms", ->

  testPage = null

  it "should be a function", ->
    content.getForms.should.be.a.function

  beforeEach (done) ->
    $.get '/build/html/fixtures/xkcd_registration.spec.html', (data) ->
      testPage = data
      sinon.stub(content, 'getPageSource').returns $(data)
      done()

  afterEach ->
    content.getPageSource.restore()

  it "should return a jQuery array with all the forms on the current page", ->
    content.getForms().html().should.eql $(testPage).find('form').html()

