$ = require('../vendor/jquery/jquery')
chai = require('../../node_modules/chai')
chai.should()
chai = require('../../node_modules/sinon')


popup = require('./popup.coffee')


describe "popup", ->

  describe "getWrappedInputs", ->

    $root = null

    it "should be a function", ->
      popup.getWrappedInputs.should.be.a.function

    beforeEach ->
      $.get '/build/html/fixtures/input.spec.html', (data) ->
        $root = $(data)

    it "should return an array of first common ancestor for each input set (1)", ->
      [$elem, inputs] = popup.getWrappedInputs($root.find('.test1 form'))
      $elem.html().should.eql $root.find('.test1 .wrapper').html()

    it "should return an array of first common ancestor for each input set (2)", ->
      [$elem, inputs] = popup.getWrappedInputs($root.find('.test2 form'))
      $elem.html().should.eql $root.find('.test2 form').html()
