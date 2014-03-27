// code to instantiate a map

if (jQuery('#app-map').length) {
	var appmap = new Datamap({
		element: document.getElementById("app-map"),
		projection: 'mercator'
	});
}

if (jQuery('#route-map').length) {
	
	if (jQuery('#route-map').attr('data-flight-domestic')) {
		mapScope = 'usa';
	}

	var routemap = new Datamap({
		element: document.getElementById("route-map"),
		scope: mapScope,
		geographyConfig: {
			highlightOnHover: false,
			popupOnHover: false
		}
	});
		
	routemap.arc([
		{
			origin: {
				latitude: jQuery('#route-map').attr('data-origin-lat'),
				longitude: jQuery('#route-map').attr('data-origin-long')
			},
			destination: {
				latitude: jQuery('#route-map').attr('data-dest-lat'),
				longitude: jQuery('#route-map').attr('data-dest-long')
			}
		}
	]);
}

// Test code, just on arcs view
if (jQuery('#arcs').length) {
	var arcs = new Datamap({
		element: document.getElementById("arcs"),
		scope: 'usa',
		fills: {
			defaultFill: "#ABDDA4"
		},
		geographyConfig: {
			highlightOnHover: false,
			popupOnHover: false
		}
	});

	arcs.arc([
		{
			origin: {
				latitude: 40.639722,
				longitude: -73.778889
			},
			destination: {
				latitude: 37.618889,
				longitude: -122.375
			}
		},
		{
			origin: {
				latitude: 30.194444,
				longitude: -97.67
			},
			destination: {
				latitude: 25.793333,
				longitude: -80.290556
			}
		},
		{
			origin: {
				latitude: 39.861667,
				longitude: -104.673056
			},
			destination: {
				latitude: 35.877778,
				longitude: -78.7875
			}
		}
	], {strokeWidth: 1, arcSharpness: 1.4});
}