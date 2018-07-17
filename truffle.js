// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 9545,
      network_id: '*', // Match any network id
      gas: 20000000
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
}
