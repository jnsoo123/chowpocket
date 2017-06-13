import React, {Component} from 'react'
import ReactDOM from 'react-dom'

class Page extends Component{
  constructor(){
    super()
  }

  render(){
    return(<div className='building-show-page__main'>
      <p>Test hello</p> 
    </div>)
  }
}

const main = {
  initialize(){
    let rootElem = document.querySelector('.building-show-page')
    if (rootElem) {
      ReactDOM.render(
        <Page
          
        />, rootElem
      )
    }
  },

  uninitialize(){
    let rootElem = document.querySelector('.building-show-page')
    if(rootElem){
      ReactDOM.unmountComponentAtNode(rootElem)
    }
  }
}

export {main}
