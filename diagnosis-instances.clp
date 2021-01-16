(definstances facts
	([a1] of adder
		(input1 [input_1])
		(input2 [input_1])
		(output
			[m1]
			[p1])
		(short-out 0)
		(suspect no))

	([a2] of adder
		(input1 [p1])
		(input2 [p2])
		(output [out1])
		(short-out 0)
		(suspect no))

	([circuit_1] of circuit
		(has-components
			[m1]
			[m2]
			[m3]
			[out1]
			[a1]
			[a2]
			[p1]
			[p2])
		(inputs
			[input_1]
			[input_2]
			[input_3]
			[input_4])
		(outputs [out1])
		(suspect no))

	([command_10_inp1] of command_data
		(clock 10)
		(object [input_1])
		(value 6))

	([command_10_inp2] of command_data
		(clock 10)
		(object [input_2])
		(value 4))

	([command_10_inp3] of command_data
		(clock 10)
		(object [input_3])
		(value 25))

	([command_10_inp4] of command_data
		(clock 10)
		(object [input_4])
		(value 12))

	([command_1_inp1] of command_data
		(clock 1)
		(object [input_1])
		(value 21))

	([command_1_inp2] of command_data
		(clock 1)
		(object [input_2])
		(value 28))

	([command_1_inp3] of command_data
		(clock 1)
		(object [input_3])
		(value 10))

	([command_1_inp4] of command_data
		(clock 1)
		(object [input_4])
		(value 25))

	([command_2_inp1] of command_data
		(clock 2)
		(object [input_1])
		(value 7))

	([command_2_inp2] of command_data
		(clock 2)
		(object [input_2])
		(value 25))

	([command_2_inp3] of command_data
		(clock 2)
		(object [input_3])
		(value 13))

	([command_2_inp4] of command_data
		(clock 2)
		(object [input_4])
		(value 15))

	([command_3_inp1] of command_data
		(clock 3)
		(object [input_1])
		(value 11))

	([command_3_inp2] of command_data
		(clock 3)
		(object [input_2])
		(value 17))

	([command_3_inp3] of command_data
		(clock 3)
		(object [input_3])
		(value 24))

	([command_3_inp4] of command_data
		(clock 3)
		(object [input_4])
		(value 31))

	([command_4_inp1] of command_data
		(clock 4)
		(object [input_1])
		(value 18))

	([command_4_inp2] of command_data
		(clock 4)
		(object [input_2])
		(value 11))

	([command_4_inp3] of command_data
		(clock 4)
		(object [input_3])
		(value 28))

	([command_4_inp4] of command_data
		(clock 4)
		(object [input_4])
		(value 21))

	([command_5_inp1] of command_data
		(clock 5)
		(object [input_1])
		(value 25))

	([command_5_inp2] of command_data
		(clock 5)
		(object [input_2])
		(value 24))

	([command_5_inp3] of command_data
		(clock 5)
		(object [input_3])
		(value 30))

	([command_5_inp4] of command_data
		(clock 5)
		(object [input_4])
		(value 10))

	([command_6_inp1] of command_data
		(clock 6)
		(object [input_1])
		(value 12))

	([command_6_inp2] of command_data
		(clock 6)
		(object [input_2])
		(value 19))

	([command_6_inp3] of command_data
		(clock 6)
		(object [input_3])
		(value 11))

	([command_6_inp4] of command_data
		(clock 6)
		(object [input_4])
		(value 19))

	([command_7_inp1] of command_data
		(clock 7)
		(object [input_1])
		(value 1))

	([command_7_inp2] of command_data
		(clock 7)
		(object [input_2])
		(value 31))

	([command_7_inp3] of command_data
		(clock 7)
		(object [input_3])
		(value 7))

	([command_7_inp4] of command_data
		(clock 7)
		(object [input_4])
		(value 22))

	([command_8_inp1] of command_data
		(clock 8)
		(object [input_1])
		(value 0))

	([command_8_inp2] of command_data
		(clock 8)
		(object [input_2])
		(value 31))

	([command_8_inp3] of command_data
		(clock 8)
		(object [input_3])
		(value 3))

	([command_8_inp4] of command_data
		(clock 8)
		(object [input_4])
		(value 23))

	([command_9_inp1] of command_data
		(clock 9)
		(object [input_1])
		(value 31))

	([command_9_inp2] of command_data
		(clock 9)
		(object [input_2])
		(value 1))

	([command_9_inp3] of command_data
		(clock 9)
		(object [input_3])
		(value 6))

	([command_9_inp4] of command_data
		(clock 9)
		(object [input_4])
		(value 8))

	([input_1] of command
		(suspect no))

	([input_2] of command
		(suspect no))

	([input_3] of command
		(suspect no))

	([input_4] of command
		(suspect no))

	([m1] of sensor
		(input [a1])
		(suspect no))

	([m2] of sensor
		(input [p1])
		(suspect no))

	([m3] of sensor
		(input [p2])
		(suspect no))

	([out1] of sensor
		(input [a2])
		(suspect no))

	([p1] of multiplier
		(input1 [input_2])
		(input2 [a1])
		(output
			[m2]
			[a2])
		(short-out 0)
		(suspect no))

	([p2] of multiplier
		(input1 [input_3])
		(input2 [input_4])
		(output
			[m3]
			[a2])
		(short-out 0)
		(suspect no))

	([reading_10_m1] of reading_data
		(clock 10)
		(object [m1])
		(value 12))

	([reading_10_m2] of reading_data
		(clock 10)
		(object [m2])
		(value 31))

	([reading_10_m3] of reading_data
		(clock 10)
		(object [m3])
		(value 12))

	([reading_10_out] of reading_data
		(clock 10)
		(object [out1])
		(value 28))

	([reading_1_m1] of reading_data
		(clock 1)
		(object [m1])
		(value 10))

	([reading_1_m2] of reading_data
		(clock 1)
		(object [m2])
		(value 24))

	([reading_1_m3] of reading_data
		(clock 1)
		(object [m3])
		(value 26))

	([reading_1_out] of reading_data
		(clock 1)
		(object [out1])
		(value 18))

	([reading_2_m1] of reading_data
		(clock 2)
		(object [m1])
		(value 0))

	([reading_2_m2] of reading_data
		(clock 2)
		(object [m2])
		(value 0))

	([reading_2_m3] of reading_data
		(clock 2)
		(object [m3])
		(value 3))

	([reading_2_out] of reading_data
		(clock 2)
		(object [out1])
		(value 3))

	([reading_3_m1] of reading_data
		(clock 3)
		(object [m1])
		(value 22))

	([reading_3_m2] of reading_data
		(clock 3)
		(object [m2])
		(value 6))

	([reading_3_m3] of reading_data
		(clock 3)
		(object [m3])
		(value 8))

	([reading_3_out] of reading_data
		(clock 3)
		(object [out1])
		(value 14))

	([reading_4_m1] of reading_data
		(clock 4)
		(object [m1])
		(value 4))

	([reading_4_m2] of reading_data
		(clock 4)
		(object [m2])
		(value 12))

	([reading_4_m3] of reading_data
		(clock 4)
		(object [m3])
		(value 12))

	([reading_4_out] of reading_data
		(clock 4)
		(object [out1])
		(value 0))

	([reading_5_m1] of reading_data
		(clock 5)
		(object [m1])
		(value 18))

	([reading_5_m2] of reading_data
		(clock 5)
		(object [m2])
		(value 16))

	([reading_5_m3] of reading_data
		(clock 5)
		(object [m3])
		(value 12))

	([reading_5_out] of reading_data
		(clock 5)
		(object [out1])
		(value 12))

	([reading_6_m1] of reading_data
		(clock 6)
		(object [m1])
		(value 8))

	([reading_6_m2] of reading_data
		(clock 6)
		(object [m2])
		(value 24))

	([reading_6_m3] of reading_data
		(clock 6)
		(object [m3])
		(value 17))

	([reading_6_out] of reading_data
		(clock 6)
		(object [out1])
		(value 9))

	([reading_7_m1] of reading_data
		(clock 7)
		(object [m1])
		(value 2))

	([reading_7_m2] of reading_data
		(clock 7)
		(object [m2])
		(value 0))

	([reading_7_m3] of reading_data
		(clock 7)
		(object [m3])
		(value 26))

	([reading_7_out] of reading_data
		(clock 7)
		(object [out1])
		(value 26))

	([reading_8_m1] of reading_data
		(clock 8)
		(object [m1])
		(value 0))

	([reading_8_m2] of reading_data
		(clock 8)
		(object [m2])
		(value 0))

	([reading_8_m3] of reading_data
		(clock 8)
		(object [m3])
		(value 0))

	([reading_8_out] of reading_data
		(clock 8)
		(object [out1])
		(value 0))

	([reading_9_m1] of reading_data
		(clock 9)
		(object [m1])
		(value 30))

	([reading_9_m2] of reading_data
		(clock 9)
		(object [m2])
		(value 30))

	([reading_9_m3] of reading_data
		(clock 9)
		(object [m3])
		(value 0))

	([reading_9_out] of reading_data
		(clock 9)
		(object [out1])
		(value 30))
)
