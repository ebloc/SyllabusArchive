var fs = require('fs');
var obj = JSON.parse(fs.readFileSync('grouped_courses.json', 'utf8'));
var Web3 = require('web3');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
    web3.eth.defaultAccount = web3.eth.accounts[0];

var SyllabiContract = web3.eth.contract([
{
"constant": false,
"inputs": [
    {
        "name": "_student",
        "type": "address"
    },
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    },
    {
        "name": "_courseName",
        "type": "string"
    }
],
"name": "addStudentToCourse",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    }
],
"name": "addSemester",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    }
],
"name": "addDepartment",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_name",
        "type": "string"
    }
],
"name": "addUniversity",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    }
],
"name": "getDepartment",
"outputs": [
    {
        "name": "",
        "type": "string"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    },
    {
        "name": "_courseName",
        "type": "string"
    }
],
"name": "getSyllabusHash",
"outputs": [
    {
        "name": "",
        "type": "string"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "getUniNumber",
"outputs": [
    {
        "name": "",
        "type": "uint256"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_uniID",
        "type": "uint256"
    }
],
"name": "getUniversityById",
"outputs": [
    {
        "name": "",
        "type": "string"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_student",
        "type": "address"
    },
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    },
    {
        "name": "_courseName",
        "type": "string"
    }
],
"name": "verifyThatStudentGraduatedFromCourse",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": true,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    }
],
"name": "getUniversity",
"outputs": [
    {
        "name": "",
        "type": "string"
    }
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": false,
"inputs": [
    {
        "name": "_uniName",
        "type": "string"
    },
    {
        "name": "_semesterName",
        "type": "string"
    },
    {
        "name": "_departmentName",
        "type": "string"
    },
    {
        "name": "_courseName",
        "type": "string"
    },
    {
        "name": "_hash",
        "type": "string"
    }
],
"name": "addCourse",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
}
]);


var contract = SyllabiContract.at('0xd9e26e5a531594d6c951d9c21019357f2d7869a0');

console.log(contract);
console.log(web3.eth.accounts[0])

contract.addUniversity('Bogazici University', {from: web3.eth.accounts[0], gas:3000000})

for(const semester_key of Object.keys(obj)){
    console.log('-');
    console.log(semester_key);
    contract.addSemester('Bogazici University', semester_key, {from: web3.eth.accounts[0], gas:3000000});

    for(const department_key of Object.keys(obj[semester_key])){
        console.log('--');
        contract.addDepartment('Bogazici University', semester_key, department_key, {from: web3.eth.accounts[0], gas:3000000});
        for(const course_obj of obj[semester_key][department_key]){
            console.log('---');
            contract.addCourse('Bogazici University', semester_key, department_key, course_obj.code, course_obj.ipfs_hash, {from: web3.eth.accounts[0], gas:3000000});
        }
    }
}