FocusModeView = require './focus-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = FocusMode =
  focusModeView: null
  subscriptions: null
  isEnabled: false

  activate: (state) ->
    @focusModeView = new FocusModeView(state.focusModeViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'focus-mode:toggle': => @toggle()
    @subscriptions.add atom.workspace.observePanes (pane) => @initPane pane

  deactivate: ->
    @subscriptions.dispose()
    @focusModeView.destroy()

  serialize: ->
    focusModeViewState: @focusModeView.serialize()

  toggle: ->
    console.log 'FocusMode was toggled!'

    @isEnabled = !@isEnabled

    if @isEnabled
      atom.workspaceView.trigger 'tree-view:toggle'
      pane = atom.workspace.getActivePane()
      @handlePaneItemEvent pane
    else
      atom.workspaceView.trigger 'tree-view:toggle'

  initPane: (pane) ->
    console.log 'FocusMode was inited!'
    subscription = new CompositeDisposable

    subscription.add pane.onDidDestroy ->
      subscription.dispose()

    subscription.add pane.onDidChangeActiveItem => @handlePaneItemEvent pane
    @handlePaneItemEvent pane

  handlePaneItemEvent: (pane) ->
    console.log 'FocusMode Pane event!'

    if @isEnabled
      pane.destroyInactiveItems()
