import React, {Component} from 'react'
import ReactDOM from 'react-dom'

class Page extends Component{
  constructor(){
    super()
  }

  renderMenus(){
    var renderedMenus = this.props.menus.map((menu, i) => {
      return(<div key={i} className='building-show-page__menu-item'>
        <div className='panel panel-default'>
          <div className='panel-body'>
            <h3 className='clearfix'>
              <span className='pull-left'>
                {menu.name}
              </span>
              <span className='pull-right'>
                {'P'+menu.price}
              </span>
            </h3>
            <br />
            <div className='building-show-page__menu-item-picture'>
              pic here
            </div>
          </div>
          <div className='panel-footer'>
            <div className='clearfix'>
              <div className='pull-left'>
                <p>
                  Order Counter: {menu.count}
                </p>
              </div>
              <div className='pull-right'>
                <a href='#' className='btn btn-success'>
                  Order Now
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>) 
    })

    return renderedMenus
  }

  render(){
    console.log(this.props.menus)
    return(<div className='building-show-page__main'>
      {this.renderMenus()}
    </div>)
  }
}

const main = {
  initialize(){
    let rootElem = document.querySelector('.building-show-page')
    if (rootElem) {
      ReactDOM.render(
        <Page
          menus={jQuery.parseJSON(rootElem.dataset['menus'])}
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
