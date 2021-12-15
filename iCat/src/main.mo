import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import TrieSet "mo:base/TrieSet";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Error "mo:base/Error";
import Order "mo:base/Order";
import Int "mo:base/Int";
import List "mo:base/List";
import Nat64 "mo:base/Nat64";
import Types "./types";
import Debug "mo:base/Debug";

shared(msg) actor class ICat() = this {
    type Cat = {
        catId : Nat;
        catName: Text;
    };

    type ActionNFT = {
        nftId : Nat;
        nftUrl : Text;
        nftType: Nat; // 0- 合成后的完整动作 1- 动作碎片。
        nftName: Text;
        nftGroup : Nat; // 1-6 代表6 个动作分组。
        nftSerialNum: Nat; // 0- 该动作的完整动作 1-6 该动作的6个碎片。
    };

    type FreezeScore = {
        scoreId : Nat;
        score: Nat;
        accTime: Time.Time;
    };

    type UserData = {
        cat : Cat;
        scoreBalance: Nat;
        nftList: List.List<ActionNFT>;
        freezeScore: List.List<FreezeScore>;
    };

    //type TokenActor = actor {
    //    transferFrom : (from: Principal, to: Principal, value: Nat) -> async TxReceipt;
    //};
    //private var erc20TokenCanister : Principal = msg.caller;

    private stable var catIdGet : Nat = 1;

    private var cats = HashMap.HashMap<Principal, Cat>(1, Principal.equal, Principal.hash);
    private var ownedFreezeScore = HashMap.HashMap<Principal, List.List<Nat>>(1, Principal.equal, Principal.hash);
    private var ownedUserData = HashMap.HashMap<Principal, UserData>(1, Principal.equal, Principal.hash);




    //public shared(msg) func setErc20(token: Principal) : async Bool {
    //    erc20TokenCanister := token;
    //    return true;
    //};


    public shared(msg) func initCat(user: Principal, name: Text) : async Bool {
        let cat = catIdGet;
        catIdGet +=  1;
        switch (cats.get(user)) {
            case (?cat) {
                throw Error.reject("This user has already inited his cat.");
            };
            case (_) {
                let cat : Cat = {
                    catId = catIdGet;
                    catName = name;
                };
                cats.put(user, cat);
                let userData : UserData  = {
                    cat = cat;
                    scoreBalance = 0;
                    nftList = List.nil<ActionNFT>();
                    freezeScore = List.nil<FreezeScore>();
                };
                ownedUserData.put(user, userData);
                return true;
            };
        }
    };

    public query func getCatName(user: Principal) : async Text {
        switch (cats.get(user)) {
            case (?cat) {
                return cat.catName;
            };
            case (_) {
                throw Error.reject("this user hasn't init his cat.");
            };
        }
    };



    public shared(msg) func addFreezeScore(user: Principal, score: Nat) : async Bool {
        switch (ownedUserData.get(user)) {
            case (?userData) {
                let freezeScoreList = userData.freezeScore;
                let freezeScore : FreezeScore = {
                    scoreId = List.size<FreezeScore>(freezeScoreList);
                    score = score;
                    accTime = Time.now();
                };
                let freezeScoresList_new  = List.push<FreezeScore>(freezeScore, freezeScoreList);

                let userData_new : UserData =  {
                    cat = userData.cat;
                    scoreBalance = userData.scoreBalance;
                    nftList = userData.nftList;
                    freezeScore = freezeScoresList_new;
                };
                ownedUserData.put(user, userData_new);
            };
            case (_) {
                throw Error.reject("this user doesn't have freeze user data.");
            };
        };
        return true;
    };




    public shared(msg) func transferOperToScore (operType: Nat) : async Nat {
        var score: Nat = 0 ;
        switch (operType) {
            case 1 {
                let score = 5;
                return score;
            };
            case 2 {
                let score = 10;
                return score;
            };
            case 3 {
                let score = 15;
                return score;
            };
            case 4 {
                let score = 20;
                return score;
            };
            case _ {
                throw Error.reject("Error OperType.");
            };
        }
    };

    public query func getFreezeScores(who: Principal) : async [Nat] {
        switch (ownedFreezeScore.get(who)) {
            case (?scores) {
                return List.toArray<Nat>(scores);
            };
            case (_) {
                return [];
            };
        }
    };

    public query func getUserData (who: Principal) : async UserData {
        switch (ownedUserData.get(who)) {
            case (?userData) {
                return userData;
            };
            case (_) {
                throw Error.reject("this user doesn't have freeze user data.");
            };
        }
    };

};
