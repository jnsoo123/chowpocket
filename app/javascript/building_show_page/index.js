import React from 'react'
import {main as BuildingShowPage} from './components/page'

console.log(123)

document.addEventListener('turbolinks:load', () => {
    BuildingShowPage.initialize()
})

document.addEventListener('turbolinks:before-cache', () => {
    BuildingShowPage.uninitialize()
})
