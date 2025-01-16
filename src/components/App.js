import React, { useEffect } from "react";
import detectEthereumProvider from "@metamask/detect-provider";
import Kryptobirdz from "../abis/KryptoBirdz.json";
// import Web3 from "web3";

const App = () => {
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
      const accounts = await provider.request({ method: "eth_accounts" });
      console.log("Connected accounts:", accounts);
    } else {
      console.error("Provider not connected");
    }
  }

  return (
    <div>
      <hi>WELCOME NFT</hi>
    </div>
  );
};

export default App;
