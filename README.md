passhandske
===========

Gesture based passwords using a sensor glove (for DT2140@KTH)

___

Instructions
---

_How to run_
* Download the Arduino sketch to your board
* Run the Processing sketch

_Controls_

The Processing sketch is controlled with keyboard inputs.

* Change state with the number keys:
  * 1: SET state, for recording a new password.
  * 2: INPUT state, for inputting a password (in other words, simulating an attempt to log in)
  * 3: VERIFY state, for comparing passwords (this state is automatically activated after INPUT)
* Space bar toggles input from the glove.

So using this will work something like this:

1. Start the Processing sketch, first state is SET.
2. Toggle input from glove with space, move your hand around, press space again to end the password input.
3. If you're happy with the password, press '2' to activate the INPUT state.
4. Toggle glove input, try to re-enter the password, end input with space.
5. VERIFY state activates and tells you whether you succeeded or not. To try again, press '2'.
