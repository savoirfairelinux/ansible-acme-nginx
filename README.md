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

You'll have to run this role twice. The first time you run the role, it has to be without any
`acme_domains` because we first have to install our nginx snippet.

Then, you'll need to change your nginx config for every site to include the snippet. You can see
an example in my [ansible-wordpress][ansible-wordpress-snippet] role. This snippet adds a location
pointing to `acme_challenges_folder_path`. With this snippet in place, you won't ever need to
shutdown your webserver in order to answer your ACME challenge.

Once that's done, then fill up your `acme_domains` list and watch with awe as your websites
automagically gain SSL support one after the other.

[acme-tiny]: https://github.com/diafygi/acme-tiny
[ansible-wordpress-snippet]: https://github.com/hsoft/ansible-wordpress/blob/7f3e8d8e8ce16838beb1d6646914184d1f61227c/templates/nginx.conf#L14

