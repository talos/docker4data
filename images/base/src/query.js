/* jshint browser: true */
/* globals $, require */

function wkb2geom(wkbLonlat) {
  var wkx = require('wkx');
  var buffer = require('buffer');

  // Split WKB into array of integers (necessary to turn it into buffer)
  var hexAry = wkbLonlat.match(/.{2}/g);
  var intAry = [];
  for (var i in hexAry) {
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
          resp[i].lonlat = JSON.stringify(wkb2geom(resp[i].lonlat));
        }
      }
      $('#response').empty();
      $('#response').append(newTable(resp[0]));
      $('#response table').bootstrapTable({
        data: resp
      });
    }).fail(function (/*jqXHR*/) {
      $('#response').text('error');
    });
  });
});
