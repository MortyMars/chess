//
//  ChessView.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//
//  Construction de l'échiquier, de manière GRAPHIQUE

#import "ChessView.h"
#import "ChessBoard.h"
#import "Piece.h"
#import "RuleBook.h"
#import "util.h"
#import "Pos.h"
#import "Move.h"
#import "Minimax.h"

@implementation ChessView

    // Méthode d'instance
    -(id)initWithFrame:(NSRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            
            // Appel de la méthode alerteChoixCouleur
            //[self alerteChoixCouleur];
            
            // Appel de la méthode setupPieces de la classe ChessBoard
            // Les pièces sont positionnées pour le début de partie
            board = [[ChessBoard alloc] init];
            [board setupPieces];
        }
        
        return self;
    } // Fin de méthode

    // DESSIN DE L'ECHIQUIER
    // Méthode appelée par la méthode drawRect en bas de la présente classe
    -(void)drawBoard
    {
        float tileWidth = self.bounds.size.width / 8;
        float tileHeight = self.bounds.size.height / 8;
        
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        
        // Chargement de l'image de toutes des pièces
        // pour que ça fonctionne ici l'image doit être d'un format de 360x120
        // avec une résolution de 72x72
        NSImage *piecesImage = [NSImage imageNamed:@"piecesMars.png"];
        
        // Dessin de l'échiquier et des pièces par balayage des 64 cases, une à une
        for (int x = 0; x < 8; x++) {
            for (int y = 0; y < 8; y++) {
                
                // Dessin des cases de l'échiquier
                CGRect destRect = CGRectMake(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
                
                if (hasSelTile && selTile.x == x && selTile.y == y) {           // case de la pièce sélectionnée
                    CGContextSetRGBFillColor(context, 0.12, 0.63, 0.33, 1);     // --> en VERT opaque
                }
                
                else if ([PosAcceptees containsObject:[Pos posWithX:x y:y]]) {  // cases des déplacements autorisés pour la pièce sélectionnée
                    CGContextSetRGBFillColor(context, 0.72, 0.12, 0.06, 1);     // --> en ROUGE opaque
                }
                
                else {                                                          // autres cases (cases ordinaires)
                    if ((x + y) % 2 == 1) {                                     // si abs + ordonnée n'est pas un multiple de 2
                        CGContextSetRGBFillColor(context, 1, 1, 1, 1);          // --> en BLANC opaque
                    }
                    
                    else {                                                      // à l'inverse si c'est un multiple de 2
                        // Le bleu d'origine a été remplacé par un gris que je trouve plus "échiquier"
                        //CGContextSetRGBFillColor(context, 0, 0, 1, 1);        // bleu opaque
                        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);    // --> en GRIS opaque
                    }
                }
                CGContextFillRect(context, destRect);
                
                // Dessin des pièces sur l'échiquier, tout au long de la partie
                Piece *piece = [board pieceAtPos:[Pos posWithX:x y:y]];
                Side side = piece.side;
                
                if (piece) {    // si une pièce (invisible à ce stade) existe sur la case active, alors on la dessine
                    int index = 0;
                    switch (piece.type) {
                        case Piece_Invalide: break;
                        case Piece_Reine: index = 0; break;     // La reine est la figure indexée 0 dans piecesMars.png
                        case Piece_Roi: index = 1; break;       // Le Roi                         1
                        case Piece_Tour: index = 2; break;      // La Tour                        2
                        case Piece_Pion: index = 3; break;      // Le Pion                        3
                        case Piece_Fou: index = 4; break;       // Le Fou                         4
                        case Piece_Cavalier: index = 5; break;  // Le Cavalier                    5
                        default: break;
                    }
                    // Le dessin de la pièce est un carré de 60x60 extrait de la planche piècesMars de 360x120
                    // La variable index sert à positionner le curseur de sélection sur l'abcisse 0, 60, 120, 180, 240 ou 300
                    // Si la pièce est Noire l'ordonnée est = 0, sinon elle est = 60 pour atteindre les pièces blanches
                    CGRect sourceRect = CGRectMake(index * 60, (side == SideBlack) ? 0 : 60, 60, 60);
                    [piecesImage drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1];
                }
            }
        }
    } // Fin de méthode DESSIN DE L'ECHIQUIER

    
    // LE JOUEUR JOUE, EN DESIGNANT LA CASE DESTINATION DE LA PIECE SELECTIONNEE
    // GESTION DU CLIC DE SOURIS DESIGNANT LA CASE DESTINATION SUR L'ECHIQUIER
    // PUIS REACTION DE L'IA QUI REALISE SON COUP
    -(void)mouseDown:(NSEvent *)theEvent
    {
        float tileWidth = self.bounds.size.width / 8;
        float tileHeight = self.bounds.size.height / 8;
        
        CGPoint pos = [theEvent locationInWindow];
        int x = pos.x / tileWidth, y = pos.y / tileHeight;
        Pos *tilePos = [Pos posWithX:x y:y];
        Piece *selPiece = [board pieceAtPos:tilePos];
        
        // Modif. MCN
        // sideCourant, déclaré dans util.h, prend la valeur de la couleur de la dernière pièce valide sélectionnée
        // si selPiece est nil alors sideCourant sera sideInvalid et le mouvement de l'AI sera shunté...
        if (selPiece) {
                       sideCourant = selPiece.side;
        } // Fin de Modif.
        
        // Si une case N'EST PAS sélectionnée (la valeur logique est inversée avec l'opérateur NON logique "!")
        // (pour que l'expression soit vraie il faut que hasSelTile soit Faux)
        // C'EST LE PREMIER CLIC
        if (!hasSelTile) {
            // S'il y a une pièce sélectionnée, càd s'il y a une pièce sur la case où on a cliqué
            if ([board pieceAtPos:tilePos]) {
                selTile = tilePos;  // la case sélectionnée devient la case cliquée
                hasSelTile = YES;   // le bool correspondant à la sélection de case est placé sur vrai
                // puis on calcule les position acceptées pour la pièce à partir de son emplacement
                PosAcceptees = [RuleBook PosAccepteesForPiece:selPiece atPos:tilePos inBoard:board];
            }
        }
        
        // Si une case EST sélectionnée
        // C'EST LE SECOND CLIC
        else {
            // le mouvement demandé doit figurer dans les mouvements autorisés
            if (tilePos.x != selTile.x || tilePos.y != selTile.y) {
                if ([PosAcceptees containsObject:tilePos]) {
                    
                    // Modif. MCN
                    // Test de présence de pièce adverse qui sera utilisé plus bas
                    // pour déterminer s'il faut inverser sideCourant ou pas
                    Piece *pieceAdverse = [board pieceAtPos:tilePos];
                    if (pieceAdverse) {
                        priseDePiece = YES;
                    }
                    
                    
                    // si c'est le cas alors on déplace la pièce
                    Move *move = [[Move alloc] initWithStart:selTile dest:tilePos];
                    [board performMove:move];
                        
                    // Modif. MCN
                    // Le joueur ayant joué, on inverse sideCourant avant de passer la main à l'AI
                    // l'AI procède ensuite à son déplacement
                    // C'est ici que se produisait un BUG fonctionnel car en cas de prise de pièce adverse au cours
                    // du déplacement, l'AI joue ensuite un coup pour le JOUEUR...
                    // Il faut donc ne pas inverser sideCourant en cas de prise de pièce...
                    if (priseDePiece == NO) {
                        if (sideCourant != SideInvalid) {
                            sideCourant = (sideCourant == SideWhite) ? SideBlack : SideWhite;
                        }
                    } // Fin  d'encarts
                    
                    // Le NSTimer  programme l'appel à "makeComputerMove" et permet la poursuite du programme.
                    // Ainsi la position choisie par le JOUEUR pour son coup est prise en compte et tout de suite
                    // dessinée sur l'échiquier
                    // MCN : Ajout du paramètre sideCourant à makeComputerMove (cf. implémentation)
                    [NSTimer scheduledTimerWithTimeInterval:0.01
                                                     target:self
                                                   selector:@selector(makeComputerMove)
                                                   userInfo:nil
                                                    repeats:NO];
                    }
                }
            
            // RAZ variables
            hasSelTile = NO;
            PosAcceptees = nil;
        } // Fin de Else

        self.needsDisplay = YES;
    } // Fin de gestion du clic de souris

    
    // REALISATION DU DEPLACEMENT CALCULE PAR L'AI
    // Noter que dans la version initiale l'AI ne réalise que des mouvements du côté des Noirs et
    // que l'on ne peut jouer contre l'ordinateur qu'avec les Blancs...
    -(void)makeComputerMove // MCN nouvelle méthode permettant à l'AI de jouer des deux côté
    {
        //Move *aiMove = [Minimax bestMoveForSide:SideBlack board:board];   // Version initiale
        Move *aiMove = [Minimax bestMoveForSide:sideMachine board:board];   // Version  MCN
        [board performMove:aiMove];
        
        self.needsDisplay = YES;
    }


    
    // PAS ENCORE COMPRIS POURQUOI CE DIRTYRECT ?
    // et encore moins par qui est appelée cette méthode ?????
    // mais c'est ici qu'est appelée la méthode de dessin de l'échiquier, drawBoard, définie
    // en haut de la présente classe
    -(void)drawRect:(NSRect)dirtyRect
    {
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
        [self drawBoard];
    }

    
@end
