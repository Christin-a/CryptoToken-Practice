import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from "@dfinity/auth-client";

const init = async () => { 

  const authClient = await AuthClient.create(); //creates a variable that holds a new AuthClient object

  if(await authClient.isAuthenticated()) {
    handleAuthenticated(authClient);
  }else{
    await authClient.login({
      identityProvider: "https://identity.ic0.app/#authorize", // js object that identifies who the identity provider is (identity service on the ICP)
      onSuccess: () => {
      }
      });
  }
  }

  async function handleAuthenticated(authClient) {
    ReactDOM.render(<App />, document.getElementById("root")); // renders the App if login is a success

  }

init();


