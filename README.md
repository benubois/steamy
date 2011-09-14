mydump
======

mydump, backup MySQL Databases

Why
---

mydump has several advantages over mysqldump (and many disadvantages).

The main goal of mydump is to make it easy to backup remote MySQL databases. mydump makes database backups fast by relying on SequelPro Saved connections, SSH public keys to the MySQL server your trying to backup from and by running gzip on the sql dump before downloading it to your local machine.

This means that mydump has several requirements.

1. You must have a SequelPro saved connection.
2. You must have password-less SSH to the remote server using public keys. 
3. You must have mysqldump and gzip installed on the remote server.

Usage
-----

Install by running

    $ gem install mydump

mydump will look for a YAML file located in ~/.mydump which specifies the SequelPro saved connections directory.
