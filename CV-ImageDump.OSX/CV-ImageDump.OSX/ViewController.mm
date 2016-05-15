//
//  ViewController.m
//  CV-ImageDump.OSX
//
//  Created by Jared Bruni on 10/24/14.
//  Copyright (c) 2014 Jared Bruni. All rights reserved.
//

#import "ViewController.h"
#include"opencv2/opencv.hpp"

cv::VideoCapture capture;
cv::Mat frame;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [progress setHidden:YES];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction) selectFile: (id) sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    if([panel runModal]) {
        NSString *s = [[panel URL] path];
        [file_path setStringValue: s];
    }
}

- (IBAction) startProgram: (id) sender {
    NSString *str = [file_path stringValue];
    if([str length] == 0) {
        NSRunAlertPanel(@"Error invalid file name..\n", @"Invalid", @"Ok", nil, nil);
    }
    
    capture = cv::VideoCapture([str UTF8String]);
    if(!capture.isOpened()) {
        NSRunAlertPanel(@"Error", @"Could not Open Video File..\n", @"Ok", nil, nil);
        return;
    }
    
    fps = capture.get(CV_CAP_PROP_FPS);
    total_frames = capture.get(CV_CAP_PROP_FRAME_COUNT);
    [slider setIntegerValue: 0];
    [slider setMaxValue: total_frames];
    [slider setMinValue: 0];
    [slider setEnabled: YES];
    [output_all setEnabled: YES];
    [output_frame setEnabled: YES];
    cv::namedWindow("ImageDump", 1);
    [self sliderChangedPos:self];
}

- (void) awakeFromNib {
    [[[self view] window] setLevel: NSStatusWindowLevel];
}

- (IBAction) dumpFrame: (id) sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes: [NSArray arrayWithObjects: @"jpg", @"png", @"bmp", nil] ];
    if([panel runModal]) {
        NSString *filename = [[panel URL] path];
        imwrite([filename UTF8String], frame);
    }

}

- (IBAction) dumpAll: (id) sender {
    
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
    
    if(![panel runModal]) {
        return;
    }
    

    NSRunAlertPanel(@"This may time some time depending on how many frames.. be patient...\n", @"Might take a while", @"Ok", nil, nil);
    std::string path = [[[panel URL] path] UTF8String];
    
    [progress setHidden: NO];
    [progress setMinValue:0];
    [progress setMaxValue: total_frames];
    [progress startAnimation:self];
    
    
    dispatch_queue_t qt = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_sync(qt, ^{
    
    dispatch_async(qt, ^{
    
        int cx_frame_index = 0;
        std::string filename = "video.output.";
        capture.set(CV_CAP_PROP_POS_FRAMES,cx_frame_index);
        
        bool active = true;;
        while(active == true) {
            cv::Mat frame;
            if(capture.read(frame) == false) {
                break;
            }
            std::ostringstream stream;
            stream << path << "/" << filename  << ".frame" << "." << cx_frame_index << ".of." << total_frames << ".png";
            imwrite(stream.str(), frame);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [progress setDoubleValue:cx_frame_index];
                [progress displayIfNeeded];
            });
            ++cx_frame_index;
        }
   
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSRunAlertPanel(@"Successfully dumped video file...", @"Success", @"Ok", nil, nil);
            [progress stopAnimation:self];
        });
    });
    });
    
   }

- (IBAction) sliderChangedPos: (id) sender {
    
    long frame_pos = [slider integerValue];
    capture.set(CV_CAP_PROP_POS_FRAMES,frame_pos);
    if(capture.read(frame)) {
         imshow("ImageDump", frame);
    }
    [frame_index setIntegerValue: frame_pos];
}


@end
