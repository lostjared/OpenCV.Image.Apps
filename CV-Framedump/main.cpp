#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<sstream>
#include<cstdlib>
#include<ctime>
#include<cmath>
#include "opencv2/opencv.hpp"

int main(int argc, char **argv) {
    if(argc != 3) {
        std::cerr << "Error requires two arguments.\n" << argv[0] << " videofile framenumber" << "\n";
        return 0;
    }
    std::string filename = argv[1];
    int frame_index = atoi(argv[2]);
    if(frame_index < 0) {
        std::cerr << "Error invalid frame..\n";
        return -1;
    }
    cv::VideoCapture capture(filename);
    
    if(!capture.isOpened()) {
        std::cerr << "Error could not open stream: " << filename << ".\n";
        return -1;
    }
    capture.set(CV_CAP_PROP_POS_FRAMES,frame_index);
    cv::Mat frame;
    if(capture.read(frame) == false) {
        std::cerr << "Error reading frame....\n";
        return -1;
    }
    std::ostringstream frame_name;
    frame_name << filename << ".output.frame." << frame_index << ".png";
    imwrite(frame_name.str(), frame);
    std::cout << "Wrote: " << frame_name.str() << "\n";
    return 0;
}