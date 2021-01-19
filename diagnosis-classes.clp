(defclass systemEntity
	(is-a USER)
	(role abstract)
	(single-slot calculated
		(type SYMBOL)
		(allowed-values yes no)
		(default no)
		(create-accessor read-write))
	(single-slot out
		(type INTEGER)
		(range 0 31)
		(create-accessor read-write)))

(defclass command
	(is-a systemEntity)
	(role concrete))

(defclass component
	(is-a systemEntity)
	(role abstract))

(defclass sensor
	(is-a component)
	(role concrete)
	(single-slot out
		(type INTEGER)
		(range 0 31)
		(create-accessor read-write))
	(single-slot reading
		(type INTEGER)
		(range 0 31)
		(create-accessor read-write))
	(single-slot input
		(type INSTANCE)
		(allowed-classes internal-component)
		(create-accessor read-write)))

(defclass internal-component
	(is-a component)
	(role concrete)
	(single-slot short-out
		(type INTEGER)
		(range 0 0)
		(default 0)
		(create-accessor read-write))
	(multislot output
		(type INSTANCE)
		(allowed-classes component)
		(create-accessor read-write))
	(single-slot msb-out
		(type INTEGER)
		(range 0 15)
		(create-accessor read-write))
	(single-slot input2
		(type INSTANCE)
		(allowed-classes systemEntity)
		(create-accessor read-write))
	(single-slot input1
		(type INSTANCE)
		(allowed-classes systemEntity)
		(create-accessor read-write)))

(defclass adder
	(is-a internal-component)
	(role concrete))

(defclass multiplier
	(is-a internal-component)
	(role concrete))

(defclass circuit
	(is-a systemEntity)
	(role concrete)
	(multislot outputs
		(type INSTANCE)
		(allowed-classes sensor)
		(create-accessor read-write))
	(multislot has-components
		(type INSTANCE)
		(allowed-classes component)
		(create-accessor read-write))
	(multislot inputs
		(type INSTANCE)
		(allowed-classes command)
		(create-accessor read-write)))

(defclass data
	(is-a USER)
	(role abstract)
	(single-slot clock
		(type INTEGER)
		(range 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot object
		(type INSTANCE)
		(allowed-classes systemEntity)
		(create-accessor read-write))
	(single-slot value
		(type INTEGER)
		(create-accessor read-write)))

(defclass command_data
	(is-a data)
	(role concrete)
	(single-slot object
		(type INSTANCE)
		(allowed-classes command)
		(create-accessor read-write)))

(defclass reading_data
	(is-a data)
	(role concrete)
	(single-slot object
		(type INSTANCE)
		(allowed-classes sensor)
		(create-accessor read-write)))
