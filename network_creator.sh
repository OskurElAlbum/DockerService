#!/bin/bash

# Vérification du nombre d'arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 nom_du_reseau"
  exit 1
fi

# Récupération du nom du réseau depuis le premier argument
nom_reseau="$1"

# Création du réseau Docker
docker network create "$nom_reseau"