#! /bin/bash

# Declare name of the function
generate_uuid()
{
# In Linux UUIDs are generated in /drivers/char/random.c?id=refs/tags/v3.8, and you can generate new ones via proc: $ cat /proc/sys/kernel/random/uuid
# There is also the library libuuid which is used by uuidgen and especially by the ext2/3/4 tools E2fsprogs to generate UUIDs: 
 echo `uuid`
}

# Calling the function
generate_uuid
