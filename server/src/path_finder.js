/*
 *  path_finder.js
 *  Algorithm for planning paths from beacon to beacon
 */

var _ = require('lodash');

function dfs(graph, start, target) {
  var search = function(current, visited) {
    if(current === target) {
      return [current];
    }

    visited.push(current);
    var neighbors = _.filter(graph[current], function(n) {
      return !(n in visited);
    });
    if(_.isEmpty(neighbors)) {
      return null;
    }

    for(var i = 0; i < neighbors.length; i++) {
      var n = neighbors[i];
      var path = search(n, visited);
      if(!_.isNull(path)) {
        path.unshift(current);
        return path;
      }
    };

    return null;
  };
  
  return search(start, []);
}

var findPath = function(building, startID, endID, callback) {
  callback(null, dfs(building.beaconGraph, startID, endID));
};

exports = module.exports = {
  findPath: findPath
};
