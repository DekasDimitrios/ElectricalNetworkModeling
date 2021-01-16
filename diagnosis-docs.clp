;- Task #1 [Reset Values]: For each clock step, reset all systemEntity values to the default
;- Task #2 [Load Inputs]: For all commands c_i: c_i[out] := C_i[value] (where C_i is the corresponding command_data)

;- Task #3a [IC Step]: For all internal-components ic_i: calculate ic_i[out], ic_i[short-out], ic_i[msb-out] based on input1[?] and input2[?]
;- Task #3b [Sensor Step]: For all sensor s_i: 
;--                                             s_i[reading] := S_i[value] (where S_i is the corresponding reading_data)
;--                                             s_i[out] := (s_i[input])[?]
;--                                             s_i[theoretical] := (s_i[input])[out]

;-- Task #4 [Update Circuit]: For circuit z: z[out] = (z[outputs][0])[out]

;---------------------------------------------------------------------------------------------------------------------------------------------

;- circuit_X [is-a circuit -> systemEntity]
;- circut X's values
;-- suspect yes/no
;-- inputs components
;-- outputs components
;-- has-components components (contains ICs, sensors, outputs)
;-- out in binary

;- input_X [is-a command -> systemEntity]
;- input X's values
;-- suspect yes/no
;-- out in binary

;- command_Y_inpX [is-a command_data -> data]
;- input X's value for (clock Y)
;-- object input
;-- clock integer ID
;-- value in binary

;- aX [adder] / pX [multiplier] [is-a internal-component -> component -> systemEntity]
;- adder/multiplier X's values
;-- suspect yes/no
;-- input1, input2 components
;-- out, short-out, msb-out in binary
;-- output component

;- mX/outX [is-a sensor -> component -> systemEntity]
;- sensor X's values
;-- suspect yes/no
;-- input component
;-- reading in binary (value shown to user)
;-- out in binary (value given to next component)
;-- theoretical in binary (value based on circuit input, assuming no malfunctions)

;- reading_Y_X [is-a reading_data -> data]
;- sensor X's value for (clock Y)
;-- object sensor
;-- clock integer ID
;-- value in binary
