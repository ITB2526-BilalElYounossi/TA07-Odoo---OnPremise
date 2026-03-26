#!/bin/bash

# 1. Actualitzar llistes de paquets
sudo apt update

# 2. Instal·lar dependències essencials (Corregit per a Ubuntu 24.04)
# He eliminat libjw-dev que no existeix i afegit les necessàries
sudo apt install -y git postgresql python3-pip python3-dev python3-venv \
python3-full libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev \
libldap2-dev libssl-dev libffi-dev libpq-dev libjpeg-dev \
liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev \
libxcb1-dev nodejs npm

# 3. Crear usuari de sistema per Odoo (si no existeix)
if ! id "odoo" &>/dev/null; then
    sudo useradd -m -d /opt/odoo -U -r -s /bin/bash odoo
fi

# 4. Crear usuari a PostgreSQL
# Ens assegurem que el servei postgres estigui corrent
sudo systemctl start postgresql
sudo su - postgres -c "createuser -s odoo" || echo "L'usuari odoo ja existeix a Postgres"

# 5. Netejar directori i descarregar codi font
sudo rm -rf /opt/odoo/odoo-server
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo-server

# 6. Crear entorn virtual de Python (venv)
cd /opt/odoo/odoo-server
sudo python3 -m venv odoo-venv
sudo chown -R odoo:odoo /opt/odoo

# 7. Instal·lar llibreries dins del venv
sudo /opt/odoo/odoo-server/odoo-venv/bin/pip install --upgrade pip
sudo /opt/odoo/odoo-server/odoo-venv/bin/pip install -r /opt/odoo/odoo-server/requirements.txt

echo "------------------------------------------------"
echo "Instal·lació finalitzada correctament!"
echo "Recorda configurar /etc/odoo.conf i els logs."
