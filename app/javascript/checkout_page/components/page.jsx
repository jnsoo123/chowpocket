import React, {Component} from 'react'
import ReactDOM from 'react-dom'

class Page extends Component {
  constructor(props){
    super()
    this.state = {
      items: props.cart,
      totalPrice: props.totalPrice
    }
  }

  componentDidMount(){
    $(window).on('popstate', function(e){
      e.preventDefault()
      location.href = '/'
    })
  }

  orderNow(e){
    e.preventDefault()
    $.ajax({
      url: '/orders',
      method: 'POST'
    })
  }

  removeOrder(item, e){
    e.preventDefault()  
    $.ajax({
      url: `/line_items/${item.id}`,
      method: 'PATCH',
      data: {
        line_items: { quantity: 0 }
      },
      success: (response) => {
        this.setState({
          items: response.items,
          totalPrice: response.total_price
        }) 
      }
    })
  }

  renderItems(){
    let view = this.state.items.map((item, i) => {
      if(item.quantity != 0) {
        return(<tr key={i}>
          <td>{item.menu}</td> 
          <td>{item.quantity}</td>
          <td>{(item.price * item.quantity).toFixed(2)}</td>
          <td>
            <button className='btn btn-danger btn-xs' onClick={this.removeOrder.bind(this, item)}>Remove Order</button>
          </td>
        </tr>)
      }
    })

    return view
  }

  renderCheckoutInfo(){
    if (this.state.items.length > 0) {
      return(
        <div className='checkout-page'>
          <table className='table table-striped'>
            <thead>
              <tr>
                <th>Menu</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {this.renderItems()}
              <tr>
                <td colSpan='4' style={{'borderBottom': '1px solid black'}}></td>
              </tr>
              <tr>
                <td colSpan='2'>Total Price:</td>
                <td>{this.state.totalPrice}</td>
              </tr>
            </tbody>
          </table>
          <div className='btn-group'>
            <button className='btn btn-success' onClick={this.orderNow.bind(this)}>Order Now</button>
            <a href='/' className='btn btn-default'>Continue Shopping</a>
          </div>
        </div>
      )
    } else {
      return(<div>
        <h3>You don't have any orders.</h3>
        <br />
        <a href='/' className='btn btn-success'>Go back</a>
      </div>) 
    }
  }

  render(){
    return(<div>
      <h2>
        Checkout Page
      </h2>
      <hr />
      {this.renderCheckoutInfo()}
    </div>) 
  }
}

const main = {
  initialize(){
    let rootElem = $('.checkout-page')
    if (rootElem[0]) {
      ReactDOM.render(
        <Page
          cart={rootElem.data('cart')}
          totalPrice={rootElem.data('total-price')}
        />, rootElem[0]
      )
    }
  },

  uninitialize(){
    let rootElem = document.querySelector('.checkout-page')
    if(rootElem) {
      ReactDOM.unmountComponentAtNode(rootElem)
    }
  }
}

export {main}
