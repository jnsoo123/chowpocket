import React, { Component } from 'react';
import CartItem from './cart_item'

class ShoppingCart extends Component {
  renderCartItems(){
    let views
    if (this.props.cart.length > 0) {
      views = this.props.cart.map((item, i) => {
        return(
          <CartItem
            {...item}
            key={i}
            updateQuantity={this.props.updateQuantity}
          />
        ) 
      }, this)

      views.push(
        <li key={this.props.cart.length+1} className='list-group-item'>
          <div className='clearfix'>
            <span className='pull-left'>
              Total Price: 
            </span>
            <span className='pull-right'>
              {this.props.totalPrice}
            </span>
          </div>
        </li>
      )
    } else {
      views = 'Your cart is empty!'
      if (!this.props.userSignedIn){
        views += ' Login to order.'
      }
    }
    return views
  }

  renderCheckoutButton(){
    if (this.props.cart.length > 0){
      return(<div>
        <a href='/checkouts' className='btn btn-success btn-block'>
          <i className='fa fa-check'></i>
          <span style={{marginLeft: '5px'}}>
            Checkout
          </span>
        </a>
        <a href='#' onClick={this.props.emptyCart.bind(this)} className='btn btn-danger btn-block'>
          <i className='fa fa-times'></i>
          <span style={{marginLeft: '5px'}}>
            Empty Cart
          </span>
        </a>
      </div>)
    }
  }

  render(){
    return(
      <div className='well'>
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
    )
  }
}

export default ShoppingCart
