function resetPhotos()
{
  $(".collapse").collapse({
    toggle: false
  });
  $(".collapse").collapse('hide');

  $('.iosSlider').iosSlider('destroy');
  $(".slider").empty();
  $(".slider").append(
    $("<div>").addClass("loading").append(
      $("<img>").attr("src", "images/loading.gif")
    )
  );
}

function initializeSlider()
{
  $('.iosSlider').iosSlider({
    snapToChildren: true,
    desktopClickDrag: true,
    infiniteSlider: true,
    snapSlideCenter: true,
    responsiveSlideContainer: true,
    responsiveSlides: true
  });
}

function loadByLocation(latitude, longitude, title)
{
  resetPhotos();

  var url = "https://api.instagram.com/v1/media/search?lat="+latitude+"&lng="+longitude+"&client_id=5c7f36fcb0d84a7da3193094da8556fd&distance=5000";
  $.ajax({
    type: 'GET',
    url: url,
    async: false,
    jsonpCallback: 'jsonCallback',
    contentType: "application/json",
    dataType: 'jsonp',
    success: function(json) {
      $('.loading').remove();
      for (index = 0; index < json.data.length; ++index) {
        image = json.data[index];
        $('#photos').append(
          $('<div>').addClass('slide').append(
            $('<a>').attr('href', 'instagram://media?id='+image.id).append(
              $('<img>').attr('src', image.images.standard_resolution.url)
            )
          ).append(
            $('<div>').addClass('meta').append(
              $('<div>').addClass('profile_picture').append(
                $('<a>').attr('href', 'instagram://user?username='+image.user.username).append(
                  $('<img>').attr('src', image.user.profile_picture).addClass('pull-left').addClass('img-rounded')
                )
              )
            ).append(
              $('<div>').addClass('profile_username').append(
                $('<span>').addClass('username').append(
                  $('<a>').attr('href', 'instagram://user?username='+image.user.username).text(image.user.username)
                )
              )
            ).append(
              $('<div>').addClass('caption').append(
                $('<span>').addClass('caption_text').text(image.caption == null ? "" : image.caption.text)
              )
            )
          )
        );
      }
      initializeSlider();
      $(".brand").html(title);
    },
    error: function(e) {
      console.log(e.message);
    }
  });
}

function processLocation(location)
{
  $(".local").attr("data-latitude", location.coords.latitude).attr("data-longitude", location.coords.longitude);
  loadByLocation(location.coords.latitude, location.coords.longitude, 'Local');
}

function handleError(error)
{
  alert("Unable to get location: " + error.message);
}

$(document).ready(function() {
  navigator.geolocation.getCurrentPosition(processLocation, handleError);

  window.addEventListener("load",function() {
    // Set a timeout...
    setTimeout(function(){
      // Hide the address bar!
      window.scrollTo(0, 1);
    }, 0);
  });

  $(".nav li a").on("click", function(event){
    event.preventDefault();

    var latitude = $(this).attr('data-latitude');
    var longitude = $(this).attr('data-longitude');
    var title = $(this).html();

    loadByLocation(latitude, longitude, title); 
    $('.nav li').removeClass('active'); 
    $(this).parent().addClass('active'); 
  });
});