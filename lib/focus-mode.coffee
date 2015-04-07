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

    pane = atom.workspace.getActivePane()
    paneView = atom.views.getView pane
    tabView = paneView.querySelector '.tab-bar'

    if @isEnabled
      atom.workspaceView.trigger 'tree-view:toggle'
      tabView.setAttribute 'focus-mode', tabView.style.display
      tabView.style.display = 'none'

      @handlePaneItemEvent pane
    else
      atom.workspaceView.trigger 'tree-view:toggle'
      tabView.style.display = tabView.getAttribute 'focus-mode'

  initPane: (pane) ->
    console.log 'FocusMode was inited!'
    subscription = new CompositeDisposable

    subscription.add pane.onDidDestroy ->
      subscription.dispose()

    subscription.add pane.onDidChangeActiveItem => @handlePaneItemEvent pane
    @handlePaneItemEvent pane

  handlePaneItemEvent: (pane) ->
    console.log 'FocusMode Pane event!'

    # paneView = atom.views.getView pane
    # tabView = paneView.querySelector '.tab-bar'

    # RichS: Aggressive/Less Aggressive. Depends on whether we want instant knowledge that we have unsaved data
    # if @isEnabled
    #   pane.destroyInactiveItems()
