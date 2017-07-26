import React, { Component } from 'react'

class ModalInfo extends Component {
  render(){
    return(
      <div id='discountMeterInfoModal' className='modal fade' tabIndex='-1' role='dialog'>
        <div className='modal-dialog modal-lg' role='document' style={{width: '1000px'}}>
          <div className='modal-content'>
            <div className='modal-header'>
              Discount'o Meter Information
            </div>
            <div className='modal-body' style={{backgroundImage: 'url('+ this.props.modalInfo +')', height: '540px'}}>
            </div>
          </div>
        </div>
      </div>
    )
  } 
}

export default ModalInfo
