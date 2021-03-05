=begin 

- "ERROR\r\n"

  means the client sent a nonexistent command name.

- "CLIENT_ERROR <error>\r\n"

  means some sort of client error in the input line, i.e. the input
  doesn't conform to the protocol in some way. <error> is a
  human-readable error string.

- "SERVER_ERROR <error>\r\n"

  means some sort of server error prevents the server from carrying
  out the command. <error> is a human-readable error string. In cases
  of severe server errors, which make it impossible to continue
  serving the client (this shouldn't normally happen), the server will
  close the connection after sending the error line. This is the only
  case in which the server closes a connection to a client.


    After this line, the client sends the data block:

    <data block>\r\n
    
    - <data block> is a chunk of arbitrary 8-bit data of length <bytes>
      from the previous line.
    
    After sending the command line and the data block the client awaits
    the reply, which may be:
    
    - "STORED\r\n", to indicate success.
    
    - "NOT_STORED\r\n" to indicate the data was not stored, but not
    because of an error. This normally means that the
    condition for an "add" or a "replace" command wasn't met.
    
    - "EXISTS\r\n" to indicate that the item you are trying to store with
    a "cas" command has been modified since you last fetched it.
    
    - "NOT_FOUND\r\n" to indicate that the item you are trying to store
    with a "cas" command did not exist.




The retrieval commands "get" and "gets" operate like this:

get <key>*\r\n
gets <key>*\r\n

- <key>* means one or more key strings separated by whitespace.

After this command, the client expects zero or more items, each of
which is received as a text line followed by a data block. After all
the items have been transmitted, the server sends the string

"END\r\n"

to indicate the end of response.

Each item sent by the server looks like this:

VALUE <key> <flags> <bytes> [<cas unique>]\r\n
<data block>\r\n

- <key> is the key for the item being sent

- <flags> is the flags value set by the storage command

- <bytes> is the length of the data block to follow, *not* including
  its delimiting \r\n

- <cas unique> is a unique 64-bit integer that uniquely identifies
  this specific item.

- <data block> is the data for this item.

If some of the keys appearing in a retrieval request are not sent back
by the server in the item list this means that the server does not
hold items with such keys (because they were never stored, or stored
but deleted to make space for more items, or expired, or explicitly
deleted by a client).
 =end