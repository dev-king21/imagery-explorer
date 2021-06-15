$(function(){
   $(document).on('click', '.viewpoint', function (e) {
       target = $(this)

       var photoId = $(this).data('photo-id')

       var apiKey = localStorage.getItem('api_token');

       if (!apiKey || apiKey === '') {
           return alert('Please sign in/sign up to mark viewpoint');
       }

       $.ajax({
           type: 'POST',
           url: '/api/v1/viewpoints',
           data: {
                   photo_id: photoId
           },
           dataType: "json",
           headers: {
               'api-key': localStorage.getItem('api_token'),
           },
           beforeSend: function(x) {
               if (x && x.overrideMimeType) {
                   x.overrideMimeType("application/j-son;charset=UTF-8");
               }
           },
           success: function(data){
                if (data.viewpoint && typeof data.viewpoint === 'object') {
                    target.find('span').text(data.viewpoint.count)
                }
            },
           failure: function(errMsg) {
               console.log(errMsg);
           }
       })
   })
});
