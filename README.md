Minimax chess AI player implementation in Objective-C
=====================================================

Commentaires personnels (MortyMars)
=======================
Implémentation vraiment cool de jeu d'échecs, qui présente le gros intérêt d'être une des rares à être écrite en Objective-C,
de surcroit pour macOS plutôt qu'iOS souvent privilégié.
Les points les plus remarquables du code proposé sont (AMHA), 
- sa grande clarté pour l'essentiel (même pour un noob comme moi) apportée par un découpage en fichiers structurés 
  et suffisamment courts pour être lisibles, 
- sa grande efficacité due au recours à de nombreuses Méthodes élémentaires, de classes et d'instances,
- sa bonne capacité d'évolution par réutilisation des fonctions unitaires déjà implémentées.

Notes de mise à jour (11/2020)
====================
Par rapport à la version d'origine, qui constitue toujours 99,99% du chouette travail réalisé certaines améliorations 
marginales ont été apportées :
- fonctionnelles :
Il est désormais possible de choisir de jouer avec les Blancs ou avec les Noirs.
Le code a été commenté autant que possible (en français, désolé), au fur et à mesure de la compréhension que j'en ai.
Ces commentaires ne sont donc très certainement pas exempts d'erreurs, et je remercierai évidemment quiconque aura
la gentillesse de m'en faire part.
- cosmétiques :
Le dessin des pièces a été remanié, pour un résultat plus esthétique à mon goût, ...mais ça n'engage que moi ;-)
Les couleurs des cases de l'échiquier ont été modifiées aux mêmes fins.

Ce qui reste à faire (c'est ma propre et ambitieuse TODO list)
====================
Essentiellement :
- Détection de la mise en échec, et de l'échec et mat (on peut jouer aujourd'hui sans Roi...)
- Amélioration du recours à l'algorithme MiniMax alpha beta (actuellement je joue mieux que l'AI ;-))

Optionnellement :
- Gestion de la prise en passant (pour un résultat encore plus "professionnel")
- Création d'une sortie texte listant les différents coups joués (fonction à ce stade basiquement initialisée pour le coté AI)
- Adoption d'une des conventions officielles pour le nommage des coups


