ChainBlockerApp
======

ChainBlockerApp is a web based application that takes users badge information, creates a hash code out of it and submit the hash to Chainpoint endpoint. Upon successful submission, response from API is listed on user interface.


Ruby version
--------
    2.6.0

Rails version
--------
    6.0.1

How to run the test suite
--------
    rspec

Future Additions
--------

  - Add badge table to save badge information
  - Add states and state machine(aasm) to handle following states for badge:
    - initialised
    - created
    - submitted
    - failed

