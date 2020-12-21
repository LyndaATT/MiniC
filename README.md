# MiniC Compiler

         Nous avons réalisé un analyseur lexical (lexer.ml), un analyseur syntaxique (parser.mly) ainsi qu'un vérificateur de types qui traitent tous les types de programmes donnée par la syntaxe du sujet.

 ## 1) Analyseur Lexical :
Afin de réduire le nombre d’états de l’automate, un seul cas a été utilisé pour les identifieurs. Les mots clés sont enregistrés dans un hashmap de couples d’identifieur et de lexeme. Cependant, des cas spécifiques ont été ajoutés pour certaines suites de caractères (.. ou := par exemple) qui ne peuvent comprendre de blancs entre les caractères.

## 2) Analyseur syntaxique : 

Dans le but de loclaiser les erreurs possibles, les déclarations de variables, fonctions, instructions ainsi que les différentes expressions sont décritent avec deux champs, un champs correspondant à la description de la structure ainsi que d'un champs pour la position qu'on peut récuperer à l'aide de ($startpos, $endpos)). 
Nous avons utilisé aussi, plusieurs fonctions de menhir : +,-,&,.. ainsi que list,separated_nonemty_list,...
