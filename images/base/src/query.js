/* jshint browser: true */
/* globals L, $, require, d4d: true */

var d4d = d4d || {};

function showMarkers(data) {
  var map = d4d.map;
  for (var i = 0; i < d4d.markers.length; i += 1) {
    map.removeLayer(d4d.markers[i]);
  }
  d4d.markers = [];
  for (i = 0; i < data.length; i += 1) {
    var lonlat = data[i].lonlat;
    map.addLayer(L.marker([lonlat.y, lonlat.x]));
  }
}

function wkb2geom(wkbLonlat) {
  var wkx = require('wkx');
  var buffer = require('buffer');

  // Split WKB into array of integers (necessary to turn it into buffer)
  var hexAry = wkbLonlat.match(/.{2}/g);
  var intAry = [];
  for (var i = 0; i < hexAry.length; i += 1) {
    intAry.push(parseInt(hexAry[i], 16));
  }

  // Generate the buffer
  var buf = new buffer.Buffer(intAry);

  // Parse buffer into geometric object
  return wkx.Geometry.parse(buf);
}

function newTable(firstRow) {
  var $headers = $('<tr />');
  for (var k in firstRow) {
    $headers.append($('<th />').attr("data-field", k).text(k));
  }
  return $('<table />').append($('<thead />').append($headers));

}

$(document).ready(function () {
  $('#form').submit(function (evt) {
    evt.preventDefault();
    var query = $('#query').val();
    $.get('/query/json/' + query).done(function (resp) {
      if (!resp.length) {
        return;
      }

      for (var i = 0; i < resp.length; i += 1) {
        if (resp[i].lonlat) {
          resp[i].lonlat = wkb2geom(resp[i].lonlat);
        }
      }

      showMarkers(resp);

      $('#table').empty();
      $('#table').append(newTable(resp[0]));
      $('#table table').bootstrapTable({
        data: resp
      });
    }).fail(function (/*jqXHR*/) {
      //$('#response').text('error');
    });
  });
});
