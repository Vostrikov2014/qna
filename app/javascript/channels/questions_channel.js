import consumer from "./consumer"

$(document).on('turbolinks:load', function () {      //тут точно не надо обернуть в турболинкс-лоад?
    consumer.subscriptions.create("QuestionsChannel", {
        received(data) {
            const template = require('./templates/question.hbs')
            $('.questions').append(template(data))
        }
    });
});
