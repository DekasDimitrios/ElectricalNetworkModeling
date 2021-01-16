(defrule reset-system-entities
    ?x <- (reset)
    ?y <- (clock ?c)
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
)

(defrule start-circuit
    ?x <- (initial-fact)
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
                (bind ?propagate (and (eq ?calc1 yes) (eq ?calc2 yes))))
        (if (eq ?propagate TRUE) then
            (send ?c put-calculated yes)
            (if (eq ?is-sensor TRUE)
                then
                    (bind ?out (send ?c:input get-out))
                    (modify-instance ?c
                        (out ?out)
                        (theoretical ?out)
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
            (assert (step))
        )
    )
)

(defrule finish-circuit
    (clock ?c)
    (not (load))
    (not (step))
    =>
    (printout t "circuit finished" crlf)
)
