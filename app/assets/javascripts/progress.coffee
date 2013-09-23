class Progress

	constructor: () ->
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			animate: true
			attributionControl: false
			minZoom: 12
			maxZoom: 20
			dragging: true
			maxBounds: new L.LatLngBounds(new L.LatLng(40.791289,-74.040598), new L.LatLng(40.683883,-73.942495))
		)
	# var NE = new L.LatLng(41.0053,-74.4234),
 #    SW = new L.LatLng(40.3984,-73.5212),
 #    NYCbounds = new L.LatLngBounds(SW, NE);

		$("#score .total").on 'click', () ->
			location.href = "/fixer/building"

		@map.on('load', @getPolygons)

		# @map.on('click', @onMapClick)

		window.map = @

	getPolygons: () =>
		p = @
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		$.getJSON('/fixer/sessionProgress.json', (data) ->
			# console.log(data)
			return if data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

			$("#score .total").text(data.all_polygons_session)

			m = p.map

			# marker clustering layer
			markers = new L.MarkerClusterGroup
				singleMarkerMode: true
				spiderfyDistanceMultiplier: 2
				disableClusteringAtZoom: 19
				iconCreateFunction: (c) ->
					count = c.getChildCount()
					c = 'cluster-large'
					if count < 10
						c = 'cluster-small'
					else if count < 30
						c = 'cluster-medium'
					new L.DivIcon
						html: count
						className: c
						iconSize: L.point(30, 30)
				polygonOptions:
					stroke: false
			
			markers.on 'click', (a) ->
				# console.log a.layer.getLatLng()
				m.panTo a.layer.getLatLng()
				m.setZoom 20

			# marker icons
			# yes_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-yes.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-yes-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]

			# no_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-no.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-no-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]
			
			# fix_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-fix.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-fix-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]
			
			yes_json = L.geoJson(data.yes_poly,
				style: (feature) ->
					fillColor: yes_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)
			no_json = L.geoJson(data.no_poly,
				style: (feature) ->
					fillColor: no_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)
			fix_json = L.geoJson(data.fix_poly,
				style: (feature) ->
					fillColor: fix_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)

			bounds = new L.LatLngBounds()

			if data.yes_poly.features.length>0
				yes_json.addTo(m)
				bounds.extend(yes_json.getBounds())

			if data.no_poly.features.length>0
				no_json.addTo(m)
				bounds.extend(no_json.getBounds())

			if data.fix_poly.features.length>0
				fix_json.addTo(m)
				bounds.extend(fix_json.getBounds())

			m.addLayer(markers)
			
			m.fitBounds(bounds)
		)
	
	addMarker: (markers, data) ->
		latlng = L.geoJson(data).getBounds().getCenter()#new L.LatLng(data.geometry.coordinates[0][0][1],data.geometry.coordinates[0][0][0])
		# console.log latlng
		markers.addLayer new L.Marker latlng
			# icon: icon
		markers

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._progress = new Progress()
