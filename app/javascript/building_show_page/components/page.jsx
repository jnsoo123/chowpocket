import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import SweetAlert from 'sweetalert-react'

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

  renderCartItems(){
    let views = this.state.cart.map((item, i) => {
      return(<tr key={i}>
        <td>{item.menu}</td>
        <td>{item.quantity}</td>
        <td>{item.price}</td>
      </tr>) 
    })

    return views
  }

  renderModalBody(){
    if (this.state.cart.length){
      return(<div> 
        <div className='modal-body'>
          <table className='table'>
            <thead>
              <tr>
                <th>Name</th>
                <th>Quantity</th>
                <th>Price</th>
              </tr>
            </thead>
            <tbody className='cart-items'>
              {this.renderCartItems()}
              <tr>
                <td colSpan='3'></td>
              </tr>
              <tr>
                <td colSpan='2'>Total Price</td>
                <td>{this.state.totalPrice}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div className='modal-footer'>
          <button className='btn btn-default' data-dismiss='modal'>
            Continue Shopping
          </button>
          <a href='#' className='btn btn-primary'>
            Contine to Checkout Page
          </a>
        </div>
      </div>)
    } else {
      return(<div> 
        Please order first.
      </div>)
    }
  }

  renderModal(){
    return(<div className='modal fade' id='cart-modal' role='dialog' aria-labelledby='cart-modal-label'>
      <div className='modal-dialog' role='document'>
        <div className='modal-content'>
          <div className='modal-header'>
            <button className='close' type='button' data-dismiss='modal' aria-label='Close'>
              <span aria-hidden='true'>
                &times;
              </span>
            </button>
            <h4 className='modal-title' id='cart-modal-label'>
              View Cart
            </h4>
          </div>
          {this.renderModalBody()}
        </div>
      </div>
    </div>) 
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
                <a href='#' data-menu-id={menu.id} onClick={this.addToCart.bind(this)} className='btn btn-success'>
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

  render(){
    return(<div className='building-show-page__main'>
      {this.renderMenus()}
      {this.renderModal()}
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
          totalPrice={rootElem.data('total-price')}
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
