import React from 'react'
import {main as BuildingShowPage} from './components/page'

document.addEventListener('turbolinks:load', () => {
    BuildingShowPage.initialize()
})

document.addEventListener('turbolinks:before-cache', () => {
    BuildingShowPage.uninitialize()
})
