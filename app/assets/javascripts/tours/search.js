// 'use strict';

$(function(){

    $('.search-text-input').keyup(function (e) {
        setTimeout(function () {
            submitTourSearch();
        }, 1000);
    });

    $(document).on('change', '.select-country, .select-tour-type', function(){
        submitTourSearch();
    });
});

function submitTourSearch() {
    return;
    var form = $('form.index-search-form');
    var valuesToSubmit = form.serialize();

    $.ajax({
        url: '/search_tours',
        method: 'GET',
        data: valuesToSubmit,
        success: function (response) {
            var container = $('.tours-container');
            container.html(response);
        }
    });
    return false;
}