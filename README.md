steamy
======

steamy, export remote MySQL Databases

Why
---

steamy has several advantages over mysqldump (and many disadvantages).

The main goal of steamy is to make it easy to backup remote MySQL databases. steamy makes database backups fast by relying on SequelPro Saved connections, SSH public keys and by running gzip on the sql dump while downloading it to your local machine.

This means that steamy has several requirements.

1. You must have a SequelPro saved connection.
2. You must have password-less SSH to the remote server using public keys. 
3. You must have mysqldump and gzip installed on the remote server.

Installation 
------------

Install by running

    $ gem install steamy

steamy will look for a YAML file located in ~/.steamy which specifies the SequelPro saved connections directory.

The format of the file should look like:

    ---
    :saved_connections: /path/to/db

The path supports path expansion so something like `~/Databases` would work too.

Usage
-----

    $ steamy HOSTNAME 
    
In this usage steamy will give you a list of databases available on HOSTNAME and let you pick one.

    $ steamy HOSTNAME DATABASE

In this usage the DATABASE will be downloaded from HOSTNAME.