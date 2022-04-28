import React, {useState} from "react";
import { Principal} from '@dfinity/principal';
import {token} from "../../../declarations/token";

function Transfer() {
  
const [recipientId, setId] = useState("");
const [amount, setAmount] = useState("");
const [isDisabled, setDisabled] = useState(false);
const [feedback, setFeedback] = useState("");
const [isHidden, setHidden] = useState(true);


  async function handleClick() {
    setDisabled(true)
    const recipient = Principal.fromText(recipientId)// converts recipientId from text to Principal datatype 
    const amountToTransfer = Number(amount); //converts amount from text to number datatype
    const result = await token.transfer(recipient, amountToTransfer);// calls function from token motoku file and passes in the recipient ID  and the amount from the user input
    setFeedback(result)
    setHidden(false)
    setDisabled(true)
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value = {recipientId}
                onChange={(e) => (setId(e.target.value))}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value = {amount}
                onChange={(e) => (setAmount(e.target.value))}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button disabled={isDisabled} id="btn-transfer" onClick={handleClick} >
            Transfer
          </button>
        </p>
        <p hidden = {isHidden}>
          {feedback}
        </p>
      </div>
    </div>
  );
}

export default Transfer;
