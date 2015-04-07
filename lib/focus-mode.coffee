FocusModeView = require './focus-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = FocusMode =
  focusModeView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @focusModeView = new FocusModeView(state.focusModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @focusModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'focus-mode:toggle': => @toggle()
    @subscriptions.add atom.workspace.observePanes (pane) => @initPane pane

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @focusModeView.destroy()

  serialize: ->
    focusModeViewState: @focusModeView.serialize()

  initPane: (pane) ->
      subscription = new CompositeDisposable

      subscription.add pane.onDidDestroy ->
        subscription.dispose()

      # subscription.add pane.onDidAddItem =>
      #   @handlePaneItemEvent pane
      #
      # subscription.add pane.onDidRemoveItem =>
      #   @handlePaneItemEvent pane

      subscription.add pane.onDidChangeActivePaneItem =>
        @handlePaneItemEvent pane

      @handlePaneItemEvent pane, 0

  handlePaneItemEvent: (pane, delay = 150) ->
    paneView = atom.views.getView pane
    tabView = paneView.querySelector '.tab-bar'

    # hideTab = pane.getItems().length == 1
    hideTab = true

    # ToDo: Need code to close old tabs (??)

    # Save the display state (if we need to restore it)
    if hideTab
      tabView.setAttribute 'focus-mode', tabView.style.display
      tabView.style.display = "none"
    else
      tabView.style.display = tabView.getAttribute 'focus-mode'

  toggle: ->
    console.log 'FocusMode was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
