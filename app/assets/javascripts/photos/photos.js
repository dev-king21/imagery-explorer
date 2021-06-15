function initSceneMap(objects) {
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
      photo: objects[i],
      tourer_photo_id: objects[i].tourer_photo_id
    });

    markers.push(marker)

    google.maps.event.addListener(marker, 'click', function() {
      viewer.loadScene(this.photo.tourer_photo_id)
    });
  }
}

document.addEventListener("DOMContentLoaded", function(){
  if (gon.pannellum_config === undefined) {
    return false;
  }
  console.log(gon.pannellum_config)
  markers = []

  viewer = pannellum.viewer('panorama', gon.pannellum_config);

  initSceneMap(gon.photos);

  currentScene = viewer.getScene()

  currentMarker = markers.find(obj => obj.tourer_photo_id == currentScene)
  currentMarker.setAnimation(google.maps.Animation.BOUNCE)

  viewer.on('scenechange', function (){
    hotSpot = gon.pannellum_config.scenes[currentScene].hotSpots.find(obj => obj.sceneId == viewer.getScene())
    photo = gon.photos.find(obj => obj.tourer_photo_id == viewer.getScene())

    iframe_url = '<iframe width="600" height="400" allowfullscreen style="border-style:none;" src="https://cdn.pannellum.org/2.5/pannellum.htm#panorama=' + photo.image.med.url + '&amp;title=' + encodeURIComponent(gon.tour_name) + '&amp;author=' + encodeURIComponent(gon.author_name) + '&amp;autoLoad=true"></iframe><p><a href="' + gon.root_url + 'photos/' + photo.id + '" target="_blank">View on Trek View Explorer</a></p>'

    $('.custom-tooltip').text(iframe_url)

    if (hotSpot) {
      viewer.setYaw(hotSpot.yaw)
    }

    prevMarker = markers.find(obj => obj.tourer_photo_id == currentScene)

    currentScene = viewer.getScene()

    currentMarker = markers.find(obj => obj.tourer_photo_id == currentScene)

    prevMarker.setAnimation(google.maps.Animation.DROP)
    currentMarker.setAnimation(google.maps.Animation.BOUNCE)
  });
});
