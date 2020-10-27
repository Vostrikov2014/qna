$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (event) {
        event.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        console.log(answerId);
        $(`#edit-answer-${answerId}`).removeClass('hidden');
    })
})
