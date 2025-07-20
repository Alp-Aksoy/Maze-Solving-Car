# Maze-Solving-Car


# Introduction and Description:

Maze Solving Car is an automated vehicle that navigates and solves simple mazes without requiring outside interference. It uses HC-SR04 Ultrasonic sensors to detect walls and navigate through based on logical decisions derived from implementation on an FPGA board using VHDL. The purpose of the project is to demonstrate the FPGA system interfacing hardware control with sensor input processing and a decision-making algorithm for intelligent motion.

# Methodology:

The project is implemented on a Basys 3 FPGA development board using VHDL software. The core functionality consists of autonomously navigating a maze with three ultrasonic sensors. These sensors keep measuring in front of, to the left, and to the right of the car simultaneously. At the same time, control logic implemented on the FPGA interprets the distance data in real time, and if the front distance is lower than 25cm, or the left or right sensors detect a distance lower than 35cm, it interprets it as a wall. Based on these measurements, the system will either go straight, turn right, turn left, or turn 180 degrees.
The outputs of ultrasonic sensors have assigned to LEDs. In the photos, the singular LED on the right side of the car shows whether flashlight has been used to stop the car. On the other hand, the three consecutive LEDs on the left side of the car shows output of LEDs. All decision-making is carried out by a finite state machine (FSM) that associates sensor inputs with motion commands. The motor driver receives two DC motors and then interfaces with the FPGA through PWM signals. Also included are logic level converters for converting from 5V sensors to 3.3V FPGA I/Os. The system is powered by an external power supply, completely separate from the Basys-3 board. An LDR module is used to sense light as a trigger signal — when light is sensed, the car will stop moving. The buzzer provides audio feedback sounds as a finish signal.


# Components:

•	2 DC Motors 

•	3 HC-SR04 Ultrasonic Distance Sensor 

•	External power source 

•	Motor Driver

•	Logic Converters

•	Basys 3 FPGA 

•	A computer to run the VHDL code 

•	Buzzer 

•	Photoresistor (LDR) 

# Design Specifications:

To clarify what each module’s role in VHDL codes is, modules will be briefly explained below:

# Car.vhd:

Top-level module that integrates all components. It manages the overall system behavior. It utilizes PWM modules to control the speed of the motors, and by using the outputs of the three ultrasonic sensors, it determines its movements. Additionally, it has a memory that stores the outputs of the ultrasonic sensors when the car turns into a dead-end.

# Pwm1 / Pwm2 (pwm.vhd)

Generates Pulse Width Modulation signals for controlling the speed of the motors.

# CLOCK (clk_div.vhd)

A clock divider that provides a slower clock signal suitable for PWM generation.

# Ultrasonics: Three_ultrasonic (Three_ult.vhd)

Merges the left, right, and front ultrasonic sensor modules. Left and right use the same submodule, but the front uses a submodule that detects the previous distance.

# Ultrasonic left and right: (Ult.vhd)

Detects the wall if the ultrasonic sensor gets closer to the wall by more than 35 cm.

# Ultrasonic Middle:(Ult_front.vhd)

Detects the wall if the ultrasonic sensor gets closer to the wall by more than 25 cm.

# trigger_generation: (trigger_module.vhd)

Sends a short trigger pulse to activate the ultrasonic sensor for 100us.

# Counter (Counter.vhd)

This is a basic counter that has been utilized throughout the project.

