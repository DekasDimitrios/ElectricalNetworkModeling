; Authors
; Dimitris Dekas 3063
; Konstantinos Papakostas 3064
; Christina Kreza 3077

(defrule initialize
    ?x <- (initial-fact) ; only run once
    =>
    ; retract the initial-fact
    (retract ?x)

    ; set options for fact duping and strategy
    (set-fact-duplication FALSE)
    (set-strategy mea)

    ; calculate max clock
    (bind ?mc 1)
    ; for all reading data instances
    ; with a clock value greater than max clock
    (do-for-all-instances ((?rd reading_data)) (> ?rd:clock ?mc)
        (bind ?mc ?rd:clock)
    )
    (assert (max clock ?mc))
    
    ; initialize clock and start
    (assert (clock 1))
    (assert (load))
)

(defrule reset-system-entities
    ?x <- (reset)           ; if we're called to reset the entities
    ?y <- (clock ?c)        ; for a given clock value
    ?z <- (max clock ?mc)   ; and a max clock value
    =>
    ; retract the reset & clock facts
    (retract ?x ?y)

    ; for all system entities
    (do-for-all-instances ((?e systemEntity)) TRUE
        (bind ?class (class ?e))
        (bind ?slots (class-slots ?class inherit))
        ; for each of the instance's slots (including the inherited)
        (foreach ?slot $?slots
            ; get the first slot type (INSTANCE slots have multiple types)
            (bind ?type (nth$ 1 (slot-types ?class ?slot)))
            ; if the slot is INTEGER, reset it to 0
            (if (eq ?type INTEGER) then
                (modify-instance ?e (?slot 0))
            )
            ; if the slot name is "calculated", reset it to "no"
            (if (eq ?slot calculated) then
                (modify-instance ?e (?slot no))
            )
        )
    )

    (if (< ?c ?mc)
        then
            ; assert a new clock fact
            ; with an incremented value
            (assert (clock (+ ?c 1)))
            (assert (load))
        else
            ; retract the max clock fact
            (retract ?z)
    )
)

(defrule load-readings
    ?x <- (load)    ; if we're called to load the readings
    (clock ?c)      ; for a given clock value
    =>
    ; retract the load fact
    (retract ?x)

    ; for each command/reading data instance with the current clock,
    ; put the reading in the corresponding component instance
    (do-for-all-instances ((?cd command_data)) (= ?c ?cd:clock)
        (modify-instance ?cd:object
            (out ?cd:value)
            (calculated yes)
        )
    )
    (do-for-all-instances ((?rd reading_data)) (= ?c ?rd:clock)
        (send ?rd:object put-reading ?rd:value)
    )

    ; continue to forward pass
    (assert (step))
)

