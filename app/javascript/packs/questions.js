$(document).on('turbolinks:load', function () {
    $('#question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        console.log(questionId)
        $(`#edit-question-${questionId}`).removeClass('hidden');
    })
})
