# File-Times-Display
A Mac OSX Cocoa app that displays 8 different file times (and permissions) for a given file or folder, and monitors for changes.

The purpose of this app is to help you learn which file times are updated as you perform different actions using the file in the operating system.

Choose a file or folder to display, then watch the file times change as you preview the file, open it, modify it, etc.

I used Xcode 4.6.3 to create this project.  It is written in Objective-C. You will have to open the project in Xcode and compile it.

Tracks these file times:
Created (birth) Time
Content Creation Time
Access Time (atime)
Last Used Time (double-clicked file)
Added (to folder) 
Modified Time (mtime)
Change Time (ctime)
Metadata change time
