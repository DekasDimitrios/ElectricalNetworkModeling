(defrule initialize
    ?x <- (initial-fact)
    =>
    (retract ?x)
    (set-fact-duplication FALSE)
    (assert (clock 1))

    (bind ?mc 1)
    (do-for-all-instances ((?rd reading_data)) (= 1 1)
        (if (> ?rd:clock ?mc) then
            (bind ?mc ?rd:clock))
    )
    (assert (max clock ?mc))

    (assert (next))
)

(defrule reset-system-entities
    ?x <- (reset)
    ?y <- (clock ?c)
    ?z <- (max clock ?mc)
    =>
    (retract ?x ?y)
    (do-for-all-instances ((?e systemEntity)) (= 1 1)
        (bind ?class (class ?e))
        (bind ?slots (class-slots ?class inherit))
        (foreach ?slot $?slots
            (bind ?type (nth$ 1 (slot-types ?class ?slot)))
            (if (eq ?type INTEGER) then
                (modify-instance ?e (?slot 0))
            )
            (if (or (eq ?slot suspect) (eq ?slot calculated)) then
                (modify-instance ?e (?slot no))
            )
        )
    )
    (if (< ?c ?mc)
        then
            (assert (clock (+ ?c 1)))
            (assert (next))
        else
            (retract ?z)
    )
)

(defrule start-circuit
    ?x <- (next)
    (clock ?c)
    =>
    (retract ?x)
    (assert (load))
)

(defrule load-data
    ?x <- (load)
    (clock ?c)
    =>
    (retract ?x)
    (do-for-all-instances ((?cd command_data)) (= ?c ?cd:clock)
        (send ?cd:object put-out ?cd:value)
        (send ?cd:object put-calculated yes)
    )
    (do-for-all-instances ((?rd reading_data)) (= ?c ?rd:clock)
        (send ?rd:object put-reading ?rd:value)
    )
    (assert (step))
)

(defrule component-step
    ?x <- (step)
    (not (guilty ?g))
    =>
    (retract ?x)
    (do-for-all-instances ((?c component)) (eq ?c:calculated no)
        (bind ?type (class ?c))
        (bind ?is-sensor (eq ?type sensor))
        (if (eq ?is-sensor TRUE)
            then
                (bind ?calc (send ?c:input get-calculated))
                (bind ?propagate (eq ?calc yes))
            else
                (bind ?calc1 (send ?c:input1 get-calculated))
                (bind ?calc2 (send ?c:input2 get-calculated))
                (bind ?propagate (and (eq ?calc1 yes) (eq ?calc2 yes)))
        )
        (if (eq ?propagate TRUE)
            then
                (send ?c put-calculated yes)
                (if (eq ?is-sensor TRUE)
                    then
                        (bind ?out (send ?c:input get-out))
                        (modify-instance ?c
                            (out ?out)
                            (theoretical ?out)
                        )
                        (bind ?prev-type (class ?c:input))
                        (bind ?prev-is-ic (superclassp internal-component ?prev-type))
                        (bind ?out-mismatch (not (eq ?out ?c:reading)))
                        (if (eq ?prev-is-ic TRUE)
                            then
                                (bind ?short (send ?c:input get-short-out))
                                (bind ?msb (send ?c:input get-msb-out))
                                (if (eq ?out-mismatch TRUE)
                                    then
                                        (if (eq ?short ?c:reading)
                                            then
                                                (assert (fault "Short-circuit!"))
                                                (assert (guilty ?c:input))
                                                (return)
                                            else
                                                (if (eq ?msb ?c:reading)
                                                    then
                                                        (assert (fault "Most Significant Bit is off!"))
                                                        (assert (guilty ?c:input))
                                                        (return)
                                                    else
                                                        (assert (fault "Short-circuit!"))
                                                        (assert (guilty ?c))
                                                        (return)
                                                )
                                        )
                                )
                            else
                                (if (eq ?out-mismatch TRUE) then
                                        (assert (fault "Short-circuit!"))
                                        (assert (guilty ?c))
                                        (return))
                        )
                    else
                        (bind ?out1 (send ?c:input1 get-out))
                        (bind ?out2 (send ?c:input2 get-out))
                        (if (eq ?type adder) then
                            (bind ?out (mod (+ ?out1 ?out2) 32)))
                        (if (eq ?type multiplier) then
                            (bind ?out (mod (* ?out1 ?out2) 32)))
                        (bind ?msb-out (mod ?out 16))
                        (modify-instance ?c
                            (out ?out)
                            (msb-out ?msb-out)
                        )
                )
            else
                (assert (step))
        )
    )
)

(defrule announce-results
    (clock ?c)
    (not (next))
    (not (load))
    (not (step))
    =>
    (printout t "Time: " ?c " --> ")
    (assert (announce))
)

(defrule announce-guilty
    ?x <- (fault ?f)
    ?y <- (guilty ?g)
    ?z <- (announce)
    =>
    (printout t (class ?g) " " (instance-name-to-symbol ?g) " error: " ?f crlf)
    (retract ?x ?y ?z)
    (assert (reset))
)

(defrule finish-circuit
    ?x <- (announce)
    =>
    (printout t "Normal Operation!" crlf)
    (retract ?x)
    (assert (reset))
)
