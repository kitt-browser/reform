sinon = require('../../node_modules/sinon')

window.chrome =
  runtime:
    onMessage:
      addListener: sinon.stub()

