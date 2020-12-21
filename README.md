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
