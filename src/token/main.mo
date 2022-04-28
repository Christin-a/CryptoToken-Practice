//SETTING UP THE MAIN:MO AND THE ACTOR

import Principal "mo:base/Principal"; //imports the Principal data type
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor Token { // creates Token actor
    let owner : Principal = Principal.fromText("yk32y-lk7hr-qwg3m-t7owl-pz5zh-qaewp-r77cq-qkgoh-mwbyd-bcm5f-7qe"); // sets the principal to the id retrieved from the CL and converts it from a string
    let totalSupply: Nat = 1000000000; // creates a variable with a natural number data type
    let symbol: Text = "CHRIS"; // creates a variable for the token's symbol
    
    private stable var balanceEntries: [(Principal, Nat)] = []; // a temporary variable for the HashMap below that holds the principal ids and the amounts 

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    // Principal = key, Nat = token amount, 1 = starting amount, Principal.equal checks the principal matches one that is already stored, Principal.hash =  hashes principal ids
     if (balances.size() < 1) { //function that checks if the balances HashMap doesn't have any entries
            balances.put(owner, totalSupply);
            // "put" inserts the value (totalSupply) at a particular key (owner) and overwrites any existing entry with specified key.
        };
    

    // DISPLAYING THE TOKEN AMOUNT OF THE USER (within the actor)

    public query func balanceOf(who: Principal): async Nat { //creates a read-only function
        let balance: Nat = switch (balances.get(who)) { // creates the balance variable to store the amount that the Principal is paired with
        // ".get" gets the entry at a particular key and returns its associated value if it exists otherwise it will return null
            case null 0; // switch case that instructs the "get" method to return 0 if the statement is null
            case (?result) result; // instructs the "get" method to return the actual amount if statement is not null
        };
        return balance;
    };

    public query func getSymbol(): async Text {
        return symbol;
    };

    //ALLOWING NEW USERS TO CLAIM TOKENS (within the actor)

    public shared(msg) func payOut(): async Text { //shared method allows identification of the principal id of the entity that calls a particular function
        Debug.print(debug_show(msg.caller)); // prints the principal id of the caller
        // call this func in the CL by typing: dfx canister call token payOut.
        if (balances.get(msg.caller)== null) {
        let amount = 10000;
        let result = await transfer(msg.caller, amount);// give msg.caller the assigned amount, transfered from the canister 
        return "Success";
        } else{
            return "Already Claimed!" //if msg.caller principal id is already stored, they will not be able to claim
        };
    };
    
    //TRANSFERRING TOKENS BETWEEN ACCOUNTS BY SPECIFYING PRINCIPAL ID OF USER RECEIVING THE FUNDS (within the actor)

    public shared(msg) func transfer (to: Principal, amount: Nat) : async Text { //creates a function that transfers a specified amount to a principal id  determiend by the user
        let fromBalance = await balanceOf(msg.caller); // creates a variable to hold the amount of the user making the transfer
        if(fromBalance > amount) { // if function to check if the user making the transfer has sufficient funds
            let newFromBalance : Nat = fromBalance - amount; //creates a variable to hold the balance of the user once the funds have been transferred
            balances.put(msg.caller, newFromBalance);// updates the balance of the user making the transfer

            let toBalance = await balanceOf(to); // creates a variable to store the balance of the principal receiving the transfer
            let newToBalance = toBalance + amount; // creates a variable to hold the new balance of the principal receiving the transfer
            balances.put(to, newToBalance); // updates the balance of the principal receiving the transfer to reflect the added amount
            return "Success";
        }else {
            return "Insufficient Funds"; // if the user initiating the transfer has insufficient funds the function will not be carried out
        };

    };

    // MANAGING HASHES DURING CANISTER UPGRADES

   system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries()); // converts the entries from the balances into a HashMap before the canister upgrades
    };

   system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash); //converts the balances into a HashMap once the canister has upgraded
       
    };


};

