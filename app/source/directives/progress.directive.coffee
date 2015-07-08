app.directive 'progress', () ->
  # template: 'actual is %{{ actualValue }} <br> expected is %{{ expectedValue }}'
  scope:
    actual: '='
    expected: '='
  link: (scope, element) ->
    width = 200
    height = 200
    τ = 2 * Math.PI
    svg = d3.select(element[0])
            .append('svg')
            .attr('width', width)
            .attr('height', height)
            .append('g')
            .attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')')

    outerArc = d3.svg.arc()
            .innerRadius(80)
            .outerRadius(90)
            .startAngle(0)

    innerArc = d3.svg.arc()
            .innerRadius(70)
            .outerRadius(75)
            .startAngle(0)

    outer = svg.append('path')
            .datum(endAngle: 0.127 * τ)
            .attr('stroke-linejoin', 'round')
            .style('fill', 'orange')
            .attr('d', outerArc)

    inner = svg.append('path')
            .datum(endAngle: 0.127 * τ)
            .attr('stroke-linejoin', 'round')
            .style('fill', '#c7e596')
            .attr('d', innerArc)
    circle = svg.append('circle')
            .attr('r', 65)
            .attr('fill', '#f5f5f5')
    line1 = svg.append('text')
            .attr('dy', 0)
            .attr('dx', -35)
            .style('font-size', '40px')
            .text('80%')
    line2 = svg.append('text')
            .attr('dy', 20)
            .attr('dx', -35)
            .style('font-size', '20px')
            .text('progress')

    createTween = (arc) ->
      (transition, newAngle) ->
        transition.attrTween 'd', (d) ->
          interpolate = d3.interpolate(d.endAngle, newAngle)
          (t) ->
            d.endAngle = interpolate(t)
            arc d
        return

    # Update the value
    update = () ->
      actualPercentage = parseFloat(scope.actual) * 100

      outer.transition()
           .duration(1000)
           .style('fill', if scope.actual < 0.25 then 'red' else if scope.actual < 0.50 then '#F7650B' else 'orange')
           .call(createTween(outerArc), scope.actual * τ);

      inner.transition()
           .duration(1000)
           .call(createTween(innerArc), scope.expected * τ);
      # update the text
      line1.text('%' + actualPercentage.toFixed(0))

    # Update the progress whenever the value changes
    scope.$watch 'actual', update
    scope.$watch 'expected', update