(defrule forward-pass
    ?x <- (step)        ; if we're called to do a forward pass step
    (not (guilty ?g))   ; and we haven't identified a guilty component yet
    =>
    ; retract the step fact
    ; (it will be re-asserted if needed later)
    (retract ?x)

    ; for each component that hasn't been "calculated" yet
    (do-for-all-instances ((?c component)) (eq ?c:calculated no)
        (bind ?type (class ?c))
        (bind ?is-sensor (eq ?type sensor))
        (if (eq ?is-sensor TRUE)
            then
                ; if the component is a sensor, get its input
                (bind ?calc (send ?c:input get-calculated))
                ; propagate forward if its input has been calculated
                (bind ?propagate (eq ?calc yes))
            else
                ; if the component is an IC, get both its inputs
                (bind ?calc1 (send ?c:input1 get-calculated))
                (bind ?calc2 (send ?c:input2 get-calculated))
                ; propagate forward if both inputs have been calculated
                (bind ?propagate (and (eq ?calc1 yes) (eq ?calc2 yes)))
        )
        
        ; if the component isn't set to propagate yet
        (if (eq ?propagate FALSE)
            then
                ; re-run forward-pass once more
                (assert (step))
            else
                ; otherwise, mark it as calculated
                (send ?c put-calculated yes)

                ; if the component isn't a sensor
                ; (which means it's an internal-component)
                (if (eq ?is-sensor FALSE)
                    then
                        ; get its inputs' outputs
                        (bind ?out1 (send ?c:input1 get-out))
                        (bind ?out2 (send ?c:input2 get-out))

                        ; perform the corresponding logic
                        (if (eq ?type adder) then
                            ; addition for adder
                            (bind ?out (mod (+ ?out1 ?out2) 32))
                        )
                        (if (eq ?type multiplier) then
                            ; multiplication for multiplier
                            (bind ?out (mod (* ?out1 ?out2) 32))
                        )

                        ; set the slots accordingly
                        (modify-instance ?c
                            (out ?out)
                            (msb-out (mod ?out 16))
                        )
                    else
                        ; otherwise, if it's a sensor,
                        ; set propagate its input as output
                        (bind ?out (send ?c:input get-out))
                        (send ?c put-out ?out)

                        ; if there's a mismatch between the reading and the output
                        (if (neq ?out ?c:reading) then
                            ; if the previous component is an IC
                            (if (superclassp internal-component (class ?c:input))
                                then
                                    (bind ?short (send ?c:input get-short-out))
                                    (bind ?msb (send ?c:input get-msb-out))
                                    (bind ?is-short (eq ?short ?c:reading))
                                    (bind ?is-msb (eq ?msb ?c:reading))

                                    ; check if the reading matches with either
                                    ; a) the short output
                                    ; b) the MSB output
                                    ; c) neither of those
                                    (if (and (eq ?is-short FALSE) (eq ?is-msb FALSE))
                                        then
                                            ; (c) if it's neither, then
                                            ; the sensor itself shortcircuited
                                            (assert (fault "Short-circuit!"))
                                            (assert (guilty ?c))
                                        else
                                            ; (a) the previous component has shortcircuited
                                            (if (eq ?is-short TRUE) then
                                                (assert (fault "Short-circuit!"))
                                                (assert (guilty ?c:input))
                                            )
                                            ; (b) the previous component has its MSB off
                                            (if (eq ?is-msb TRUE) then
                                                (assert (fault "Most Significant Bit is off!"))
                                                (assert (guilty ?c:input))
                                            )
                                    )
                                    
                                else
                                    ; if the previous component isn't an IC
                                    ; (which means it's probably a sensor, even
                                    ; though this case doesn't exist in our circuit)
                                    ; then this sensor must have shortcircuited
                                    ; (as we've already checked the previous one
                                    ; and we didn't detect any mismatches)
                                    (assert (fault "Short-circuit!"))
                                    (assert (guilty ?c))
                            )
                            ; no need to continue with the forward propagation
                            ; since we've found the guilty component
                            (return)
                        )
                )
        )
    )
)

(defrule announce-results
    (not (load))    ; if we're done loading the data
    (not (step))    ; and we're not doing forward propagation
    (clock ?c)      ; for a given clock value
    =>
    ; print info about the current clock value
    (printout t "Time: " ?c " --> ")
    ; trigger the announcement rules
    ; that will determine whether there
    ; has been a guilty component or not
    (assert (announce))
)

(defrule announce-guilty-two-faults
    (declare (salience 3))  ; make sure this runs before all other announcement rules
    ?x <- (announce)        ; if we're called to announce the results
    ?y1 <- (fault ?f1)      ; and there's both one fault description
    ?y2 <- (fault ?f2&~?f1) ; and another one, different to the previous
    ?z <- (guilty ?g)       ; for a certain guilty component
    =>
    ; retract the announce and (1st) fault facts
    (retract ?x ?y1)
    ; print info about the guilty component and its fault description
    (printout t (class ?g) " " (instance-name-to-symbol ?g) " error: " ?f1 crlf)
    ; trigger the announce-results rule again for the other fault
    (refresh announce-results)
)

(defrule announce-guilty
    (declare (salience 2))  ; make sure this runs after the previous announcement rule
    ?x <- (announce)        ; if we're called to announce the results
    ?y <- (fault ?f)        ; and there's a fault description
    ?z <- (guilty ?g)       ; for a certain guilty component
    =>
    ; retract the announce, fault and guilty facts
    (retract ?x ?y ?z)
    ; print info about the guilty component and its fault description
    (printout t (class ?g) " " (instance-name-to-symbol ?g) " error: " ?f crlf)
    ; reset the system entities and run for the next clock
    (assert (reset))
)

(defrule announce-normal
    (declare (salience 1))  ; make sure this runs last of all announcement rules
    ?x <- (announce)        ; if we're called to announce the results
    =>
    ; retract the announce fact
    (retract ?x)
    ; print info about the circuit's normal operation
    (printout t "Normal Operation!" crlf)
    ; reset the system entities and run for the next clock
    (assert (reset))
)
