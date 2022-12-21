import React , { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json'
import {MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn} from  'mdb-react-ui-kit'
import './app.css';

class App extends Component {
      async componentDidMount() {
        await this.loadweb3();
        await this.loadBlockchainData();
      }

    async loadweb3() {
        const provider = await detectEthereumProvider();
        if(provider){
            console.log('ethereum wallet connected');
            window.web3 = new Web3(provider)
        }else {
            console.log('no ethereum provider detected');
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        this.setState({account:accounts[0]})
        console.log(this.state.account);

        const netWorkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[netWorkId]
          if(networkData) {
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            this.setState({contract})
            console.log(this.state.contract);

            const totalSupply = await contract.methods.totalSupply().call();
            this.setState({totalSupply})
            console.log(this.state.totalSupply);


                  
                    for(let i = 1; i <= totalSupply; i++) {
                        const KryptoBird = await contract.methods.kryptoBirdz(i - 1).call()
                        this.setState({
                            kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
                        })
                    }
                    console.log(this.state.kryptoBirdz)
                } else {
            window.alert('smart contract not deployed')
          }

    }

    mint = (kryptoBird) => {
        this.state.contract.methods.mint(kryptoBird).send({from:this.state.account})
        .once('receipt', (receipt)=> {
            this.setstate({
                kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
            })
        })
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply:0,
            kryptoBirdz:[]
        }

    }

    render () {
        return(
            <div className='container-filled'>
                {console.log(this.state.kryptobirdz)}
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap shaddow p-0'>
                 <div className="navbar-brand col-sm-3 col-md-3 mr-0"
                      style={{color:'white'}}>
                      Krypto Birdz NFTs (Non Fungible Tokens)
                 </div>
                 <ul className="navbar-nav px-3">
                   <li className="nav-item text-nowrap d-none d-sm-none d-sm d-sm-block">
                    <small className="text-white">
                        {this.state.account}
                    </small>
                   </li>       
                 </ul>
                </nav>

                <div className="container-fluid mt-1">
                    <div className="row">
                      <main role="main" className="col-lg-12 d-flex text-center">
                         <div className="content mr-auto ml-auto"
                             style={{opacity:0.8}}>
                            <h1 style={{color:'black'}}>kryptoBirdz - NFT Marketplace</h1>
                         <form onSubmit={(event)=> {
                            event.preventDefault()
                            const kryptoBird = this.kryptoBird.value
                            this.mint(kryptoBird)
                        }}>
                            <input 
                            type='text' 
                            placeholder='add file location'
                            className='form-control mb-1'
                            ref={(input)=>this.kryptoBird = input}
                            />
                            <input 
                            style={{margin:'6px'}}
                            type='submit' 
                            className='btn btn-primary btn-black'
                            value='MINT'
                            />
                            </form>     
                         </div>
                      </main>
                    </div>
                    <hr></hr>
                    <div className="row textCenter">
                        {this.state.kryptoBirdz.map((kryptoBird, key)=> {
                           return(
                            <div>
                                <div>
                                    <MDBCard className="token img" style={{maxWidth:'22rem'}}>
                                    <MDBCardImage src={kryptoBird} position='top'height='250rem' style={{marginRight: '4px'}}/>
                                    <MDBCardBody>
                                    <MDBCardTitle>  KryptoBirdz  </MDBCardTitle>
                                    <MDBCardText>  This is a KryptoBird  20 uniquely designed nft's. 
                                                   only one of each bird. </MDBCardText>
                                    <MDBBtn href={kryptoBird}>Download</MDBBtn>
                                    </MDBCardBody>
                                    </MDBCard>
                                </div>
                            </div>
                           )
                        })}
                    </div>
                </div>

            </div>
        )
    }
}
export default App;