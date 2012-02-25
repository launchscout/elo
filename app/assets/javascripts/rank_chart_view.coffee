class window.RankChartView

  constructor: (options)->
    @dates = _.map(options.collection, (item)=> @formatDate(item.date))
    @singlesData = _.filter(options.collection, (item)-> item.rank)
    @doublesData = _.filter(options.collection, (item)-> item.doubles_rank)

    @chart = new Highcharts.Chart
      chart:
        renderTo: options.el
        type: 'line'
      title:
        text: "Rank Over Time"
      xAxis:
        categories: @dates
      yAxis:
        title:
          text: 'ELO'
      series: [@singlesSeries(), @doublesSeries()]

  formatDate: (dateStr)->
    Date.parse(dateStr).toString("d MMM h:mm")

  singlesSeries: ->
    name: 'Individual Rank'
    data: _.map(@singlesData, (item)=> @point(item))

  doublesSeries: ->
    name: 'Doubles Rank'
    data: _.map(@doublesData, (item)=> @point(item))

  point: (item)->
    name: "#{item.winner_names} beat #{item.loser_names} by #{item.margin} (Δ#{item.change})"
    x: _.indexOf(@dates, @formatDate(item.date))
    y: item.rank || item.doubles_rank