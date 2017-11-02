//
//  GenerateThumbnailForURL.m
//  QLAnsilove
//
//  QLAnsilove is Copyright © 2017, Christian R. Vozar / Alpha King <blocktronics>
//  AnsiLove.framework is Copyright © 2010-2017, Stefan Vogt
//  Ansilove/C is Copyright © 2011-2017, Stefan Vogt, Brian Cassidy, and Frederic Cambus
//
//  All rights reserved.
//

#import "Shared.h"

#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <WebKit/WebKit.h>

OSStatus
GenerateThumbnailForURL(void *thisInterface,
                        QLThumbnailRequestRef thumbnail,
                        CFURLRef url,
                        CFStringRef contentTypeUTI,
                        CFDictionaryRef options,
                        CGSize maxSize)
{
    @autoreleasepool {
        // Generate 'Application Support' folder.
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSString *folder = @"~/Library/Application Support/QLAnsilove/";
        folder = [folder stringByExpandingTildeInPath];
        
        if ([fileManager fileExistsAtPath:folder] == NO)
        {
            [fileManager createDirectoryAtPath:folder
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        // Instantiate ALAnsiGenerator.
        ansiGen = [ALAnsiGenerator new];
        
        // Explicitly utilize filename extension in case UTI is not registered for file.
        NSString* extension = [[(__bridge NSURL*)url pathExtension] lowercaseString];
        if ([extension isEqualToString:@"ans"] || [extension isEqualToString:@"nfo"] || [extension isEqualToString:@"mem"] || [extension isEqualToString:@"diz"] || [extension isEqualToString:@"asc"] || [extension isEqualToString:@"idf"] || [extension isEqualToString:@"xb"] || [extension isEqualToString:@"tnd"] || [extension isEqualToString:@"cia"])
        {
            alBits = @"8";
            alColumns = @"160";
            
            bool isIceColors = YES;
            // Determine if iCE Colors should stay on or off
            
            // If there is no content string, create one.
            if (contentString == nil) {
                contentString = [[NSMutableAttributedString alloc] initWithString:@""];
            }
            
            // Get current file URL and convert it to an UNIX path.
            NSURL *tnCurrentURL = (__bridge NSURL *)url;
            alURLString = [tnCurrentURL path];
            
            // Get currrent file name without any path informations.
            NSString *tnPureFileName = [alURLString lastPathComponent];
            
            ansiCacheFile = [NSString stringWithFormat:
                               @"~/Library/Application Support/QLAnsilove/%@.png", tnPureFileName];
            
            retinaCacheFile = [NSString stringWithFormat:
                                 @"~/Library/Application Support/QLAnsilove/%@@2x.png", tnPureFileName];
            
            // Expand tilde in cache file path.
            ansiCacheFile = [ansiCacheFile stringByExpandingTildeInPath];
            retinaCacheFile = [retinaCacheFile stringByExpandingTildeInPath];
            
            // Create string we can pass as outputfile flag.
            alOutputString = [NSString stringWithFormat:
                                @"~/Library/Application Support/QLAnsilove/%@", tnPureFileName];
            alOutputString = [alOutputString stringByExpandingTildeInPath];
            
            // Invoke AnsiLove to generate rendered image.
            [ansiGen renderAnsiFile:alURLString
                           outputFile:alOutputString
                                 font:@"80x25"
                                 bits:alBits
                            iceColors:isIceColors
                              columns:alColumns
                               retina:YES];
            
            // Wait for AnsiLove.framework to finish rendering.
            // TODO: Replace with ansilove.framework rendering out an NSImage rather than a file to disk.
            [NSThread sleepForTimeInterval:0.1];
            
            NSImage *renderedImage = [[NSImage alloc] initWithContentsOfFile:ansiGen.ansi_retinaOutputFile];
            
            CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((CFDataRef)[NSData dataWithContentsOfFile:ansiCacheFile]);
            CGImageRef image_ref = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
            
            canvasSize = renderedImage.size;
            
            // Draw rendered png to graphics context provided by QuickLook.
            if (image_ref != NULL)
            {
                CGContextRef cgContext = QLThumbnailRequestCreateContext(thumbnail, *(CGSize *)&canvasSize, false, NULL);
                if(cgContext) {
                    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)cgContext flipped:YES];
                    if(context) {
                        
                        NSRect theRect = NSMakeRect(0.0,0.0, canvasSize.width, canvasSize.height);
                        
                        [NSGraphicsContext saveGraphicsState];
                        [NSGraphicsContext setCurrentContext:context];
                        
                        [context saveGraphicsState];
                        
                        [renderedImage drawAtPoint:NSZeroPoint fromRect:theRect operation:NSCompositingOperationSourceOver fraction:1];
                        
                        // Set context back.
                        [NSGraphicsContext restoreGraphicsState];
                    }
                    
                    // Flush request graphics context.
                    QLThumbnailRequestFlushContext(thumbnail, cgContext);
                    
                    CFRelease(cgContext);
                }
                CGImageRelease(image_ref);
                
                if ([fileManager fileExistsAtPath:ansiCacheFile] == YES)
                {
                    [fileManager removeItemAtPath:ansiCacheFile error:nil];
                }
                
                if ([fileManager fileExistsAtPath:retinaCacheFile] == YES)
                {
                    [fileManager removeItemAtPath:retinaCacheFile error:nil];
                }
            }
            return noErr;
        }
    }
    return kQLReturnNoError;
}

void CancelThumbnailGeneration(void* thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Not implemented.
}

