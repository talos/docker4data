/* jshint browser: true */
/* globals $, L, d4d: true */

var d4d = d4d || {};
d4d.markers = [];

$(document).ready(function () {
  var map = L.map('map').setView([40.78, -73.97], 11);
  var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  var osmAttrib='Map data (c) <a href="http://openstreetmap.org">' +
                'OpenStreetMap</a> contributors';
  L.Icon.Default.imagePath = '/images';

  L.tileLayer(osmUrl, {
    attribution: osmAttrib,
    maxZoom: 18
  }).addTo(map);

  d4d.map = map;
});
