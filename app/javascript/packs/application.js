// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import Vue from 'vue/dist/vue.esm'
import Payment from "../components/Payment"
import "bootstrap"
import "../stylesheets/application"

document.addEventListener("turbolinks:load", function() {
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
        $('[data-toggle="popover"]').popover()
    })
})
document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '[data-behavior="vue-app"',
    components: {Payment}
  })
})

Rails.start()
Turbolinks.start()
ActiveStorage.start()
