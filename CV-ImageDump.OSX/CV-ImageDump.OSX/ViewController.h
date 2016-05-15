//
//  ViewController.h
//  CV-ImageDump.OSX
//
//  Created by Jared Bruni on 10/24/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController {
    IBOutlet NSTextField *file_path;
    IBOutlet NSWindow *program_window;
    IBOutlet NSSlider *slider;
    IBOutlet NSTextField *frame_index;
    IBOutlet NSButton *output_frame;
    IBOutlet NSButton *output_all;
    IBOutlet NSProgressIndicator *progress;
    int fps, total_frames;
    
}

- (IBAction) selectFile: (id) sender;
- (IBAction) startProgram: (id) sender;
- (IBAction) dumpFrame: (id) sender;
- (IBAction) dumpAll: (id) sender;
- (IBAction) sliderChangedPos: (id) sender;


@end

