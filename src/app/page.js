'use client'
import styles from "./page.module.css";
import detectEthereumProvider from "@metamask/detect-provider";
import Web3 from "web3";
import { useEffect } from "react";

export default function Home() {

  useEffect(() => {
    loadWeb3();
  }, []);

  async function loadWeb3() {
    const provider = await detectEthereumProvider();
    if (provider) {
      console.log("Provider connected");
      window.web3 = new Web3(provider);
    } else {
      console.error("Provider not connected");
    }
  }

  return <div className={styles.page}>NFT MARKETPLACE</div>;
}
