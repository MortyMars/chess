//
//  RuleBook.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//
//  Règles de déplacement des pièces

#import "RuleBook.h"
#import "Piece.h"
#import "ChessBoard.h"
#import "util.h"
#import "Pos.h"

@implementation RuleBook

    // DÉFINITION DU JEU DES DÉPLACEMENTS ADMIS SELON LE TYPE DE PIÈCE
    // Le principe de la méthode (de classe) est de créer un objet NSSet
    // et de le "remplir", éventuellement en plusieurs étapes,
    // avec les déplacements autorisés pour la pièce concernée
    +(NSSet *)PosAccepteesForPiece:(Piece *)piece atPos:(Pos *)pos inBoard:(ChessBoard *)board
    {
        NSMutableSet *PosAcceptees = [[NSMutableSet alloc] init];
        
        // direction du déplacement d'une TOUR ou de la DAME
        if (piece.type == Piece_Tour || piece.type == Piece_Reine) {
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:1 dy:0 board:board]];    // à droite
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:-1 dy:0 board:board]];   // à gauche
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:0 dy:1 board:board]];    // devant
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:0 dy:-1 board:board]];   // derrière
        }
    
        // direction du déplacement d'un FOU ou de la DAME
        if (piece.type == Piece_Fou || piece.type == Piece_Reine) {
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:1 dy:1 board:board]];    // au NE
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:-1 dy:1 board:board]];   // au NO
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:1 dy:-1 board:board]];   // au SE
            [PosAcceptees unionSet:[self rechercheEnDirection:pos dx:-1 dy:-1 board:board]];  // au SO
        }
    
        // déplacement du ROI
        if (piece.type == Piece_Roi) {
            // déplacement normal
            for (int x = pos.x - 1; x <= pos.x + 1; x++) {
                for (int y = pos.y - 1; y <= pos.y + 1;y++) {
                    if (x >= 0 && y >= 0 && x < 8 && y < 8) {
                        if (x != pos.x || y != pos.y) {
                            [PosAcceptees addObject:[Pos posWithX:x y:y]];
                        }
                    }
                }
            }
            
            // ROQUE
            // Le shéma de déplacement des pièces dépend de l'orientation de l'échiquier, et donc de sideHumain
            // Cas 1 - Les Blancs sont au bas de l'écran (car le joueur joue les Blancs)
            if (sideHumain == SideWhite) {
                if (piece.numMoves == 0) {
                    Piece *rightRook = [board piece_colX:7 rangY:pos.y];
                    Piece *leftRook = [board piece_colX:0 rangY:pos.y];
                    
                    // petit roque
                    if (rightRook && rightRook.numMoves == 0) {
                        if (![board piece_colX:6 rangY:pos.y] && ![board piece_colX:5 rangY:pos.y])
                            [PosAcceptees addObject:[Pos posWithX:6 y:pos.y]];
                    }
                    
                    // grand roque
                    if (leftRook && leftRook.numMoves == 0) {
                        if (![board piece_colX:3 rangY:pos.y] && ![board piece_colX:2 rangY:pos.y] && ![board piece_colX:1 rangY:pos.y])
                            [PosAcceptees addObject:[Pos posWithX:2 y:pos.y]];
                    }
                }
            }
            // Cas 2 - Ce sont les Noirs qui sont au bas de l'écran (le joueur joue les Noirs)
            if (sideHumain == SideBlack) {
                if (piece.numMoves == 0) {
                    Piece *rightRook = [board piece_colX:7 rangY:pos.y];
                    Piece *leftRook = [board piece_colX:0 rangY:pos.y];
                    
                    // petit roque
                    if (rightRook && rightRook.numMoves == 0) {
                        if (![board piece_colX:2 rangY:pos.y] && ![board piece_colX:1 rangY:pos.y])
                            [PosAcceptees addObject:[Pos posWithX:1 y:pos.y]];
                    }
                    
                    // grand roque
                    if (leftRook && leftRook.numMoves == 0) {
                        if (![board piece_colX:4 rangY:pos.y] && ![board piece_colX:5 rangY:pos.y] && ![board piece_colX:6 rangY:pos.y])
                            [PosAcceptees addObject:[Pos posWithX:5 y:pos.y]];
                    }
                }
            }
            // Fin de ROQUE
        } // Fin de déplacement du ROI
    
        // déplacement du CAVALIER
        if (piece.type == Piece_Cavalier) {
            // chaque test permet de vérifier que le cavalier n'est pas trop près
            // du bord de l'échiquier (la bande) pour permettre le déplacement
            if (pos.x >= 1 && pos.y >= 2)
                [PosAcceptees addObject:[Pos posWithX:pos.x - 1 y:pos.y - 2]];  // Le cavalier a 8 coups
            if (pos.x >= 2 && pos.y >= 1)
                [PosAcceptees addObject:[Pos posWithX:pos.x - 2 y:pos.y - 1]];  // possibles à chaque fois
            if (pos.x >= 2 && pos.y <= 6)
                [PosAcceptees addObject:[Pos posWithX:pos.x - 2 y:pos.y + 1]];  // La liste exhaustive
            if (pos.x >= 1 && pos.y <= 5)
                [PosAcceptees addObject:[Pos posWithX:pos.x - 1 y:pos.y + 2]];  // en est détaillée ici
            if (pos.x <= 6 && pos.y >= 2)
                [PosAcceptees addObject:[Pos posWithX:pos.x + 1 y:pos.y - 2]];  // dans ces huits déplacements
            if (pos.x <= 5 && pos.y >= 1)
                [PosAcceptees addObject:[Pos posWithX:pos.x + 2 y:pos.y - 1]];  // permis tant que
            if (pos.x <= 5 && pos.y <= 6)
                [PosAcceptees addObject:[Pos posWithX:pos.x + 2 y:pos.y + 1]];  // la pièce reste sur
            if (pos.x <= 6 && pos.y <= 5)
                [PosAcceptees addObject:[Pos posWithX:pos.x + 1 y:pos.y + 2]];  // l'échiquier
        }
    
        // déplacement du PION
        if (piece.type == Piece_Pion) {
                
            int dir;
            if (sideHumain == SideWhite) {
                dir = (piece.side == SideWhite) ? 1 : -1;   // Les pions JOUEUR se déplacent vers le "haut"
                                                            // les pions IA vers le "bas"
            }
            else {
                dir = (piece.side == SideWhite) ? -1 : 1;
            }
                    
            // déplacement normal
            Pos *dest = [Pos posWithX:pos.x y:pos.y + dir];
            if (![board pieceAtPos:dest]) {
                [PosAcceptees addObject:dest];
                
                // déplacement possible de deux cases au premier coup
                dest = [Pos posWithX:pos.x y:pos.y + 2 * dir];
                if (piece.numMoves == 0 && ![board pieceAtPos:dest])
                    [PosAcceptees addObject:dest];
            }
            
            // déplacement en prenant une pièce
            Pos *posLeft = [Pos posWithX:pos.x - 1 y:pos.y + dir];
            Pos *posRight = [Pos posWithX:pos.x + 1 y:pos.y + dir];
            Piece *capturedPieceLeft = [board pieceAtPos:posLeft];
            Piece *capturedPieceRight = [board pieceAtPos:posRight];
            if (capturedPieceLeft) {
                if (capturedPieceLeft.side != piece.side) {
                    [PosAcceptees addObject:posLeft];
                }
            }
            if (capturedPieceRight) {
                if (capturedPieceRight.side != piece.side) {
                    [PosAcceptees addObject:posRight];
                }
            }
            
            // TODO: Gérer la prise "en passant"
            // Il faut détecter que le pion adverse à coté duquel on se trouve immédiatement
            // vient d'avancer de deux cases (c'est donc forcément son premier déplacement)
        }
    
        // Il faut désormais enlever de ce jeu des déplacements acceptés, toutes les cases occupées
        // par des pièces de la même couleur que la pièce objet du calcul
        // En effet on peut s'accaparer un emplacement occupé par une pièce ennemie, en la prenant,
        // mais ça n'est pas possible avec une pièce de sa propre couleur
        NSMutableSet *toBeRemoved = [[NSMutableSet alloc] init];
        for (Pos *pos in PosAcceptees) {
            if ([board pieceAtPos:pos].side == piece.side) {
                [toBeRemoved addObject:pos];
            }
        }
        [PosAcceptees minusSet:toBeRemoved];
        
        // Finalement, après traitement complet, on retourne le jeu de toutes les positions possibles
        return PosAcceptees;
    }

    // Création d'un jeu de cases acceptées dans une direction donnée, dénommé "ligneDeCases"
    // Cette méthode n'est utile que pour les pièces à grands déplacements
    // et n'est appelée (cf. plus haut) que dans le présent fichier RuleBook.m
    // Elle allège le code de détermination des déplacements acceptées
    // pour la Dame, la Tour, et le Fou
    +(NSSet *)rechercheEnDirection:(Pos *)start
                                dx:(int)dx
                                dy:(int)dy
                             board:(ChessBoard *)board
    {
        NSMutableSet *ligneDeCases = [[NSMutableSet alloc] initWithCapacity:8];
        
        int x = start.x, y = start.y;
        
        do {
            x += dx;
            y += dy;
            
            // le numéro de la ligne et de la colonne doit être compris entre 0 et 7
            if (x < 0 || y < 0 || x > 7 || y > 7) break;
            
            Pos *pos = [Pos posWithX:x y:y];        // définition de la nouvelle position
            [ligneDeCases addObject:pos];           // on ajoute la position nouvelle au jeu des possibilités
        } while (![board piece_colX:x rangY:y]);    // ...tant qu'il n'y a pas de pièce en [x,y]
        
        // On retourne la ligne de cases autorisées, ligne qui sera ensuite ajoutée au jeu des positions possibles
        return ligneDeCases;
    }

@end
