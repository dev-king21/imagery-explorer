// 'use strict';

function initMap(objects) {
    var myCoords = new google.maps.LatLng(objects[0]['latitude'], objects[0]['longitude']);
    var mapOptions = {
        center: myCoords,
        streetViewControl: false,
        zoom: 15
    };

    var map = new google.maps.Map(document.getElementById('map'), mapOptions);

    for (var i=0; i < objects.length; i++){
        var markerData = objects[i];
        var latLng = new google.maps.LatLng(markerData.latitude, markerData.longitude);

        var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            animation: google.maps.Animation.DROP,
            photo: objects[i]
        });

        google.maps.event.addListener(marker, 'click', function() {
            showThumbModal(this.photo);
        });
    }
}

function initElevationChart(data, photos) {
    var chartData = [];
    for (var key in data) {
        if (data.hasOwnProperty(key)) {
            chartData.push([Date.parse(key), data[key]]);
        }
    }

    $('#elevation-chart-container').highcharts({
        chart: {
            type: 'scatter',
            zoomType: 'xy'
        },
        title: {
            text: ''
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            tickInterval: (24 * 3600 * 1000), // the number of milliseconds in a day
            allowDecimals: false,
            title: {
                text: 'Date',
                scalable: false
            },
            type: 'datetime',
            labels: {
                formatter: function() {
                    return Highcharts.dateFormat('%d-%b-%y', (this.value));
                }
            }
        },
        yAxis: {
            title: {
                text: 'Elevation Meter'
            }
        },
        series: [{
            "name": "Elevation Change",
            "data": chartData
        }],
        plotOptions: {
            series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function () {
                            // alert('Category: ' + this.category + ', value: ' + this.y);
                            for (var i = 0; i < photos.length; i++) {
                                var p = photos[i];
                                if (milisecondsToDatetime(p.taken_at) === milisecondsToDatetime(this.category)) {
                                    return showThumbModal(p);
                                }
                            }
                        }
                    }
                }
            }
        },
        tooltip: {
            formatter: function() {
                return new Date(this.x).toLocaleDateString()  + ': ' + this.y;
            }
        }

    });
}

function milisecondsToDatetime(miliseconds) {
    return new Date(miliseconds).toLocaleTimeString()
}

function showThumbModal(photo) {
    if (photo
        && photo.image
        && photo.image.thumb
        && photo.streetview) {
        favorite_score = photo.favoritable_score.favorite || 0
        $('#imageContainer').empty();
        $('.modal-title').prepend(photo.filename);
        $('#imageContainer').prepend('<span class="viewpoint" data-photo-id="' + photo.id + '"><i class="fa fa-star"></i><span>' + favorite_score + '</span></span><a href="/photos/' + photo.id + '"><img id="photoImg" src="' + photo.image.thumb.url + '" style="width: 100%" /><div class="card-body"><p class="card-text">Latitude: ' + photo.latitude + '</p><p class="card-text">Longitude: ' + photo.longitude + '</p><p class="card-text">Photo elevation: ' + photo.elevation_meters + '</p><p class="card-text">Capture time: ' + photo.taken_at + '</p></div></a>');

        $('#showPhotoModal').modal('show');
    }
    return;
}
