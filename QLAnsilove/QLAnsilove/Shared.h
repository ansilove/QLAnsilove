//
//  Shared.h
//  QLAnsilove
//
//  Created by Christian Vozar on 11/2/17.
//  Copyright © 2017 Ansilove. All rights reserved.
//

#import <AnsiLove/AnsiLove.h>

// instances
ALAnsiGenerator           *ansiGen;

// strings
NSMutableAttributedString *contentString;
NSMutableAttributedString *rawAnsiString;
NSString                  *ansiCacheFile;
NSString                  *retinaCacheFile;
NSString                  *exportCacheFile;
NSString                  *exportURLString;
NSString                  *alURLString;
NSString                  *alOutputString;
NSString                  *alFont;
NSString                  *alBits;
NSString                  *alColumns;
NSString                  *fontName;
NSStringEncoding          txtEncoding;
NSStringEncoding          exportEncoding;
NSSize                    canvasSize;

// images
NSImage *renderedAnsiImage;
