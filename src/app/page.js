"use client";
import styles from "./page.module.css";
import detectEthereumProvider from "@metamask/detect-provider";
import Web3 from "web3";
import { useEffect } from "react";
import KryptoBirdz from "../abis/KryptoBirdz";

export default function Home() {
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


  return <div className={styles.page}>NFT MARKETPLACE</div>;
}
