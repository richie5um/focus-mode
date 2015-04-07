module.exports =
class FocusModeView
  constructor: (serializedState) ->
    console.log 'FocusMode enabled!'
    # # Create root element
    # @element = document.createElement('div')
    # @element.classList.add('focus-mode')
    #
    # # Create message element
    # message = document.createElement('div')
    # message.textContent = "The FocusMode package is Alive! It's ALIVE! 2"
    # message.classList.add('message')
    # @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
