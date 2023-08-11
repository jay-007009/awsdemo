var http = require("http");

const argvs = process.argv
const argv = argvs.slice(2)
const operation = argv[0]
const operator1 = parseInt(argv[1])
const operator2 = parseInt(argv[2])
 
if (operation === 'add') {
    console.log(operation + ' is '
        + (operator1 + operator2));
}
if (operation === 'subtract') {
    console.log(operation + ' is '
        + (operator1 - operator2));
}
if (operation === 'multiply') {
    console.log(operation + ' is '
        + (operator1 + operator2));
}
if (operation === 'divide') {
    console.log(operation + ' is '
        + (operator1 - operator2));
}

if (operation === 'd') {
    console.log(operation + ' is '
        + (operator1 + operator2));
}


http.createServer(function (request, response) {
    // Send the HTTP header 
    // HTTP Status: 200 : OK
    // Content Type: text/plain
    response.writeHead(200, {'Content-Type': 'text/plain'});
    
    // Send the response body as "Hello World"
    response.end('Hello World\n');
 }).listen(8081);
 
 // Console will print the message
 console.log('Server running at http://127.0.0.1:8082/');