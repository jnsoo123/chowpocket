import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import swal from 'sweetalert'
import MenuItem from './menu_item'
import ModalInfo from './modal_info'
import ShoppingCart from './shopping_cart'

class Page extends Component{
  constructor(props){
    super()

    this.state = {
      cart: props.cart,
      totalPrice: props.totalPrice
    }
  }

  componentDidMount() {
    let url         = new URL(window.location.href)
    let loginParams = url.searchParams.get('login')

    if(loginParams && !this.props.userSignedIn){
      $('#signup-modal').modal('show')
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
    var views = []
    if(this.props.menus.length) {
      views = this.props.menus.map((menu, i) => {
        return(
          <MenuItem
            {...menu}
            key={i}
            userSignedIn={this.props.userSignedIn}
            addToCart={this.addToCart.bind(this)}
          />
        ) 
      }, this)
    } else {
      views.push(<div className='well' style={{padding: '100px 50px'}}>
        <h3 className='text-center'>There is no food for today!</h3> 
      </div>)
    }

    return views
  }

  render(){
    return(<div className='building-show-page__main'>
      <div className='row'>
        <div id='smallScreen' className='col-xs-12'>
          <ShoppingCart
            cart={this.state.cart} 
            emptyCart={this.emptyCart.bind(this)}
            updateQuantity={this.updateQuantity.bind(this)}
            userSignedIn={this.props.userSignedIn}
            totalPrice={this.state.totalPrice}
          />
        </div>
        <div className='col-md-8 col-xs-12'>
          {this.renderMenus()}
        </div>
        <div id='largeScreen' className='col-md-4 col-xs-12'>
          <ShoppingCart 
            cart={this.state.cart} 
            emptyCart={this.emptyCart.bind(this)}
            updateQuantity={this.updateQuantity.bind(this)}
            userSignedIn={this.props.userSignedIn}
            totalPrice={this.state.totalPrice}
          />
        </div>
      </div>
      <ModalInfo
        modalInfo={this.props.modalInfo}
      />
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
          modalInfo={rootElem.data('modal-info')}
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
