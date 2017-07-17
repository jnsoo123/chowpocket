import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import swal from 'sweetalert'
import MenuItem from './menu_item'
import CartItem from './cart_item'
import ModalInfo from './modal_info'

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

    $.ajax({
      url: '/line_items',
      method: 'POST',
      data: {
        id: menuId
      },
      success: (response) => {
        swal({
          title: 'Food added to cart!',
          timer: 1000,
          showConfirmButton: false,
          type: 'success'
        })
        this.setState({ 
          cart:       response.items, 
          totalPrice: response.total_price
        })
      }
    })
  }

  emptyCart(e) {
    e.preventDefault()
    swal({
      title: 'Are you sure?',
      text: 'You will not be able to recover your cart items',
      type: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#DD6B55',
      confirmButtonText: "Yes, I'm sure.",
      closeOnConfirm: false,
      closeOnCancel: true
    }, (isConfirm) => {
      if(isConfirm) {
        swal(
          'Emptied!',
          'Your cart has been emptied!',
          'success'
        )
        $.ajax({
          url: '/line_items',
          method: 'DELETE',
          success: (response) => {
            this.setState({
              cart: response.items,
              totalPrice: response.total_price
            })
          }
        })
      } 
    })
  }

  updateQuantity(item, type){
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
    if (this.state.cart.length > 0) {
      views = this.state.cart.map((item, i) => {
        return(
          <CartItem
            {...item}
            key={i}
            updateQuantity={this.updateQuantity.bind(this)}
          />
        ) 
      }, this)

      views.push(
        <li key={this.state.cart.length+1} className='list-group-item'>
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
      return(
        <MenuItem
          {...menu}
          key={i}
          userSignedIn={this.props.userSignedIn}
          addToCart={this.addToCart.bind(this)}
        />
      ) 
    }, this)

    return renderedMenus
  }

  renderCheckoutButton(){
    if (this.state.cart.length > 0){
      return(<div>
        <a href='/checkouts' className='btn btn-success btn-block'>
          <i className='fa fa-check'></i>
          <span style={{marginLeft: '5px'}}>
            Checkout
          </span>
        </a>
        <a href='#' onClick={this.emptyCart.bind(this)} className='btn btn-danger btn-block'>
          <i className='fa fa-times'></i>
          <span style={{marginLeft: '5px'}}>
            Empty Cart
          </span>
        </a>
      </div>)
    }
  }

  render(){
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
      <ModalInfo />
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
