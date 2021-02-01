$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', function(event) {
        event.preventDefault()
        $(this).hide();
        const questionId = $(this).data('questionId')
        $('form#question-id-' + questionId).removeClass('hidden')
        //$('#question-id-${questionId}').removeClass('hidden')
    })

    $('.question .rate-actions').on('ajax:success', function(event) {
        const rateable = event.detail[0]

        rating = rateable.rating
        id = rateable.id
        result = "Question's rating: " + rating

        $('.question .question-rating').html(result)
    })
});
