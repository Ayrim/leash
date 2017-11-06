//= require_tree .
    var walkerMap;
    var marker;

    $(document).ready(function(){
        $('#collapsibleFilter').collapsible();
    });

    ShowGeoLocation();


    function createMarker(latitude, longitude, title){
        alert(walkerMap);
        marker = new google.maps.Marker({
            position: {lat: latitude, lng: longitude},
            map: walkerMap,
            title: title,
            visible: true
        });
    }

    function OtherAddressChanged(showInputFields)
    {
        if(!showInputFields)
        {
            addClass(document.getElementById('otherAddressInputFields'), 'hide');
        }
        else
        {
            removeClass(document.getElementById('otherAddressInputFields'), 'hide');
        }
    }

    function updateTextInput(val) {
        document.getElementById('rangefield').textContent=val;
    }

    function ShowGeoLocation() {
        var street = "<%= current_user.try(:address).try(:street) %>" + "";
        var city = "<%= current_user.try(:address).try(:city).try(:name) %>" + "";
        var country = "<%= current_user.try(:address).try(:country).try(:name) %>" + "";

        var latitude = Number("<%= current_user.try(:address).try(:latitude) %>");
        var longitude = Number("<%= current_user.try(:address).try(:longitude) %>");

        var address = street + ', ' + city + ', ' + country;
        if (address === "0, 0, 0") {
            address = "Brussel, Belgium";
        }

        var geocoder = new google.maps.Geocoder();

        if(document.getElementById('map-canvas2') != undefined)
        {
            walkerMap = new google.maps.Map(document.getElementById('map-canvas2'), {
                zoom: 13,
                center: { lat: latitude, lng: longitude },
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                scrollwheel: true,
                draggable: true,
                zoomControl: true,
                zoomControlOptions: {
                    position: google.maps.ControlPosition.RIGHT_TOP
                },
                streetViewControl: false,
                styles: [{ "featureType": "landscape.natural", "elementType": "geometry.fill", "stylers": [{ "visibility": "on" }, { "color": "#e0efef" }] }, { "featureType": "poi", "elementType": "geometry.fill", "stylers": [{ "visibility": "on" }, { "hue": "#1900ff" }, { "color": "#c0e8e8" }] }, { "featureType": "road", "elementType": "geometry", "stylers": [{ "lightness": 100 }, { "visibility": "simplified" }] }, { "featureType": "road", "elementType": "labels", "stylers": [{ "visibility": "off" }] }, { "featureType": "transit.line", "elementType": "geometry", "stylers": [{ "visibility": "on" }, { "lightness": 700 }] }, { "featureType": "water", "elementType": "all", "stylers": [{ "color": "#7dcdcd" }] }],
                mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
                navigationControl: false,
                navigationControlOptions: { style: google.maps.NavigationControlStyle.SMALL }
            });
            alert(walkerMap);
            //geocodeAddress(address, geocoder, walkerMap);
        }
    };

    function geocodeAddress(address, geocoder, resultsMap) {
        geocoder.geocode({ 'address': address }, function (results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
                resultsMap.setCenter(results[0].geometry.location);
                var marker = new google.maps.Marker({
                    map: resultsMap,
                    position: results[0].geometry.location
                });
            } else {
                alert('Geocode was not successful for the following reason: ' + status);
            }
        })
    };



    function addClass(el, className) {
        if (el.classList)
            el.classList.add(className)
        else if (!hasClass(el, className)) el.className += " " + className
    }

    function removeClass(el, className) {
        if (el.classList)
            el.classList.remove(className)
        else if (hasClass(el, className)) {
            var reg = new RegExp('(\\s|^)' + className + '(\\s|$)')
            el.className=el.className.replace(reg, ' ')
      }
    }