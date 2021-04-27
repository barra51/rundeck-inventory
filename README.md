# rundeck-inventory

This script tries to be another (but maybe improved?) rundeck inventory generator. By default, the output of your xml file will contain the following:

 - **env:** Environment for your server. Useful to use if you have different environments to launch stuff. Take the following example: **mybox.qa** OR **mybox.prod**.
 - **Node name:** In the short form, mybox+$env. Example: **mybox.qa** OR **mybox.prod**
 - **tags:** Extension from **env**.
 - **osFamily:** By default, set to Unix.
 - **username:** svc_account (Replace with your own).
 - **sudo-command-enabled:** Enabled by default.
 - **ssh-autentication:** PrivateKey
 - **ssh-key-storage-path:** Self explanatory.

> **Note:** above options worked for me. You are free to modify them for you current environment. [Rundeck documentation](https://docs.rundeck.com/docs/) is always available!

## Arguments

This script only takes two arguments:

 - **$1:** Source file of your nodes.
 - **$2:** $env value.

## Understanding the first source

Your entry file can be processed in the following form. Take as reference below examples:

```sh
# one line hosts
host01.com.mx host02.com.mx host03.com.mx hostX.com.mx
```

```sh
# Multi line hosts
host01.com.mx
host02.com.mx
host03.com.mx
hostX.com.mx
```

The execution will be:

```sh
bash inventory_creator.sh myhostsource qa
```
