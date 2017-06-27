import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import SweetAlert from 'sweetalert-react'
import update from 'immutability-helper'

class Page extends Component{
  constructor(props){
    super()

    this.state = {
      cart: props.cart,
      totalPrice: props.totalPrice,
      sweetAlert: false
    }
  }

  addToCart(e){
    e.preventDefault()
    let menuId = $(e.target).data('menu-id')

    $.ajax({
      url: '/line_items',
      method: 'POST',
      data: {
        id: menuId
      },
      success: (response) => {
        this.setState({ 
          cart:       response.items, 
          totalPrice: response.total_price,
          sweetAlert: true 
        })
      }
    })
  }

  updateQuantity(item, type, e){
    e.preventDefault()

    let items = this.state.cart
    let index = items.indexOf(item)
    let newQuantity
    let updatedItem

    switch(type) {
      case 'add':
        newQuantity = item.quantity + 1
        break;
      case 'minus':
        newQuantity = item.quantity - 1
        break;
    }

    $.ajax({
      url: `/line_items/${item.id}`,
      method: 'PATCH',
      data: { 
        line_items: { 
          quantity: newQuantity 
        } 
      },
      success: (response) => {
        this.setState({
          cart: response.items,
          totalPrice: response.total_price
        }) 
      }
    })
  }

 
  renderCartItems(){
    let views
    if(this.state.cart.length > 0) {
      views = this.state.cart.map((item, i) => {
        return(<li className='list-group-item' key={i}>
          <span className='badge'>P{item.price * item.quantity}</span>
          <div className='btn-group' style={{marginRight: '7px'}}>
            <button onClick={this.updateQuantity.bind(this, item, 'add')} className='btn btn-xs btn-success'>
              <i className='fa fa-plus'></i>
            </button>
            { item.quantity > 0 ? <button onClick={this.updateQuantity.bind(this, item, 'minus')} className='btn btn-xs btn-danger'><i className='fa fa-minus'></i></button> : '' }
          </div>
          {item.menu} x {item.quantity}
        </li>) 
      })
    } else {
      views = 'No items yet.'
    }
    return views
  }

  renderCartButtons(menu){
    if(this.props.userSignedIn) {
      return(
        <a href='#' data-menu-id={menu.id} onClick={this.addToCart.bind(this)} className='btn btn-success'>
          Add To Cart
        </a>
      )
    } else {
      return(
        <a href='#' data-menu-id={menu.id} className='btn btn-success'>
          Check Availability
        </a>
      )
    }
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
            <div className='building-show-page__menu-item-picture' style={{backgroundImage: 'url(' + menu.image + ')'}}>
            
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
                {this.renderCartButtons(menu)}
              </div>
            </div>
          </div>
        </div>
      </div>) 
    })

    return renderedMenus
  }

  renderSweetAlert(){
    return(
      <SweetAlert
        show={this.state.sweetAlert}
        title='Order Added!'
        text='Your cart has been updated!'
        type='success'
        onConfirm={() => this.setState({ sweetAlert: false })}
      />
    )
  }

  renderCheckoutButton(){
    if (this.state.cart.length > 0){
      return(
        <a href='/checkouts' className='btn btn-success btn-block'>
          <i className='fa fa-check'></i>
          <span style={{marginLeft: '5px'}}>
            Checkout
          </span>
        </a>
      )
    }
  }

  render(){
    console.log(this.props.menus)
    return(<div className='building-show-page__main'>
      <div className='row'>
        <div className='col-xs-8'>
          {this.renderMenus()}
        </div>
        <div className='col-xs-4'>
          <h3>
            <i className='fa fa-shopping-cart'></i>
            <span style={{marginLeft: '5px'}}>
              Shopping Cart
            </span>
          </h3>
          <hr />
          <ul className='list-group'>
            {this.renderCartItems()}
          </ul>
          {this.renderCheckoutButton()}
        </div>
      </div>
      {this.renderSweetAlert()}
    </div>)
  }
}

const main = {
  initialize(){
    let rootElem = $('.building-show-page')
    if (rootElem[0]) {
      ReactDOM.render(
        <Page
          menus={rootElem.data('menus')}
          cart={rootElem.data('cart')}
          cartId={rootElem.data('cart-id')}
          totalPrice={rootElem.data('total-price')}
          userSignedIn={rootElem.data('user-logged-in')}
        />, rootElem[0]
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
