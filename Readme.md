# Memcached Server

> _Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.
["Memcached"](https://www.memcached.org/ ""Memcahced"")_

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


## Getting started 

_Once the previous steps are done, now we can proceed to run and send requests to the server_
#### Running the server
- First of all we open a terminal on ***/app*** folder and execute the following command:

```
ruby server.rb
```
*you should get a message like this* : **Server running on port: 3000**

![Server running](/images/server_running.jpg)

#### New client connection

- To connect a new client to the server, we open a new console dialoge (no matter where) and execute this:

```
telnet localhost 3000
```
![Client connection](/images/client_connection.jpg)

![Client connected](/images/client_ok.jpg)

## Supported commands

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

## Input examples

```
<command> <key> <flag> <expectime> <bytes> *<cas unique>* [noreply]\r\n <datablock>\r\n

** Retrieval **

get john

gets john

set john 4 200 6 (*press enter key*)
lennon

** Storage **

set john 20 0 6 noreply (*press enter key*)
lennon

append jhon 23 250 6 (*press enter key*)
_music

prepend jhon 23 250 5 (*press enter key*)
hello

add juan 32 120 4 (*press enter key*)
hola

replace john 22 120 6 (*press enter key*)
fogerty

cas jhon 30 0 2 1 (*press enter key*)
hi

```
*The **cas unique argument** is just used for the **cas** command. *

## Real Examples

#### Client input on console

![Set example](/images/set.jpg)
![Append,repend](/images/set_append_get.jpg)
![Add, replace, cas](/images/cas_gets.jpg)

## Tests

To run the tests first we have to run the server same as we did it at first, then we open a new terminal on ***/test/spec*** folder and execute:

```
rspec test_commands.rb
```
and finally if everything is working correctly the terminal should display this: **XX examples, 0 failures**

## Version

Version 1.1.0

## References
If you want more information about Memcached Server, Ruby installation or Ruby gems, check these links:
- [Memcached Protocol](https://github.com/memcached/memcached/blob/master/doc/protocol.txt "Memcached Protocol")
- [Ruby Official Website](https://www.ruby-lang.org/en/ "Ruby Official Website")
- [Rspec Gem](https://rubygems.org/gems/rspec "Rspec Gem")
- [Memcached commands](https://www.tutorialspoint.com/memcached/index.htm)
