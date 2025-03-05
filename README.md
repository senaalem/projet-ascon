# Projet Ascon

**auteur** : Bilel Betka

## Organisation des fichiers

`SRC` contient les codes sources et se divise en deux sous-répertoires, `RTL` et `BENCH`, qui contiennent respectivement les codes sources des modules et de leur bancs de test (en `.sv`).
`LIB` lui, contient les fichiers obtenus lors de la compilation, avec également une division en deux sous-répertoires, `LIB_BENCH` et `LIB_RTL` (l'un pour les bancs de test, l'autre pour les modules).
La racine du dossier contient également le fichier de compilation en `.sh`.
Les autres fichiers sont des produits des commandes `vmap` et ` vlib` utilisées pour créer les sous-répertoires de `LIB` et permettre la compilation.

## Compiler et simuler
Pour compiler les codes sources et simuler le banc de test voulu, il faut taper
```sh
source compile_ascon.sh
```
dans un terminal en se plaçant bien à la racine du répertoire de projet. Nous considérons que les commandes `vlog` et `vsim` sont bien dans le `PATH` de la machine utilisée, de même que ModelSim est bien installé. S'il est souhaité de changer le banc de test simulé, il suffit de dé-commenter la ligne correspondante dans le fichier `compile_ascon.sh`.