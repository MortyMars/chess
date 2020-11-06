//
//  util.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#ifndef chess_util_h
#define chess_util_h

// "PieceType" définit -via une énum- un nouveau type pour les pièces du jeu
typedef enum {Piece_Invalide, Piece_Pion, Piece_Cavalier, Piece_Fou,
              Piece_Tour, Piece_Reine, Piece_Roi} PieceType;

// "Side" définit -via une énum- un nouveau type pour les couleurs en présence
typedef enum {SideInvalid, SideBlack, SideWhite} Side;

// Modif. MCN
// Ajout de variables globales (pardon) pour :
// - suivre quelle couleur a été la dernière à être jouée
// - enregistrer les couleurs JOUEUR et IA

extern Side sideCourant;

extern Side sideHumain;
extern Side sideMachine;

extern NSString *stringCoupsPartie;

// Fin de Modif.

#endif



