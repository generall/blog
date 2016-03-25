$(function () {

  var plot_graph = function(){

    var width = 400,
    height = 400;

    var color = d3.scale.category20();

    var force = d3.layout.force()
      .charge(-120)
      .linkDistance(45)
      .size([width, height]);

    var svg = d3.select(".graph").append("svg")
      .attr("width", width)
      .attr("height", height);

    d3.json("/api/graph.json", function(error, graph) {
      if (error) throw error;

      force
        .nodes(graph.nodes)
        .links(graph.links)
        .start();

      var link = svg.selectAll(".link")
        .data(graph.links)
        .enter().append("line")
        .attr("class", "link")
        .style("stroke-width", function(d) { return Math.sqrt(d.value); });

      var node = svg.selectAll(".node")
        .data(graph.nodes)
        .enter().append("circle")
        .attr("class", "node")
        .attr("r", 9)
        .style("fill", function(d) { return color(d.group); })
        .call(force.drag);

      var legend = svg.selectAll(".legend")
        .data(graph.cats)
        .enter().append("rect")
        .attr("y", function(d){ return  d.num * 15 + 10 })
        .attr("x", 10)
        .attr("width", 10)
        .attr("height", 10)
        .attr("fill", function(d) { return color(d.id); })

      var legend_text = svg.selectAll(".legendText")
        .data(graph.cats)
        .enter().append("text")
        .attr("y", function(d){ return d.num * 15 + 20 })
        .attr("x", 25)
        .text(function(d){return d.name})
        .attr("font-size", "12px");

      node.append("title")
        .text(function(d) { return d.name + " [" + d.cat + "]"; });

      node.on("dblclick", function(d) { document.location = d.cat_link });

      force.on("tick", function() {
        link.attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

        node.attr("cx", function(d) { return d.x; })
          .attr("cy", function(d) { return d.y; });
      });
    });
  }

  $(document).ready(function () {
    plot_graph();
  });
}); 
