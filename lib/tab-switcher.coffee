class TabSwitcher
  @find: (event) ->
    $pane = event.targetView().closest('.pane')
    data = $pane.data('tab-switcher')

    unless data?
      data = new TabSwitcher($pane.data('view'))
      $pane.data('tab-switcher', data)

    data

  constructor: (@paneView) ->
    @pane = @paneView.model
    @timeouts = 0

  itemActivated: (item) ->
    @timeouts += 1
    timeout = parseInt atom.config.get('tab-switcher.timeout'), 10
    setTimeout (=> @timeout(item)), timeout

  timeout: (item) ->
    return if @timeouts == 0

    @timeouts -= 1
    if @timeouts == 0
      @pane.moveItem(item, 0)

module.exports =
  activate: (state) ->
    unless atom.config.get('tab-switcher.timeout')
      atom.config.set('tab-switcher.timeout', 1000)

    atom.workspaceView.on 'pane:active-item-changed', (event, item) =>
      TabSwitcher.find(event).itemActivated(item)

  deactivate: ->
    atom.workspaceView.off 'pane:active-item-changed'
