//
//  Minimax.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "Minimax.h"
#import "ChessBoard.h"
#import "Piece.h"
#import "Move.h"
#import "Pos.h"
#import "RuleBook.h"
//#import "AppDelegate.h"
#import "MCNconnecteur.h"
#import "util.h"

#define NUMBER_MOVES_AHEAD 3    // Constante qui définit sur combien de tours à venir
                                // l'algorithme fera ses simulations
                                // (Est-ce important que ce soit un nombre impair ?)

@implementation Minimax

    // Modif. MCN
    @synthesize miniSortieTexte;
    -(void)editeMiniSortieTexte:(NSString *)strMiniSortieTexte
    {
        miniSortieTexte.cell.title = strMiniSortieTexte;}
    // Fin de Modif.

    //*************************************************************************************************************
    // Méthode de classe
    +(Move *)bestMoveForSide:(Side)side
                       board:(ChessBoard *)board
    {
        int bestScore = -INFINITY; // INFINITY est une "macro" donnant une représentation de l'infini...
        Move *bestMove = nil;
        // Pour chacun des coups possibles pour la couleur considérée...
        // (NUMBER_MOVES_AHEAD étant fixé à 3, l'algo fera une simul pour les prochains tours : joueur, IA, et joueur à nouveau)
        for (Move *newMove in [self possibleMovesForSide:side board:board])
        {
            ChessBoard *newBoard = board.copy; // On travaille sur une copie du board courant
            [newBoard performMove:newMove];
            int score = [self minimaxForSide:side board:newBoard depth:NUMBER_MOVES_AHEAD alpha:-INFINITY beta:INFINITY];
            if (score > bestScore || !bestMove)
            {
                NSLog(@"\nLes %@ jouent %@ avec un score de %d",(side == SideBlack) ? @"Noirs" : @"Blancs",newMove,score);
                
                // Modif. MCN : Ultimes tests d'affichage dans le champ texte via le code   //
                MCNconnecteur *newMCNconnecteur = [[MCNconnecteur alloc] init];             //
                [newMCNconnecteur editeSortieTexte:@"Test à partir de Minimax"];            //
                                                                                            //
                Minimax *newMinimax = [[Minimax alloc] init];                               //
                newMinimax.miniSortieTexte.cell.title = @"Test 2 à partir de Minimax";      //
                // Fin de Modif.                                                            //
                
                bestScore = score;
                bestMove = newMove;
            } // Fin de if
        } // Fin de for
        
        // Modif. MCN
        // Récupération de la chaine décrivant les coups de l'IA via la variable globale stringCoupsPartie
        // après concaténation en deux opérations, la première étant un retour à la ligne qui s'applique
        // dès la deuxième ligne, mais pas sur la première (souci cosmétique)
        if (![stringCoupsPartie  isEqual: @""]) {
            stringCoupsPartie = [stringCoupsPartie stringByAppendingString:@"\n"];
        }
        stringCoupsPartie = [stringCoupsPartie stringByAppendingString:[NSString stringWithFormat:@"%@",bestMove]];
        // Fin de Modif.
        
        return bestMove;
    }

    //*************************************************************************************************************
    // Méthode de classe
    +(int)minimaxForSide:(Side)side
                   board:(ChessBoard *)board
                   depth:(int)depth
                   alpha:(int)alpha
                    beta:(int)beta
    {
        if (depth <= 0) { // depth va passer de 3 à 2 puis 1, et à 0 on retourne scoreForSide, càd la valeur finale de score
            return [self scoreForSide:side board:board];
        }
        else {
            int best = INFINITY;
            Side otherSide = (side == SideWhite) ? SideBlack : SideWhite; // minimaxForSide IA s'intéresse aux 3 prochains
                                                                          // tours : joueur, puis IA, et enfin joueur
            // Pour chaque coup possible de chacun des 3 tours à venir ==>
            for (Move *newMove in [self possibleMovesForSide:otherSide board:board]) {
                ChessBoard *newBoard = board.copy;
                [newBoard performMove:newMove]; // ==> on simule son exécution, pour connaitre et évaluer chaque board résultant
                // Oups, appel à récursivité :-\
                // la méthode s'appelle elle-même pour poursuivre la simul pour les tours de profondeur (depth) 2 et 1
                int score = -[self minimaxForSide:otherSide
                                            board:newBoard
                                            depth:depth - 1         // De 3 on passe à 2, puis 1
                                            alpha:-beta      // Les valeurs alpha et beta sont interverties à chaque
                                             beta:-alpha];   // nouvel appel récursif, sachant que la couleur elle-même
                                                             // est intervertie à chaque nouvel appel : IA, Joueur
                                                             // puis IA à nouveau)
                                                             // Cette permutation est nécessaire puisque ce qui est Max
                                                             // pour l'IA est cohérent avec ce qui est Min pour le Joueur
                best = MIN(best,score);
                //if (score > alpha) alpha = score; // Ligne commentée par l'auteur...
                //if (alpha >= beta) return alpha;  // quel impact sur les performances de l'algo ???
            } // Fin de for
            return best;
        } // Fin de else
    }

    //*************************************************************************************************************
    // Méthode de classe
    +(int)scoreForSide:(Side)side
                 board:(ChessBoard *)board
    {
        int score = 0;
        
        // On va balayer chaque case de l'échiquier considéré, et donner une valeur globale totalisant la valeur
        // de chacune des pièces encore présentes
        // La note accordée à un échiquier considéré ne tient donc compte que de la présence ou non des pièces
        // de chacun des cotés, et en aucun cas des positions stratégiques et des menaces potentielles...
        // C'est un peu décevant... :-(
        for (int x = 0; x < 8; x++)             // balayage des abcisses
        {
            for (int y = 0; y < 8; y++)         // balayage des ordonnées
            {
                Piece *piece = [board piece_colX:x rangY:y];
                if (piece)
                {
                    int value = 0;
                    switch (piece.type)
                    {
                        case Piece_Invalide: break;                 // si pas de pièce, pas de valeur ajoutée
                        case Piece_Pion: value = 100; break;        // s'il y a un pion : +100
                        case Piece_Fou: value = 300; break;         // +300 pour un fou
                        case Piece_Cavalier: value = 300; break;    // ...
                        case Piece_Tour: value = 500; break;
                        case Piece_Reine: value = 900; break;
                        case Piece_Roi: value = 100000; break;
                    }
                    // Si la pièce est du coté visé par l'appel de la méthgode, alors la valeur s'ajoute,
                    // sinon elle est déduite
                    score += value * ((piece.side == side) ? 1 : -1);
                }
            }
        }
        
        // ligne suivante à commenter ou non pour masquer ou pas, le message des calculs de scores
        // if (score) NSLog(@"\nLe score est de %d pour le cas \n%@ et le côté des %@",score,board,(side == SideBlack) ? @"Noirs" : @"Blancs");
        
        return score;
    }

    //*************************************************************************************************************
    // Méthode de classe
    +(NSSet *)possibleMovesForSide:(Side)side
                             board:(ChessBoard *)board
    {
        NSMutableSet *moves = [[NSMutableSet alloc] init];
        for (int x = 0; x < 8; x++)
        {
            for (int y = 0; y < 8; y++)
            {
                Pos *pos = [Pos posWithX:x y:y];
                Piece *piece = [board piece_colX:x rangY:y];
                if (piece)
                {
                    if (piece.side == side)
                    {
                        NSSet *PosAcceptees = [RuleBook PosAccepteesForPiece:piece atPos:pos inBoard:board];
                        for (Pos *possibleDest in PosAcceptees)
                        {
                            Move *move = [[Move alloc] initWithStart:pos dest:possibleDest];
                            [moves addObject:move];
                        }
                    }
                }
            }
        }
        return moves;
    }

- (IBAction)test:(id)sender {
}
- (IBAction)TestAction:(NSTextFieldCell *)sender {
}
@end
