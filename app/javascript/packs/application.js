////= require rails/ujs
////= require activestorage
////= require turbolinks
////= require jquery3
////= require popper
////= require bootstrap-sprockets
////= require cocoon
////= require_tree .

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("packs/answers")
require("packs/questions")
require("packs/cocoon")
require("@nathanvda/cocoon")
require("handlebars-loader")
