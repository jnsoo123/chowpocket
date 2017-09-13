import React, { Component } from 'react';

class MenuItem extends Component {
  renderCartButtons(){
    if(this.props.userSignedIn) {
      return(
        <a 
          href='#' 
          data-menu-id={this.props.id} 
          className='btn btn-success btn-sm btn-order'
          onClick={this.props.addToCart}>
          <i className='fa fa-plus' /> Add to Cart
        </a>
      ) 
    } else {
      return(
        <a href='/users/sign_in' className='btn btn-success btn-sm btn-order'>
          Check Availability
        </a>
      ) 
    }
  }

  isDiscounted(){
    if (this.props.percent != 0) {
      return(
        <span className='label label-danger'>-{this.props.percent}%</span>
      ) 
    }
  }

  moreDiscountInfo(){
    let menuCount = this.props.count
    let views     = []

    if(menuCount < 10) {
      views.push(<span key={0} className='label label-warning'>{10-menuCount} more orders to get 30% OFF</span>) 
    } else if (menuCount < 20) {
      views.push(<span key={1} className='label label-warning'>{20-menuCount} more orders to get 40% OFF</span>) 
    } else if (menuCount < 25) {
      views.push(<span key={2} className='label label-warning'>{25-menuCount} more orders to get 50% OFF</span>) 
    }
    return views
  }

  renderPrice(){
    let views         = []
    let price         = this.props.price
    let origPrice     = this.props.original_price
    let isDiscounted  = this.props.percent != 0

    if(this.props.userSignedIn){
      if( isDiscounted ) {
        views.push(<span key={0} className='text-muted'>
          <s>{ 'P' + origPrice.toFixed(2) }</s> 
        </span>) 
      }

      views.push(<span key={1}>
        {' P' + price.toFixed(2) + ' '}
      </span>)

      views.push(<small key={2}>{this.isDiscounted()}</small>)
      views.push(<small key={3}>{this.moreDiscountInfo()}</small>)
    }

    return views
  }

  render() {
    let menu = this.props

    let firstLevelDiscountCount  = menu.count-10 > 10 ? 10 : (menu.count < 10 ? menu.count : 10)
    let secondLevelDiscountCount = menu.count-10 > 20 ? 20 : (menu.count < 20 ? (menu.count)%20 : 20 )
    let thirdLevelDiscountCount  = menu.count > 25 ? 25 : (menu.count < 25 ? (menu.count)%25 : 25)

    return(<div className='building-show-page__menu-item'>
      <div className='panel panel-default' style={{borderRadius: '5px'}}>
        <div className='panel-body building-show-page__menu-item-panel-body'>
          <div 
            className='building-show-page__menu-item-picture' 
            style={{backgroundImage: 'url(' + menu.image + ')'}} />
          <div className='building-show-page__menu-item-title'>
            <h3 className='row'>
              <span className='col-xs-12'>
                <p>{menu.name}</p>
              </span>
              <span className='col-xs-12'>
                <p>{this.renderPrice()}</p>
              </span>
            </h3>
            <p>{menu.description}</p>
            <div className='row'>
              <div className='col-xs-12'>
                <div className='text-center'><small>Discount o Meter:</small></div>
                <div className='progress'>
                  <div 
                    className='progress-bar progress-bar-success'
                    style={{width: ((firstLevelDiscountCount/10)*100*(33/100))+'%'}}>
                    {firstLevelDiscountCount > 0 ? firstLevelDiscountCount + '/10' : ''}
                  </div>
                  <div 
                    className='progress-bar progress-bar-warning' 
                    style={{width: (secondLevelDiscountCount > 10 ? ((secondLevelDiscountCount-10)/10)*100*(33/100) : 0)+'%'}}>
                    {secondLevelDiscountCount > 10 ? secondLevelDiscountCount + '/20' : ''}
                  </div>
                  <div 
                    className='progress-bar progress-bar-danger' 
                    style={{width: (thirdLevelDiscountCount > 20 ? ((thirdLevelDiscountCount-20)/5)*100*(34/100) : 0)+'%'}}>
                    {thirdLevelDiscountCount > 20 ? thirdLevelDiscountCount + '/25' : ''}
                  </div>
                </div>
              </div>
              <div className='col-xs-12'>
                <div className='btn-group'>
                  {this.renderCartButtons()}
                  <button className='btn btn-default btn-sm btn-order' data-toggle='modal' data-target='#discountMeterInfoModal'>
                    <i className='fa fa-info'></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>)
  }
}

export default MenuItem
