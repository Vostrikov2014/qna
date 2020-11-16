import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
        received(data) {
            if (gon.user_id === data.user_id) return;  //здесь нехватает проверки на пользователя, чтобы дважды не добавлять коммент

            const template = require('./templates/comment.hbs')
            if (data['commentable_type'] == 'Question') {
                $('#question-'+ gon.question_id +' .comments').append(template(data))
            } else {
                $('.answers #answer-id-'+ data['commentable_id'] +' .comments').append(template(data))
            }
        }
    });
});
