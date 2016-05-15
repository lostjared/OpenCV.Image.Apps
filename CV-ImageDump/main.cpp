/* 
 
 CV Image Dump
 
 
 Dump all frames from Video file to PNG (Lossless) Graphic files.
 
 written by Jared Bruni
 http://lostsidedead.com
 
*/

#include<iostream>
#include<unistd.h>
#include <sys/stat.h>
#include<sys/types.h>
#include"opencv2/opencv.hpp"
#include<sstream>


int main(int argc, char **argv) {
    if(argc != 3) {
        std::cerr << "Error invalid arguments.\nProgram takes two arguments.\n" << argv[0] << " videofile folder\n";
        return 0;
    }
    std::string filename = argv[1];
    std::string path = argv[2];
    int result = mkdir(path.c_str(), S_IRWXU);
    if(result == 0) {
        std::cout << "Successfully created directory..\n";
    }
    cv::VideoCapture capture(filename);
    if(!capture.isOpened()) {
        std::cerr << "Error could not open stream..\n";
        return -1;
    }
    int fps = capture.get(CV_CAP_PROP_FPS);
    int total_frames = capture.get(CV_CAP_PROP_FRAME_COUNT);
    int frame_index = 0;
    
    bool active = true;;
    while(active == true) {
        cv::Mat frame;
        if(capture.read(frame) == false) {
            break;
        }
        std::ostringstream stream;
        stream << path << "/" << filename << ".frame" << "." << frame_index << ".of." << total_frames << ".png";
        imwrite(stream.str(), frame);
        ++frame_index;
        std::cout << "Wrote Second: " << (float)(frame_index/fps) << " to: " << stream.str() << "\n";
    }
    std::cout << "Successfully generated: " << frame_index << "/" << total_frames << " frame at path: " << path << "\n";
    return 0;
}