How to use 'DTrack Control Server'
----------------------------------

'DTrack Control Server' is a simple tool, that enhances the remote capabilities of DTrack. Standard DTrack
accepts commands via ethernet (UDP). It allows just to start/stop a measurement and to control data
output. 'DTrack Control Server' makes it possible to start/stop a DTrack application and to switch between
several DTrack set-ups via remote commands.

It uses similar commands as DTrack, but additionally offers to send them via TCP, which establishes safer
connections than UDP. For convenience 'normal' DTrack commands also can be sent to 'DTrack Control Server';
they will be forwarded to DTrack.

The following implies that you are familiar with DTrack and standard DTrack remote commands. Otherwise
refer to the corresponding sections at 'ARTtrack&DTrack Manual' first.


Command/Data flow via ethernet:
-------------------------------

A typical system with 'DTrack Control Server' could be as follows:


  --------       UDP      -----------------------
 | DTrack | <----------- | DTrack Control Server |       DTrack PC
  --------      5002      -----------------------
     |                              ^
     |                              |
 UDP | 5000              UDP or TCP | 5001
     |                              |
     |                         ---------     
      --------------------->  |  User   |                User PC
                               ---------


If you already use DTrack remote commands (i.e. 'dtrack 10 3'), only minor changes are necessary at user
side. Just send Control Server commands ('dtrackcontrol ...', see below) to the same UDP port as
DTrack commands. Alternatively you can use a TCP connection for both kinds of commands. Tracking data
will come from DTrack as before.

An example source code (in C, useable for Windows and Unix) 'example_dcs_client.c' shows how to send
commands via ethernet. Command syntax is:

> example_dcs_client UDP|TCP <ip> <port>

After starting it out of a command window, the user can input command lines (see example below). 


Setting up DTrack:
------------------

Switching between several DTrack set-ups uses the fact, that all necessary set-up data for DTrack are
located in directory 'Setup'. So 'DTrack Control Server' does a simple thing when changing a set-up:
it just copies all files from a directory 'Setup_<name>' to 'Setup'. The word <name> can be any string
that doesn't contain spaces. All 'Setup_<name>' directories have to be in the DTrack directory (where
'Setup' and 'DTrack.exe' are too).

Set up DTrack as follows:

1. Start DTrack manually and do all settings for the first set-up (calibrations, ...) as usual. Be
sure to activate 'use remote port' (f.i. choose 5002 as port number for DTrack remote commands).

2. COPY all files from 'Setup' into a new created directory 'Setup_<name>' (f.i. 'Setup_s1'). 

3. Repeat step 1 and 2 for other set-ups.

CAUTION: be aware, that DTrack knows nothing about the 'Setup_<name>' directories. Any changes (in
settings, calibrations, ...) done later will influence only data within the main 'Setup'. Be sure to
copy all files in 'Setup' to the corresponding 'Setup_<name>' directory after changes. Otherwise the
changes will be lost after the next set-up switching.


Starting 'DTrack Control Server':
---------------------------------

The executable 'DTrack_controlserver.exe' has to be present in the DTrack directory (like 'DTrack.exe').
It has to be started out of a command window with command syntax:

> dtrack_controlserver UDP|TCP <UDP|TCP port> <DTrack UDP remote port>

F.i. for the above settings type:

> dtrack_controlserver TCP 5001 5002

Now the Control Server accepts DTrack and Control Server commands at TCP port 5001; DTrack commands are
forwarded to UDP port 5002 (at the same PC).


'DTrack Control Server' remote commands:
----------------------------------------

'DTrack Control Server' so far accepts three additional commands, all of them starting with the phrase
'dtrackcontrol':

dtrackcontrol start                   # Starting the DTrack executable
dtrackcontrol stop                    # Killing a running DTrack executable
dtrackcontrol setup <name>            # Activate DTrack settings in directory 'Setup_<name>'

Each command (no matter what type) has to be in a seperate ethernet packet. Be sure to finish the commands
with a cr/lf.

CAUTION: Switching between set-ups is just possible, when no DTrack application is running. So take care to
stop DTrack before changing a set-up.


Example:
--------

The following shows an example command sequence. It implies that set-ups were created in directories
'Setup_s1' and 'Setup_s2' like described above and a 'DTrack Control Server' is running.

1. Open a command window. Start the example client:

> example_dcs_client TCP 127.0.0.1 5001

2. At first switch to set-up 's1'. As we don't know, if a DTrack is running, send a stop command first:

command: dtrackcontrol stop
command: dtrackcontrol setup s1
command: dtrackcontrol start

3. Start the cameras and produce some output data:

command: dtrack 10 3
command: dtrack 31

4. Stop the measurement:

command: dtrack 32
command: dtrack 10 0

5. Now switch to set-up 's2', start the cameras again. Output data due to set-up 's2' should be created:

command: dtrackcontrol stop
command: dtrackcontrol setup s2
command: dtrackcontrol start
command: dtrack 10 3
command: dtrack 31



