#!/bin/bash

echo "acme-nginx : Checking age of certificate for {{ current_domain }}..."

IS_OLD_ENOUGH="$(find "{{ current_domain_folder }}/signed.crt" -mtime +{{ 60 - acme_cron_renewal_days }})"

if [[ $IS_OLD_ENOUGH = "{{ current_domain_folder }}/signed.crt" ]]; then
  echo "Certificate is old enough. Proceeding to renewal."
  python3 "{{ acme_ssl_base_folder }}/acme-tiny/acme_tiny.py" \
    --account-key "{{ acme_ssl_base_folder }}/account.key" \
    --csr "{{ current_domain_folder }}/domain.csr" \
    --acme-dir "{{ acme_challenges_folder_path }}" \
    > "{{ current_domain_folder }}/signed.crt" || exit 1

  cat "{{ current_domain_folder }}/signed.crt" \
    "{{ current_domain_folder }}/intermediate.pem" \
    > "{{ current_domain_folder }}/chained.pem"

  chown {{ acme_user }}:www-data "{{ current_domain_folder }}/chained.pem"
  chmod 0640 "{{ current_domain_folder }}/chained.pem"
  echo ">> Certificate renewed."
else
  echo ">> Certificate has more than {{ acme_cron_renewal_days }} days left. Skipping."
fi
