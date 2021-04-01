
#############################
##    defalut - messages   ##
#############################

ERROR = 'ERROR'
CLIENT_ERROR = 'CLIENT_ERROR'
STORED = 'STORED'
NOT_STORED = 'NOT_STORED'
EXISTS = 'EXISTS'
NOT_FOUND = 'NOT_FOUND'
LN_BREAK = "\r\n"

#############################
##    extra - messages   ##
#############################

WRONG_PARAMETERS = 'Wrong number of parameters.'
NOT_ASOCIATED = 'Not value associated to the key: '
EMPTY = ''
#COMMAND_NOT_FOUND 'Command not found or supported.'


# Ver si ponerlo
HELP_MENU = 
"
* * * * * * * * * * * * * * * * * * * * * * * * * * * *\r\n
* * * * *       Memcahed Server - Help       * * * * *\r\n
* * * * * * * * * * * * * * * * * * * * * * * * * * * *\r\n
    Commands supported\r\n
        Retrival:   get,gets\r\n
        Storage:    set,add,replace,append,prepend,cas\r\n
    Usage\r\n
        Retrival\r\n
            get/gets <key>*\r\n
            * means one or more key strings separated by whitespace.\r\n
        Storage\r\n
            <command> <key> <flags> <exptime> <bytes> <cas unique>* [noreply] (*press enter*)\r\n
            <data block>\r\n
            *just used in the 'cas' command\r\n
    Examples\r\n
        set kristen 2 0 4 (*press enter*)\r\n
        hola\r\n
        STORED            (Message expected)\r\n

        get kristen\r\n
        VALUE kristen 2 4\r\n
        hola              (Message expected)\r\n
\r\n"