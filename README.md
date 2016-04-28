# ansible-acme-nginx

*Sets up SSL certificate signed by Let's Encrypt using acme-tiny*

## Features

* Uses [acme-tiny][acme-tiny] for better code auditability.
* Doesn't run acme-tiny as root.
* Provides an nginx snippet that is easily included in your configs for challenges.
* Automatically renew certificates every 30 days.

## Usage

First of all, look at comments in `vars/main.yml` for details on how each variable works. This
is how your role invocation will look like:

```
- hosts: webserver
  roles:
    - role: ansible-acme-nginx
      ssl_base_folder: /opt/mysslstuff
      acme_challenges_folder_path: "{{ ssl_base_folder }}/challenges"
      acme_domains:
        - example.com
        - www.example.com
```

This role should be ran before you provision your website, otherwise, you won't have your SSL certs
available.

To answer ACME challenges, this role adds an nginx server block that listens to all server names.
This config has a lower priority than your more specific server blocks, that is why you'll need to
change your nginx config for every site to include the `acme_well_known.conf` snippet that is also
create by this role and placed in `/etc/nginx/snippets`. You can see an example in my
[ansible-wordpress][ansible-wordpress-snippet] role. This snippet adds a location
pointing to `acme_challenges_folder_path`. With this snippet in place, you won't ever need to
shutdown your webserver in order to answer your ACME challenge.

The principle is: if your website has never been provisioned before, our catch all nginx conf is
there to answer ACME challenges. Otherwise, in case of regular cert updates, it your website's
nginx conf's responsibility to answer ACME challenge, which is done easily by including the
provided snippet.

[acme-tiny]: https://github.com/diafygi/acme-tiny
[ansible-wordpress-snippet]: https://github.com/hsoft/ansible-wordpress/blob/7f3e8d8e8ce16838beb1d6646914184d1f61227c/templates/nginx.conf#L14

