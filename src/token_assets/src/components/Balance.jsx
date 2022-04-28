import React, {useState} from "react";   
import { Principal} from '@dfinity/principal';
import { token} from "../../../declarations/token";

function Balance() {
  const [inputValue, setInput] = useState("");
  const [balanceResult, setBalance] = useState("");
  const [cryptoSymbol, setSymbol] = useState("");
  const [isHidden, setHidden] = useState(true);

  async function handleClick() {
    console.log(inputValue);
    const principal = Principal.fromText(inputValue); // converts user input to principal
    const balance = await token.balanceOf(principal); // waits for balanceOf function to execute and stores the principal into a variable
    setBalance(balance.toLocaleString());
    setSymbol(await token.getSymbol());
    setHidden(false);
  }



  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          value= {inputValue}
          onChange={(e) => setInput(e.target.value)} //function that sets the input to be the value of the target (input text)
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p hidden = {isHidden}>This account has a balance of {balanceResult} {cryptoSymbol}</p>
    </div>
  );
}

export default Balance;
