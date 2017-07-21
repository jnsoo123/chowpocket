import React, { Component } from 'react';

class MenuItem extends Component {
  renderCartButtons(){
    if(this.props.userSignedIn) {
      return(
        <a 
          href='#' 
          data-menu-id={this.props.id} 
          className='btn btn-success btn-sm'
          onClick={this.props.addToCart}>
          <i className='fa fa-plus' /> Add to Cart
        </a>
      ) 
    } else {
      return(
        <a href='/users/sign_in' className='btn btn-success btn-sm'>
          Check Availability
        </a>
      ) 
    }
  }

  getCountLeftForDiscount(count){
    let text = ''

    switch(true) {
      case count < 30:
        text = (30 - count) + ' orders left for 10% discount'
        break
      case count >= 30 && count < 40:
        text = (40 - count) + ' orders left for 20% discount'
        break
      case count >= 40 && count < 50:
        text = (50 - count) + ' orders left for 30% discount'
        break
    }

    return text
  }

  isDiscounted(){
    if (this.props.percent != 0) {
      return(
        <span className='label label-danger'>Discounted!</span>
      ) 
    }
  }

  render() {
    let menu = this.props

    let meterColor
    switch(menu.percent){
      case 10:
        meterColor = 'success'
        break
      case 20:
        meterColor = 'warning'
        break
      case 30:
        meterColor = 'danger'
        break
    }

    return(<div className='building-show-page__menu-item'>
      <div className='panel panel-default' style={{borderRadius: '5px'}}>
        <div className='panel-body building-show-page__menu-item-panel-body'>
          <div 
            className='building-show-page__menu-item-picture' 
            style={{backgroundImage: 'url(' + menu.image + ')'}} />
          <div className='building-show-page__menu-item-title'>
            <h3 className='clearfix'>
              <span className='pull-left'>
                {menu.name}
              </span>
              <span className='pull-right'>
                {'P' + menu.price.toFixed(2)}
              </span>
            </h3>
            {this.isDiscounted()}
            <p>{menu.description}</p>
            <div className='clearfix'>
              <div className='pull-left'>
                Discount o Meter
                <button className='btn btn-link btn-xs' data-toggle='modal' data-target='#discountMeterInfoModal'>
                  <i className='fa fa-info'></i>
                </button>
              </div>
              <div className='pull-right'>
                {this.getCountLeftForDiscount(menu.count)}
              </div>
            </div>
            <div className='progress'>
              <div 
                className={'progress-bar progress-bar-'+meterColor} 
                style={{width: ((menu.percent/30)*100)+'%'}}>
                {menu.percent + '%'}
              </div>
            </div>
          </div>
        </div>
        <div className='panel-footer building-show-page__menu-item-panel-footer'>
          <div className='btn-group btn-group-justified'>
            <a href='#' className='btn btn-default btn-sm'>
              <i className='fa fa-shopping-cart' /> {menu.count} Orders
            </a>
            <a href='#' className='btn btn-info btn-sm'>
              <i className='fa fa-comments' /> Comments
            </a>
            {this.renderCartButtons()}
          </div>
        </div>
      </div>
    </div>)
  }
}

export default MenuItem
