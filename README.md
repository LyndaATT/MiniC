# MiniC Compiler

         Nous avons réalisé un analyseur lexical (lexer.ml), un analyseur syntaxique (parser.mly) ainsi qu'un vérificateur de types qui traitent tous les types de programmes donnée par la syntaxe du sujet.

 ## 1) Analyseur Lexical :
Afin de réduire le nombre d’états de l’automate, un seul cas a été utilisé pour les identifieurs. Les mots clés sont enregistrés dans un hashmap de couples d’identifieur et de lexeme. Cependant, des cas spécifiques ont été ajoutés pour certaines suites de caractères (.. ou := par exemple) qui ne peuvent comprendre de blancs entre les caractères.

## 2) Analyseur syntaxique : 

Dans le but de loclaiser les erreurs possibles, les déclarations de variables, fonctions, instructions ainsi que les différentes expressions sont décritent avec deux champs, un champs correspondant à la description de la structure ainsi que d'un champs pour la position qu'on peut récuperer à l'aide de ($startpos, $endpos)). 
Nous avons utilisé aussi, plusieurs fonctions de menhir : +,-,&,.. ainsi que list,separated_nonemty_list,...

## 3) Vérificateur de type : 




## 4) Extension : 
Concernant les extensions que nous avons réalisés nous avons : 
 *La boucle for, nous avons jugé que l'ajouter dans l'AST était beaucoup plus simple. 
 *Des opérateurs binaires et unaires : 
	- opérateurs unaires : l'opposé d'un entier ainsi que la négation d'un booléen.
	- opérateurs binaires : 
	    -> arithmétique : division(/), modulo(%)
	    -> comparaisons : égalité(==,=) , inégalité (<,>,<=,>=)
	    -> logique : le ou (||) ainsi que le et &&
	    -> bit à bit : le ou (|) ainsi que le et &
	    -> décalage : <<,>>
et celà en ajoutant à notre AST les expressions contenant ces differents opérateurs, par exemple pour la négation d'un bool : Neg(expr)

*L'affichage : nous avons réalisé un affichage console qui nous permets de visualisé le résultat dans notre analyse pour chaque programme donné en entrée.	    

