var FilteredOrgs = function (orgs) {
  var self = this;
  this.orgAdded = $.Callbacks();
  this.orgRemoved = $.Callbacks();

  this._orgs = orgs;
  this._keywords = {};
  this._counts = {};
  $.each(orgs, function (key) {
    self._counts[key] = 0;
  });
};

FilteredOrgs.prototype.onKeywordAdd = function (keyword, slugs) {
  var self = this;

  this._keywords[keyword] = slugs;
  slugs.forEach(function (slug) {
    self._counts[slug] += 1;
  });

  this._updateOrgsVisibility();
};

FilteredOrgs.prototype.onKeywordRemove = function (keyword) {
  var self = this;

  this._keywords[keyword].forEach(function (slug) {
    self._counts[slug] -= 1;
  });
  delete this._keywords[keyword];

  this._updateOrgsVisibility();
};

FilteredOrgs.prototype._updateOrgsVisibility = function () {
  var self = this;
  var numKeywords = Object.keys(this._keywords).length;
  $.each(this._counts, function (slug, count) {
    if (count === numKeywords) {
      self._orgs[slug].show();
    } else {
      self._orgs[slug].hide();
    }
  });
};

var Org = function (map, marker) {
  this._map = map;
  this._marker = marker;
  this._visibled = false;
};

Org.prototype.show = function () {
  if (this._visibled) {
    return;
  }

  this._marker.addTo(this._map);
  this._visibled = true;
};

Org.prototype.hide = function () {
  if (!this._visibled) {
    return;
  }

  this._map.removeLayer(this._marker);
  this._visibled = false;
};

var createMap = function () {
  var map = L.map('map', {
    zoomControl: false
  });

  new L.Control.Zoom({position: 'bottomright'}).addTo(map);

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors | <a href="https://github.com/larose/mtl-tech">Source Code</a>'
  }).addTo(map);


  L.easyButton({
    position: 'topright',
    leafletClass: false,
    states: [{
      stateName: 'add-org',
      title: "Add an organization",
      onClick: function () {
        window.open("https://github.com/larose/mtl-tech/blob/master/docs/how-to-add-an-organization.md", '_blank');
      },
      icon: '&plus;'
    }]
  }).addTo(map);

  return map;
};

var createMarker = function (template, orgData) {
  var context = {
    name: orgData.name,
    url: orgData.url,
    tags: orgData.tags.join(", ")
  };
  var popupContent = template.render(context);

  var marker = L.marker([orgData.latitude, orgData.longitude], {
    title: orgData.name,
  });
  marker.bindPopup(popupContent);

  marker.on('mouseover', function(event) {
    event.target.openPopup();
  });

  return marker;
};

$(document).ready(function() {
  var map = createMap();
  var orgPopupTemplate = $.templates("#orgPopupTemplate");

  $.get("orgs.json", function(_orgs) {
    var orgs = {};
    var bounds = [];

    $.each(_orgs, function (slug, orgData) {
      var marker = createMarker(orgPopupTemplate, orgData);
      bounds.push(marker.getLatLng());
      var org = new Org(map, marker);
      org.show();
      orgs[slug] = org;
    });

    map.fitBounds(bounds);

    var filteredOrgs = new FilteredOrgs(orgs);

    var selectize = $("#search-box-input").selectize({
      valueField: 'value',
      labelField: 'value',
      searchField: 'value',
      create: false,
      loadThrottle: null,
      load: function (query, callback) {
        if (!query.length) {
          return callback();
        }

        $.ajax({
          url: 'partial-keywords/' + encodeURIComponent(query.toLowerCase()) + '.json',
          type: 'GET',
          error: function() {
            callback();
          },
          success: function(res) {
            res = res.map(function (keyword) {
              return {
                value: keyword
              };
            });
            callback(res);
          }
        });
      },
      onItemAdd: function (keyword, item) {
        $.ajax({
          url: 'filters/' + encodeURIComponent(keyword) + '.json',
          success: function (orgSlugs) {
            filteredOrgs.onKeywordAdd(keyword, orgSlugs);
          }
        });
      },
      onItemRemove: function (keyword) {
        filteredOrgs.onKeywordRemove(keyword);
      }
    });
  });

});
