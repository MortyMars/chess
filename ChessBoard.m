//
//  ChessBoard.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//
//  Définition de l'échiquier en termes de données : couleur, nature, position des pièces...

#import "ChessBoard.h"
#import "util.h"
#import "Piece.h"
#import "Pos.h"
#import "Move.h"
#import "Minimax.h"         // MCN
//#import "AppDelegate.h"   // MCN
#import "MCNconnecteur.h"   // MCN


@implementation ChessBoard

    -(id)init
    {
        if (self=[super init]) {
        }
        return self;
    }

    // INITIALISATION DES PIECES SUR L'ECHIQUIER (AFFECTATION DE LEUR POSITION EN DEBUT DE PARTIE)
    // Cette METHODE est appelée dans ChessView.m
    -(void)setupPieces
    {
        // Détermination des couleurs JOUEUR et IA, avant construction de l'échiquier
        [self defCouleurHumain]; // La méthode d'instance est implémentée plus bas
        
        // Initialisation d'un tableau à 2 entrées représentant le positionnement
        // des pièces du JOUEUR sur la ligne 0 en début de partie
        board[0][0] = [[Piece alloc] initWithType:Piece_Tour side:sideHumain];
        board[1][0] = [[Piece alloc] initWithType:Piece_Cavalier side:sideHumain];
        board[2][0] = [[Piece alloc] initWithType:Piece_Fou side:sideHumain];
        // selon l'orientation de l'échiquier la ligne 0 recevra les Blancs ou les Noirs
        // et les positions de la Reine et du Roi sont à adapter en conséquence
        board[3][0] = [[Piece alloc] initWithType:(sideHumain == SideWhite) ? Piece_Reine : Piece_Roi
                                             side:sideHumain];
        board[4][0] = [[Piece alloc] initWithType:(sideHumain == SideWhite) ? Piece_Roi : Piece_Reine
                                             side:sideHumain];
        board[5][0] = [[Piece alloc] initWithType:Piece_Fou side:sideHumain];
        board[6][0] = [[Piece alloc] initWithType:Piece_Cavalier side:sideHumain];
        board[7][0] = [[Piece alloc] initWithType:Piece_Tour side:sideHumain];
        
        // Balayage horizontal de l'abcisse x=0 à l'abcisse x=7
        for (int x = 0; x < 8; x++) {
            // Pions JOUEUR en ligne 1
            board[x][1] = [[Piece alloc] initWithType:Piece_Pion side:sideHumain];
            // Pions IA en ligne 6
            board[x][6] = [[Piece alloc] initWithType:Piece_Pion side:sideMachine];
            // Recopie de la ligne 0 en ligne 7, mais pour les pièces de l'IA
            board[x][7] = [[Piece alloc] initWithType:board[x][0].type side:sideMachine];
        }
        
        // Modif. MCN
        // FORCER L'IA A JOUER EN PREMIER QUAND ELLE A LES BLANCS
        // le test if perturbe la variable sideHumain !!!???
        // Si l'IA a les Blancs, alors il faut qu'elle joue
        // Cet appel placé ici, juste après initialisation de l'échiquier,
        // garantit qu'il ne la sera qu'une seule fois
           if (sideHumain == SideBlack) {
               
               NSLog(@"\nRappel : l'IA a les %@ et doit donc commencer", (sideMachine == SideWhite)? @"Blancs" : @"Noirs");
               
               [self premCoupAIblancs];
               
           }
        // Fin de Modif.
        
    }

    -(Piece *)piece_colX:(int)x
                   rangY:(int)y
    {
        if (x < 0 || y < 0 || x > 7 || y > 7) return nil;
        return board[x][y];
    }

    -(Piece *)pieceAtPos:(Pos *)pos
    {
        int x = pos.x, y = pos.y;
        if (x < 0 || y < 0 || x > 7 || y > 7) return nil;
        return board[x][y];
    }

    -(void)performMove:(Move *)move
    {
        // Déplacement de pièce dans le cas général
        Piece *piece = [self MovePieceDela:move.start Adela:move.dest];
        
        // Quand le Roi JOUEUR roque la tour concernée se déplace également
        // (le roque Machine doit être géré ailleurs ?!...)
        if (piece.type == Piece_Roi && abs(move.dest.x - move.start.x) > 1) {
            if (sideHumain == SideWhite){ // If MCN
                // si la dest du Roi est la case 2 c'est la Tour de G qui est concernée (petit roque)
                // sinon c'est la tour D qui est concernée (grand roque)
                int rookX = (move.dest.x == 2) ? 0 : 7; // selon Tour de G ou de D
                // la Tour de G bascule en case 3, ou la Tour de D bascule en case 5
                int rookDestX = (rookX == 0) ? 3 : 5;
                [self MovePieceDela:[Pos posWithX:rookX y:move.dest.y] Adela:[Pos posWithX:rookDestX y:move.dest.y]];
            } // Fin If MCN
            
            // Modif. MCN, second traitement gérant le cas du JOUEUR ayant les Noirs
            if (sideHumain == SideBlack){
                // si la dest du Roi est la case 1 c'est la Tour de G qui est concernée (petit roque)
                // sinon c'est la Tour D qui est concernée (grand roque)
                int rookX = (move.dest.x == 1) ? 0 : 7;
                // la Tour de G bascule en case 2, ou la Tour de D bascule en case 4
                int rookDestX = (rookX == 0) ? 2 : 4;
                [self MovePieceDela:[Pos posWithX:rookX y:move.dest.y] Adela:[Pos posWithX:rookDestX y:move.dest.y]];
            }
        }
        
        self.lastMove = move;   // save this move
    }

    -(Piece *)MovePieceDela:(Pos *)start Adela:(Pos *)dest
    {
        // move in board
        board[(int)dest.x][(int)dest.y] = board[(int)start.x][(int)start.y];
        
        Piece *piece = board[(int)dest.x][(int)dest.y];
        piece.numMoves++; // increment number of moves
        
        board[(int)start.x][(int)start.y] = nil;
        
        return piece;
    }

    -(id)copyWithZone:(NSZone *)zone
    {
        ChessBoard *newBoard = [[ChessBoard allocWithZone:zone] init];
        for (int x = 0; x < 8; x++) {
            for (int y = 0; y < 8; y++) {
                if (board[x][y]) newBoard->board[x][y] = board[x][y].copy;
            }
        }
        newBoard.lastMove = self.lastMove.copy;
        return newBoard;
    }

    -(NSString *)description
    {
        NSString *desc = @"";
        for (int y = 7; y >= 0; y--) {
            for (int x = 0; x < 8; x++) {
                desc = [desc stringByAppendingFormat:@"%d ",board[x][y].type];
            }
            desc = [desc stringByAppendingString:@"\n"]; // ajout retour chariot en fin de string
        }
        return desc;
    }

    // MCN
    // Méthode d'instance permettant d'affecter la couleur de chacun des adversaires, Humain et Machine
    -(void)defCouleurHumain
    {
        if ((sideHumain == SideInvalid) || (sideMachine == SideInvalid))
        {
        
        // Création d'une boite d'alerte pour le choix de la couleur
        NSAlert *alertChoixCouleur = [[NSAlert alloc] init];
        [alertChoixCouleur addButtonWithTitle:@"Les Blancs"];
        [alertChoixCouleur addButtonWithTitle:@"Les Noirs"];
        [alertChoixCouleur setMessageText:@"Choix de la couleur"];
        [alertChoixCouleur setInformativeText:@"Quelle couleur souhaitez-vous jouer ?"];
        [alertChoixCouleur setAlertStyle:NSAlertStyleInformational];
            
        // Récupération du choix fait par le joueur et détermination de sideHumain
        NSModalResponse boutonChoisi = [alertChoixCouleur runModal];
        if (boutonChoisi == NSAlertFirstButtonReturn) {
                sideHumain=SideWhite;
            }
        else {
                sideHumain = SideBlack;
            }
        /*  NB : La boite d'alerte est modale et interdit donc la poursuite du programme
            avant d'avoir choisi la couleur que l'on souhaite jouer dans cette partie.
            Lorsque la boite d'alerte se ferme et perd le focus de premier plan,
            la fenêtre de l'échiquier ne le récupère pas systématiquement et dans la
            négative il faut penser à aller chercher l'application qui tourne
            souvent dans l'arrière plan de X-Code lui-même                              */
                
            
        
        // sideMachine prend la couleur laissée par le JOUEUR
        sideMachine = (sideHumain == SideWhite) ? SideBlack : SideWhite;
        
        NSLog(@"\nLe JOUEUR a les %@, l'IA les %@", (sideHumain == SideWhite)? @"Blancs" : @"Noirs",
                                                   (sideMachine == SideWhite)? @"Blancs" : @"Noirs");
        
        // ***************************************************************************
        // TO CHECK
        //[[MCNconnecteur self] editeSortieTexte:@"Test à partir de ChesseBoard\n"];
        // FIN de TO CHECK
        // ***************************************************************************
        
        }
        else {
        NSLog(@"\nLe JOUEUR a les %@, l'IA les %@", (sideHumain == SideWhite)? @"Blancs" : @"Noirs",
                                                   (sideMachine == SideWhite)? @"Blancs" : @"Noirs");
        }
        
    } // Fin de defCouleurHumain

    // MCN
    // Méthode d'instance, appelée en fin d'initialisation du plateau quand l'IA a les blancs
    // LE TOUT PREMIER COUP DE LA PARTIE REVIENT A L'IA QUAND ELLE A LES BLANCS
    -(void)premCoupAIblancs
    {
        // self fait référence à l'objet ChessBoard qui appelle la méthode premCoupAIblancs
        Move *firstAImove = [Minimax bestMoveForSide:sideCourant board:self];
        [self performMove:firstAImove];
        
        //self.needsDisplay = YES;
    }

@end
