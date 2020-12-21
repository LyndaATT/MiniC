# MiniC Compiler

        Nous avons réalisé un analyseur lexical (lexer.ml), un analyseur syntaxique (parser.mly) ainsi qu'un vérificateur de types qui 
	traitent tous les types de programmes donnée par la syntaxe du sujet.
	Pour la compilation du projet veuillez saisir la commande suivante :  ocamlbuild -use-menhir -no-hygiene main.native 
	                    ou bien en effectuant cette suite de commandes :  ocamllex lexer.mll
						      	                      menhir -v parser.mly 
									      ocamlc ast.ml parser.mli parser.ml lexer.ml aff.ml main.ml
	Pour l'execution du projet : si vous utilisez la 1ère option de compilation alors saisissez : ./main.native fileTest.c
	                             si vous utilisez la 2ème option de compilation alors saisissez : ./a.out fileTest.c

 ## 1) Analyseur Lexical : 
 (fichier lexel.mll)
Afin de réduire le nombre d’états de l’automate, un seul cas a été utilisé pour les identifieurs. Les mots clés sont enregistrés dans un hashmap de couples d’identifieur et de lexeme. Cependant, des cas spécifiques ont été ajoutés pour certaines suites de caractères (.. ou := par exemple) qui ne peuvent comprendre de blancs entre les caractères. Nous avons inssister sur les erreurs pouvant parvenir en précisant le caractère qui la déclenche.

## 2) Analyseur syntaxique : 
 (fichier parser.mly)
Dans le but de localiser les erreurs possibles, les déclarations de variables, fonctions, instructions ainsi que les différentes expressions sont décritent avec deux champs, un champs correspondant à la description de la structure ainsi que d'un champs pour la position qu'on peut récuperer à l'aide de ($startpos, $endpos)). 
Nous avons utilisé aussi, plusieurs fonctions de menhir : +,-,&,.. ainsi que list,separated_nonemty_list,... Nous avons fait en sorte aussi d'afficher l'erreur parvenu lors de l'analyse en indiquant essentiellement, la position du lexeme la déclenchant.

## 3) Vérificateur de type : 
 (fichier parser.mly)
Dans cette partie, nous allons nous concentrer sur les éventuelles erreurs de 'typage' qui peuvent survenir. Tout comme l'addition ou la multiplication de deux objets dont le type diffère ne peut fonctionner, un appel à une fonction avec de mauvais paramètres ou un résultat retourné par une fonction d'un type différant du type de cette dernière risque d'interrompre l'éxécution de notre programme. Ainsi, notre but ici est d'avoir un suivi des instructions et des expressions dans les moindres détails, en arrêtant volontairement le programme en cours en cas d'une erreur de typage tout en affichant un petit message explicatif pour aider l'utilisateur à mieux comprendre l'erreur et donc, à la corriger. Pour ce faire, nous avons utilisé 4 HashTable : (plus de détails, voir les commentaires dans le fichier parser.mly)
* **var_glob** : un contiendra qui les variables globales,
* **functionsNameType** : qui sauvegardera le nom de toutes les fonctions déclarées ainsi que leurs types de retour.
* **functionsParam** : tout comme functionsNameType, on sauvegardera le nom de toutes les fonctions déclarées mais au lieu de leurs types de retour, on enregistrera la liste des types de ses paramètres (dans l'ordre)
* **currentFunctionVarParam** : va stocker les données relatifs à la fonction qui est en cours d'analyse. Parmis les erreurs que l'on détèctent, il y a celle des opérateurs binaires (tel que l'addition, la multiplication ou encore mêmee le décalage à gauche ou à droite), les opérateurs unaires tel que Not() et Neg().
Nous nous assurons aussi que les expressions figurant dans chaque 'return' est bien de même type que le type de cette dernière. Nous regardons aussi si nous avons bien définies toutes les variables dont la valeur est demandée par un "Get(_)", nous regardons d'abords parmis les paramètres et variables locales des fonctions, en cas d'indisponibilité, on passe à un niveau au dessus c'est-à-dire les variables globales, et si on trouve toujours un tel identifiant, on renvoie une erreur en précisant dans quelle fonction se trouve l'erreur et de quel nom de variable s'agit-il.


## 4) Extension : 
(ast.ml,lexer.mll,parser.mly et aff.ml pour l'affichage)
Concernant les extensions que nous avons réalisés nous avons : 
* La boucle for, nous avons jugé que l'ajouter dans l'AST était beaucoup plus simple. 
* Des opérateurs binaires et unaires : 
	- opérateurs unaires : l'opposé d'un entier ainsi que la négation d'un booléen.
	- opérateurs binaires : 
	    - arithmétique : division(/), modulo(%)
	    - comparaisons : égalité(==,=) , inégalité (<,>,<=,>=)
	    - logique : le ou (||) ainsi que le et &&
	    - bit à bit : le ou (|) ainsi que le et &
	    - décalage : <<,>>
et celà en ajoutant à notre AST les expressions contenant ces differents opérateurs, par exemple pour la négation d'un bool : Neg(expr)

* L'affichage : nous avons réalisé un affichage console qui nous permets de visualisé le résultat dans notre analyse pour chaque programme donné en entrée.	    


## 5) Tests : 
Pour vérifier le bon fonctionnement de notre analyseur lexical, syntaxique et le vérificateur de type, nous avons mis en place différents tests qui relèvent plusieurs subtilités du langage; des tests qui sont bons et d'autres qui déclenchent des erreurs, vous pouvez les retrouver les deux dossiers : goodTest et badTests
