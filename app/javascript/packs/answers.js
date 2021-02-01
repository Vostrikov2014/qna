$(document).on('turbolinks:load', function() {
    $('.answers').on('click', '.edit-answer-link', function(event) {
        event.preventDefault()
        $(this).hide();
        const answerId = $(this).data('answerId')
        $('form#edit-answer-' + answerId).removeClass('hidden')
        //$(`#edit-answer-${answerId}`).removeClass('hidden');
    })

    $('.answers .rate-actions').on('ajax:success', function(event) {
        const rateable = event.detail[0]

        rating = rateable.rating
        id = rateable.id
        result = "Answer's rating: " + rating

        $('.answers #answer-id-'+ id +' .answer-rating').html(result)
    })
});
