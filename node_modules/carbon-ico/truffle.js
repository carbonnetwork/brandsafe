module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: '127.0.0.1',
      port: 9545,
      network_id: '*', // Match any network id
      gas: 10000000
    },
    rinkeby: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    },
    main: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    }
  }
};
