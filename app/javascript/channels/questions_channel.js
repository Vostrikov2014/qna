import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
    consumer.subscriptions.create("QuestionsChannel", {
        received(data) {
            const template = require('./templates/question.hbs')
            $('.questions').append(template(data))
        }
    });
});
