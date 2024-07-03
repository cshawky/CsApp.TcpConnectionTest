# CsApp.TcpConnectionTest
A simple WPF application using SuperSimpleTcp to test network connectivity and simulate TCP services.
This package contains the executables and installer only.

## Installation

Download the zip file from GitHub https://github.com/cshawky/CsApp.TcpConnectionTest
Unzip the file to a temporary folder say C:\Source
Open the folder and read the readme, else run the Install.cmd with elevated priveleges.
The application will be installed to C:\Program Files\CShawky\{AppName} but may be manually deploy it anywhere your computer security settings allow.
The idea is that the user has read only rights to the executable folder.

The best way to use the app, is to create a desktop shortcut(s) and a folder for each shortcut start up folder location. Modify the shortcut and use the folder as the start up location.
All logs and settings will be saved to this location. That way you may store multiple sets of configuration. The application has its own defaults
found in the program files folder.

This release is time limited.

The user interface provides full configuration and diagnostics of the app.

## Caveat
The app uses SuperSimpleTcp and you are in power of the timings, number of servers and clients created on any single computer. Scaleability
is not yet tested.

## TODO List
Unfortunately this Alpha release does not animate the status of server and client connections. That is next on the list.
It should however provide a decent test harness for network connectivity testing via the log file.

Enjoy
