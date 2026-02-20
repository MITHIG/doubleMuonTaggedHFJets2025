default: all

all: Setup library/Messenger.o library/DimuonMessenger.o

Setup:
	mkdir -p library
	mkdir -p binary

library/Messenger.o: source/Messenger.cpp include/Messenger.h
	g++ source/Messenger.cpp -Iinclude -c -o library/Messenger.o `root-config --cflags`

library/DimuonMessenger.o: source/DimuonMessenger.cpp include/DimuonMessenger.h
	g++ source/DimuonMessenger.cpp -Iinclude -c -o library/DimuonMessenger.o `root-config --cflags`
