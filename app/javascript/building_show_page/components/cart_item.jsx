import React, { Component } from 'react'

class CartItem extends Component {
  incrementQuantity(e){
    e.preventDefault()
    this.props.updateQuantity(this.props, 'add')  
  }

  decrementQuantity(e){
    e.preventDefault()
    this.props.updateQuantity(this.props, 'minus')  
  }

  deleteItem(e){
    e.preventDefault()
    this.props.updateQuantity(this.props, 'delete')
  }

  render(){
    let item = this.props
    return(<li className='list-group-item'>
      <h5 className='list-group-item-heading'>
        {item.menu} 
      </h5>
      <p className='building-show-page__cart-item-price'>
        P {item.price * item.quantity}
      </p>
      <div className='clearfix'>
        <div className='pull-left'>
          <div className='btn-group'>
            <button onClick={this.decrementQuantity.bind(this)} className='btn btn-xs btn-danger'>
              <i className='fa fa-minus' />
            </button>
            <button className='btn btn-xs btn-default building-show-page__cart-item-quantity'>
              {item.quantity}
            </button>
            <button onClick={this.incrementQuantity.bind(this)} className='btn btn-xs btn-success'>
              <i className='fa fa-plus' />
            </button>
          </div>
        </div>
        <div className='pull-right'>
          <button className='btn btn-xs btn-danger' onClick={this.deleteItem.bind(this)}>
            <i className='fa fa-trash' />
          </button>
        </div>
      </div>
    </li>)
  }
}

export default CartItem
