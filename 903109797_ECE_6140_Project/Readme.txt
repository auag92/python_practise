This package contains source codes for all three parts of ECE 6140 project as also the supporting functions used. 

There are two special functions "cprintf" and "sort_nat" written by Yair M. Altman and Douglas M. Schwarz
respectively whihch are used to just improve the asthetics of the program. Removing these functions will
in no way effect the operation of project source codes.

Part 1: Logic Simulator
This file is with name "logic_simulator.m". It uses two other functions update_1_input_gate and Update_2_input_gate
along with two text files out of 8 for reading input circuit and input vectors for the respective input circuit. So
while selecting the input circuit, the corresponding input vector matrix must be used.

Part 2: Deductive Fault Simulator 
This file is with name "deductive_fault_simulator.m". It uses the same two functions as in logic simulator along with
"sort_nat" function, which is used to sort an array of strings. The input circuit file has to be chosen properly for 
full functionality of the fault simulator.

Part 3: PODEM
This file is with name "podem_main.m". It uses various functions like 
	1. sort_nat
	2. cprintf
	3. podem1
	4. obejctive
	5. backtrace
	6. imply2
	7. gate_eval
	8. dfs
	9. node_update_1_input_gate_imply
	10. node_update_2_input_gate_imply

The input circuit file has to be chosen properly for full functionality of the PODEM algorithm.
NOTE: All the files should be in same directory. 

The working of all the codes has been explained in the report file along with this readme.

Author: C.V. Chaitanya Krishna
email:	cvchaitanyak7@gmail.com 
