# Memcached Server

_Acá va un párrafo que describa lo que es el proyecto_

## Installation 

_To run and use the server you must follow some previous steps._
- First you must clone the repositorie wherever you want to have the project.

```
git clone https://github.com/lukaspode/memcached-server

```

- Then you have to get installed ruby on your computer.

- And optionaly if you want to run the tests you should install Ruby gem: **Rspec**

```
gem install rspec
```


### Getting started 

_Once the previous steps are done, now we can proceed to run and send requests to the server_
#### Running the server
- First of all we open a terminal on ***/app*** folder and execute the following command:

```
ruby server.rb
```
*you should get a message like this* : **Server running on 3000**

#### New client connection

- To connect a new client to the server, we open a new console dialoge (no matter where) and execute this:

```
telnet localhost 3000
```
##Supported commands

#### Retrieval commands
1. ***get***
2. ***gets***

#### Storage commands
1. ***set***
2. ***add***
3. ***replace***
4. ***append***
5. ***prepend***
6.  ***cas***

## Usage examples

```
<command> <key> <flag> <expectime> <bytes> [noreply]\r\n <datablock>\r\n
set john 4 200 6 lennon
get john
```

## Tests

To run the tests first we have to run the server same as we did it at first, then we open a new terminal on ***/test/spec*** folder and execute:

```
rspec test_commands.rb
```
and finally if everything is working correctly the terminal should display this: **XX examples, 0 failures**
### Analice las pruebas end-to-end 🔩
