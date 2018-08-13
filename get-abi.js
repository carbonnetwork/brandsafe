const fs = require('fs');
const acontract = JSON.parse(fs.readFileSync('./build/contracts/AnalysisController.json', 'utf8'));
fs.writeFileSync('./build/abi/AnalysisController.abi',JSON.stringify(acontract.abi));
const dcontract = JSON.parse(fs.readFileSync('./build/contracts/DemandController.json', 'utf8'));
fs.writeFileSync('./build/abi/DemandController.abi',JSON.stringify(dcontract.abi));
const fcontract = JSON.parse(fs.readFileSync('./build/contracts/FinanceController.json', 'utf8'));
fs.writeFileSync('./build/abi/FinanceController.abi',JSON.stringify(fcontract.abi));