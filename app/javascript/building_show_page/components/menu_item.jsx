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
        <a href='/users/sign_in' className='btn btn-sucess btn-sm'>
          Check Availability
        </a>
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
                {'P'+menu.price}
              </span>
            </h3>
            <p>{menu.description}</p>
            Discount o Meter
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
