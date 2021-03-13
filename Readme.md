# Memcached Server

> _Memcached is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.
["Memcached"](https://www.memcached.org/)_

## Installation 

_To run and use the server you must follow some previous steps._
- First you must clone the repositorie wherever you want to have the project.

```
git clone https://github.com/lukaspode/memcached-server
```

<<<<<<< HEAD
- Then you have to get installed **Ruby** on your computer.
=======
- Then you have to get installed Ruby on your computer.
>>>>>>> 248038f389ebb4738799b2c1f7e2b7822b995ed9

- And optionally, if you want to run the tests you should install Ruby gem: **Rspec**

```
gem install rspec
```


## Getting started 

_Once the previous steps are done, we can proceed to run and send requests to the server_
#### Running the server
- First of all, we open a terminal on ***/app*** folder and execute the following command:

```
ruby server.rb
```
<<<<<<< HEAD
*you will get the following message * : **Server running on port: 3000**
=======
*you would get the following message * : **Server running on port: 3000**
>>>>>>> 248038f389ebb4738799b2c1f7e2b7822b995ed9

![Server running](/img_rdm/server_running.jpg)

#### New client connection

- To connect a new client to the server, we open a new console dialog (no matter where) and execute the following command:

```
telnet localhost 3000
```
- If we want to connect more than one client, we make the same procedure: open a new console dialog and run **telnet localhost 3000** again.

![Client connection](/img_rdm/client_connection.jpg)

![Client connected](/img_rdm/client_ok.jpg)

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
***************
** Retrieval **
***************

<command> <key>*\r\n
* means one or more key strings separated by whitespace.

get john

get john kristen

gets martin

get martin kristen


*************
** Storage **
*************

<command> <key> <flag> <expectime> <bytes> *<cas unique>* [noreply]\r\n <datablock>\r\n

set john 4 200 6 (*press enter key*)
lennon

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
*The **cas unique** argument is just used for the **cas** command. *

## Real Examples

#### Client input on console

![Set example](/img_rdm/set.jpg)
![Append,repend](/img_rdm/set_append_get.jpg)
![Add, replace, cas](/img_rdm/cas_gets.jpg)

## Tests

To run the tests first we have to run the server as we did it at first, then we open a new terminal on ***/test/spec*** folder and execute the following command:

```
rspec test_commands.rb
```
<<<<<<< HEAD
and finally, if everything is working correctly the terminal would display this message: **27 examples, 0 failures**
=======
and finally, if everything is working correctly the terminal would display this message: **XX examples, 0 failures**
>>>>>>> 248038f389ebb4738799b2c1f7e2b7822b995ed9

## Version

Version 1.1.0

## References
If you want more information about Memcached Server, Ruby installation or Ruby gems, check these links:
- [Memcached Protocol](https://github.com/memcached/memcached/blob/master/doc/protocol.txt "Memcached Protocol")
- [Ruby Official Website](https://www.ruby-lang.org/en/ "Ruby Official Website")
- [Rspec Gem](https://rubygems.org/gems/rspec "Rspec Gem")
- [Memcached commands](https://www.tutorialspoint.com/memcached/index.htm)
