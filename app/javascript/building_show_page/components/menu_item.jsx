import React, { Component } from 'react';

class MenuItem extends Component {
  renderCartButtons(){
    if(this.props.userSignedIn) {
      return(
        <a 
          href='#' 
          data-menu-id={this.props.id} 
          className='btn btn-success btn-xs btn-order'
          onClick={this.props.addToCart}>
          <i className='fa fa-plus' /> Add to Cart
        </a>
      ) 
    } else {
      return(
        <a href='/users/sign_in' className='btn btn-success btn-xs btn-order'>
          Check Availability
        </a>
      ) 
    }
  }

  isDiscounted(){
    if (this.props.percent != 0) {
      return(
        <div className='pull-right'>
          <span className='label label-danger'>{this.props.percent}% OFF!</span>
        </div>
      ) 
    }
  }

  renderPrice(){
    if(this.props.userSignedIn){
      return(
        'P' + this.props.price.toFixed(2)
      )
    }
  }

  render() {
    let menu = this.props

    let firstLevelDiscountCount = menu.count-10 > 10 ? 10 : (menu.count < 10 ? menu.count : 10)
    let secondLevelDiscountCount = menu.count-10 > 20 ? 20 : (menu.count < 20 ? (menu.count)%20 : 20 )
    let thirdLevelDiscountCount = menu.count > 25 ? 25 : (menu.count < 25 ? (menu.count)%25 : 25)

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
                {this.renderPrice()}
              </span>
            </h3>
            {this.isDiscounted()}
            <p>{menu.description}</p>
            <div className='row'>
              <div className='col-xs-8'>
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
              <div className='col-xs-4'>
                <div className='pull-right' style={{marginTop: '21px'}}>
                  <div className='btn-group'>
                    {this.renderCartButtons()}
                    <button className='btn btn-default btn-order btn-xs' data-toggle='modal' data-target='#discountMeterInfoModal'>
                      <i className='fa fa-info'></i>
                    </button>
                  </div>
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
