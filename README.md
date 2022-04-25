# DSED_AUDIOproject
Project for the subject DSED (DIGITAL ELECTRONIC SYSTEMS DESIGN). Design and implementation of a digital electronic system that records, processes and plays audios.

Combinational and sequential design, design of finite state machines and finite state machines with associated data path, high level synthesis methodology and timing.
System that, using the audio input and output interfaces of the Nexys 4DDR board, acquires, stores, processes and reproduces sounds.

## System structure:

![image](https://user-images.githubusercontent.com/78792851/165140362-adfd7fc8-7bb4-4316-a77f-13887d61c28d.png)


### Audio interface 
It is in charge of digitizing the PDM signals coming from the microphone. It is the block in charge of interacting with the audio output providing it with a PWM signal. This block will be implemented following a finite state machine methodology with associated data path.
### FIR filter
It digitally processes the audio signal for high pass filter and low pass filter functionalities. Block implemented following the high-level synthesis methodology.
### RAM memory
Stores the audio samples that have been previously recorded. 
### Controller
Orchestrates all the system performance providing control signals to the different blocks to execute the system user's commands.



