import React from 'react'
import {main as CheckoutPage} from './components/page'

document.addEventListener('turbolinks:load', () => {
    CheckoutPage.initialize()
})

document.addEventListener('turbolinks:before-cache', () => {
    CheckoutPage.uninitialize()
})
