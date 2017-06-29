import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import swal from 'sweetalert'

class Page extends Component{
  constructor(props){
    super()

    this.state = {
      cart: props.cart,
      totalPrice: props.totalPrice
    }
  }

  addToCart(e){
    e.preventDefault()
    let menuId = $(e.target).data('menu-id')
    console.log($(e.target))

    $.ajax({
      url: '/line_items',
      method: 'POST',
      data: {
        id: menuId
      },
      success: (response) => {
        this.setState({ 
          cart:       response.items, 
          totalPrice: response.total_price
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
        this.ajaxUpdateQuantity(item, newQuantity)
        break;
      case 'minus':
        newQuantity = item.quantity - 1
        if (newQuantity == 0) {
          newQuantity = 1
        }
        this.ajaxUpdateQuantity(item, newQuantity)
        break;
      case 'delete':
        swal({
          title: 'Are you sure?',
          text: 'It will be removed from your cart.',
          type: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#DD6B55',
          confirmButtonText: 'Yes, remove it!',
          closeOnConfirm: false
        }, () => {
          swal('Deleted!', '', 'success')
          this.ajaxUpdateQuantity(item, 0)
        })
        break;
    }
  }

  ajaxUpdateQuantity(item, quantity) {
    console.log(quantity)
    if (quantity != item.quantity) {
      $.ajax({
        url: `/line_items/${item.id}`,
        method: 'PATCH',
        data: { 
          line_items: { 
            quantity: quantity 
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
  }
 
  renderCartItems(){
    let views
    if(this.state.cart.length > 0) {
      views = this.state.cart.map((item, i) => {
        return(<li className='list-group-item' key={i}>
          <h5 className='list-group-item-heading'>
            {item.menu}
          </h5>
          <p className='building-show-page__cart-item-price'>P {item.price * item.quantity}</p>
          <div className='clearfix'>
            <div className='pull-left'>
              <div className='btn-group'>
                <button onClick={this.updateQuantity.bind(this, item, 'minus')} className='btn btn-xs btn-danger'>
                  <i className='fa fa-minus'></i>
                </button>
                <button className='btn btn-xs btn-default building-show-page__cart-item-quantity'>{item.quantity}</button>
                <button onClick={this.updateQuantity.bind(this, item, 'add')} className='btn btn-xs btn-success'>
                  <i className='fa fa-plus'></i>
                </button>
              </div>
            </div>
            <div className='pull-right'>
              <button className='btn btn-xs btn-danger' onClick={this.updateQuantity.bind(this, item, 'delete')}><i className='fa fa-trash'></i></button>
            </div>
          </div>
        </li>) 
      })

      views.push(
        <li className='list-group-item'>
          <div className='clearfix'>
            <span className='pull-left'>
              Total Price: 
            </span>
            <span className='pull-right'>
              {this.state.totalPrice}
            </span>
          </div>
        </li>
      )
    } else {
      views = 'No items yet.'
    }
    return views
  }

  renderCartButtons(menu){
    if(this.props.userSignedIn) {
      return(
        <a href='#' data-menu-id={menu.id} onClick={this.addToCart.bind(this)} className='btn btn-success btn-sm'>
          <i className='fa fa-plus'></i>
          &nbsp;Add To Cart
        </a>
      )
    } else {
      return(
        <a href='/users/sign_in' data-menu-id={menu.id} className='btn btn-success btn-sm'>
          Check Availability
        </a>
      )
    }
  }

  renderMenus(){
    var renderedMenus = this.props.menus.map((menu, i) => {
      return(<div key={i} className='building-show-page__menu-item'>
        <div className='panel panel-default' style={{borderRadius: '5px'}}>
          <div className='panel-body building-show-page__menu-item-panel-body'>
            <div className='building-show-page__menu-item-picture' style={{backgroundImage: 'url(' + menu.image + ')'}}>
            </div>
            <div className='building-show-page__menu-item-title'>
              <h3 className='clearfix'>
                <span className='pull-left'>
                  {menu.name}
                </span>
                <span className='pull-right'>
                  {'P'+menu.price}
                </span>
              </h3>
              <p>{menu.description}</p>
            </div>
          </div>
          <div className='panel-footer building-show-page__menu-item-panel-footer'>
            <div className='btn-group btn-group-justified'>
              <a href='#' className='btn btn-default btn-sm'><i className='fa fa-shopping-cart'></i> { menu.count } Orders</a>
              <a href='#' className='btn btn-info btn-sm'><i className='fa fa-comments'></i> Comments</a>
              {this.renderCartButtons(menu)}
            </div>
          </div>
        </div>
      </div>) 
    })

    return renderedMenus
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
        </div>
      </div>
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
