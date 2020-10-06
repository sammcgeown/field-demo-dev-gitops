var fs = require('fs')
var YAML = require('yamljs')

var myArgs = process.argv.slice(2);
var fileName = myArgs[0]

const file = fs.readFileSync(fileName, 'utf8')
var object = YAML.parse(file)
console.log(YAML.stringify(object, 0, 0))
