"use client";
import styles from "./page.module.css";
import detectEthereumProvider from "@metamask/detect-provider";
import Web3 from "web3";
import { useEffect, useState } from "react";
import KryptoBirdz from "../abis/KryptoBirdz";
import {
  MDBBtn,
  MDBCard,
  MDBCardBody,
  MDBCardImage,
  MDBCardText,
  MDBCardTitle,
} from "mdb-react-ui-kit";
import './page.css'

export default function Home() {
  const [account, setAccount] = useState("");
  const [contract, setContract] = useState(null);
  const [totalSupply, setTotalSupply] = useState(0);
  const [kryptoBirdz, setKryptoBirdz] = useState([]);
  const [kryptoInput, setKrptoInput] = useState("");

  useEffect(() => {
    loadWeb3();
  }, []);

  async function loadWeb3() {
    const provider = await detectEthereumProvider();
    if (provider) {
      console.log("Provider connected");

      // Request accounts
      await provider.request({ method: "eth_requestAccounts" });

      // Get accounts
      // const accounts = await provider.request({ method: "eth_accounts" });
      // console.log("Connected accounts:", accounts);
      // setAccount(accounts[0]);

      window.web3 = new Web3(provider);

      await loadBlockchainData();
    } else {
      console.error("Provider not connected");
      window.alert("Wallet not found");
    }
  }

  async function loadBlockchainData() {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    setAccount(accounts[0]);

    // check and verify network
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBirdz.networks[networkId];
    if (networkData) {
      const address = networkData.address;
      const contract = new web3.eth.Contract(KryptoBirdz.abi, address);
      setContract(contract);

      const totalSupply = await contract.methods.totalSupply().call();
      setTotalSupply(totalSupply);

      for (let i = 0; i < totalSupply; i++) {
        const krypto = await contract.methods.kryptobird(i).call();
        setKryptoBirdz((prev) => [...prev, krypto]);
      }
    } else {
      window.alert("Smart contract not deployed");
    }
  }

  function mint() {
    if (kryptoInput)
      contract.methods
        .mint(kryptoInput)
        .send({ from: account })
        .once("receipt", (receipt) => {
          setKryptoBirdz((prev) => [...prev, kryptoInput]);
          setKrptoInput("");
        });
  }

  return (
    <div className="container-filled">
      <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <div
          className="navbar-brand col-sm-3 col-md-3 mr-0 "
          style={{ color: "white" }}
        >
          KryptoBirdz NFTs (Non Fungible Tokens)
        </div>
        <ul className="navbar-nav px-3">
          <li className="nav-item text-nowrap d-sm-block">
            <small className="text-white">{account}</small>
          </li>
        </ul>
      </nav>

      <div className="mt-1 container-fluid">
        <div className="row">
          <main role="main" className="col-lg-12 d-flex  text-center">
            <div className="content ms-auto me-auto" style={{ opacity: "0.8" }}>
              <h1>KryptoBirdz - NFT Marketplace</h1>
              <form
                onSubmit={(e) => {
                  e.preventDefault();
                  mint();
                }}
              >
                <input
                  value={kryptoInput}
                  type="text"
                  placeholder="Add file location"
                  className="mb-1 form-control"
                  onChange={(e) => setKrptoInput(e.target.value)}
                />
                <input
                  type="submit"
                  value="MINT"
                  className="btn btn-primary btn-black m-2"
                />
              </form>
            </div>
          </main>
        </div>
        <hr></hr>

        <div className="container">
          <div className="row text-center">
            {kryptoBirdz.map((krypto, i) => {
              return (
                <div key={i} className="col">
                  <MDBCard className="token img" style={{ maxWidth: "22rem" }}>
                    <MDBCardImage
                      src={krypto}
                      position="top"
                      height="250rem"
                      style={{ marginRight: "4px" }}
                    />
                    <MDBCardBody>
                      <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                      <MDBCardText>Nft description</MDBCardText>
                      <MDBBtn href={krypto}>Download</MDBBtn>
                    </MDBCardBody>
                  </MDBCard>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
