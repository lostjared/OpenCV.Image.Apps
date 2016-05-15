CXX=c++
FLAGS= -O3 `pkg-config opencv  --cflags --libs`
all:
	$(CXX)   main.cpp  -o cv-framedump  $(FLAGS) -stdlib=libstdc++
clean:
	rm -f cv-framedump
