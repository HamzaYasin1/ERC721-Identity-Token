/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // to customize your Truffle configuration!
// };

var HDWalletProvider = require("truffle-hdwallet-provider");
const MNEMONIC = "reduce kit agree unfair rude tobacco crunch exhibit food armed chase behind";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/v3/175ce051e4634ce7bdfefe78c35a5bb4")
      },
      network_id: 3,
      gas: 7000000
      
            //make sure this gas allocation isn't over 4M, which is the max
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, "https://rinkeby.infura.io/v3/175ce051e4634ce7bdfefe78c35a5bb4")
      },
      network_id: 4,
      gas: 7000000
      
            //make sure this gas allocation isn't over 4M, which is the max
    }
  }
};
