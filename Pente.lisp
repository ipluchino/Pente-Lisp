;************************************************************
;* Name:  Ian Pluchino                                      *
;* Project: OPL Project 2 Lisp                              *
;* Class: N/A                                               *
;* Date:  10/18/23                                          *
;************************************************************

;Function Name: StartPente
;Purpose: To start Pente - the entry point of the program.
;Parameters: None
;Return Value: None
;Algorithm: 
;             1) Ask the user if they would like to start a new tournament or load a new one.
;             2) If they would like to start a new tournament, create a new game state and start one.
;             3) Otherwise load the game state from a file and begin the tournament.
;Assistance Received: None
(defun StartPente()
  (terpri)
  (princ "Welcome to Pente!")
  (terpri)
  
  (let* ((tournamentChoice (GetTournamentDecision)))
    ;The user would like to start a new tournament.
    (cond ( (= tournamentChoice 1)
            (StartTournament (CreateNewGameState)) )
          
          ;The user would like to load a tournament from a file.
          ( (= tournamentChoice 2)
            (let* ( (loadedTournamentState (LoadTournament)) )
              
              (cond ( (null loadedTournamentState)
                      (princ "Could not locate the file!")
                      (terpri)
                      (StartPente) ) 

                    (t
                      (terpri)
                      (StartTournament loadedTournamentState) )
              )

            ) )  
    )
  )
)

;Function Name: GetTournamentDecision
;Purpose: To get the user's decision on whether they would like to start a new tournament or load one from a file.
;Parameters: None
;Return Value: An integer (1 or 2) representing the user's choice.
;Algorithm:
;             1) Display the choices.
;             2) Validate and return the input.
;Assistance Received: None
(defun GetTournamentDecision()
  (princ "Options:")
  (terpri)
  (princ "1. Start a new tournament.")
  (terpri)
  (princ "2. Load a tournament from a file.")
  (terpri)
  (terpri)
  (princ "Enter your choice (1 or 2): ")
  (ValidateTournamentDecision (read-line))
  
)

;Function Name: ValidateTournamentDecision
;Purpose: To validate the tournament decision.
;Parameters: 
;              input, a string representing the user's choice.
;Return Value: An integer, representing a valid tournament decision.
;Algorithm:
;              1) Convert the user's choice to an integer.
;              2) Validate the choice is either 1 or 2.
;              3) If it isn't, recursively ask the user to enter a new input.
;Assistance Received: None
(defun ValidateTournamentDecision(input)
  (let* ((numInput (parse-integer input :junk-allowed t)))
    
    (cond ( (or (null numInput) (< numInput 1) (> numInput 2))
            (princ "Invalid tournament decision!")
            (terpri)
            (terpri)
            (GetTournamentDecision) )
        (t
          numInput )
    )
    
  )
)

;Function Name: CreateNewGameState
;Purpose: To create a game state list for a new game.
;Parameters: None
;Return Value: A list representing the game state of the game.
;Algorithm: None
;Assistance Received: None
(defun CreateNewGameState()
  (list (CreateBoard) 0 0 0 0 "unknown" 'W)
)

;Function Name: CreateBoard
;Purpose: To create a list representing an empty board.
;Parameters: None
;Return Value: A list representing a completely empty board of the game. 
;Algorithm: None
;Assistance Received: None
(defun CreateBoard() 
  (list '(- - - - - - - - - - - - - - - - - - -) 
        '(- - - - - - - - - - - - - - - - - - -) 
        '(- - - - - - - - - - - - - - - - - - -) 
        '(- - - - - - - - - - - - - - - - - - -) 
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -) 
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
        '(- - - - - - - - - - - - - - - - - - -)
  )
)

;Function Name: StartTournament
;Purpose: To start the tournament loop and play rounds of Pente.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: None
;Algorithm:
;              1) Run a single round of Pente with the current game state.
;              2) Ask the user if they would like to play another round.
;              3) If they do want to keep playing, recursively call this function to start another round.
;              4) If they are finished playing, display the winner of the tournament.
;Assistance Received: None
(defun StartTournament(gameState)
  (let* ( (completedRound (StartRound gameState)) 
          (continueDecision (GetContinueDecision)) )
      
      (cond ( (string= continueDecision "Y") 
              (StartTournament completedRound) )
            (t
              (DisplayWinner completedRound)
              (princ "Thanks for playing!") )
      )
   )
)

;Function Name: LoadTournament
;Purpose: To load a tournament from a file.
;Parameters: None
;Return Value: A list, representing the correctly formatted game state loaded in from a file.
;Algorithm:
;              1) Ask the user for the file name to load the tournament from.
;              2) Open the file and read its contents.
;              3) If the file is found, correctly format the read in game state list (see FixLoadState function) and return it.
;              4) Otherwise, return an empty list if the file could not be located.
;Assistance Received: https://www.tutorialspoint.com/lisp/lisp_file_io.htm
(defun LoadTournament ()
  (let* ( (fileName (GetLoadFileName)) 
          (in (open fileName :if-does-not-exist nil)) )
    
    ;If the file stream is nil, that means the file could not be located. Return nil.
    (cond ( (null in)
            () )
          
          ;Otherwise, return the fixed loaded game state.
          (t
            (FixLoadState (read in)) )
    )
  )
)

;Function Name: GetLoadFileName
;Purpose: To get the name of the file from the user that they would like to read in from.
;Parameters: None
;Return Value: A string, representing the name of the file the user wishes to read in from.
;Algorithm: None
;Assistance Received: None
(defun GetLoadFileName()
  (princ "Enter the name of the file to load the tournament from (ex: file.txt): ")
  (read-line)
)

;Function Name: FixLoadState
;Purpose: To correctly format the game state list that was read in from a file.
;Parameters:
;              gameState, a list representing the game state list that was read in from the file.
;Return Value: A list, representing the correctly formatted game state list.
;Algorithm:
;              1) Fix the board by setting the empty cells to "-" for viewing purposes.
;              2) Fix the next player value from a symbolic representation to a string.
;              3) Fix the next player color's value from a symbolic representation to a single character.
;Assistance Received: None
(defun FixLoadState (gameState)
  (let* ( (fixedBoard (SetEmpties gameState (AllBoardLocations 0 0) 'O '-)) 
          (fixedNextPlayer (FixNextPlayer fixedBoard)) 
          (fixedNextPlayerColor (FixNextPlayerColor fixedNextPlayer)) )
    fixedNextPlayerColor
  )
)

;Returns a list of all the valid board locations on the board starting at (0, 0) and ending at (18, 18)
;Function Name: AllBoardLocations
;Purpose: To generate a list containing all possible board locations.
;Parameters:
;              row, an integer representing the current row being evaluated.
;              col, an integer representing the current column being evaluated.
;Return Value: A list, representing all possible board locations on the 19x19 Pente board.
;Algorithm:
;              1) Recursively loop through each possible location on the board.
;              2) If the row and column pair is valid, add it to the return list.
;              2) If the column number gets greater than 18, move on to the next row.
;              3) If the row number gets greater than 18, stop the recursion and return the list.
;Assistance Received: None
(defun AllBoardLocations (row col)
	(cond ( (> col 18)
	        (AllBoardLocations (+ row 1) 0)	)
 
		    (	(> row 18)
			    ()  )
 
		    (t
			    (cons (list row col) (AllBoardLocations row (+ col 1)))	)
	)
)

;Function Name: SetEmpties
;Purpose: To replace all empty values on the board from "find" to "setTo".
;Parameters:
;              gameState, a list representing the current game state list.
;              boardLocations, a list representing all valid board locations on the board.
;              find, a character representing what locations on the board need to be changed.
;              setTo, a character representing what to change empty locations to.
;Return Value: A list, representing the updated game state with the updated board.
;Algorithm:
;              1) Recursively loop through all possible locations on the board.
;              2) If what is on the board at a location is equal to "find", replace it with "setTo".
;              3) Once all board locations have been checked, return the updated game state.
;Assistance Received: None
(defun SetEmpties(gameState boardLocations find setTo)
  (cond ( (null boardLocations)
          gameState )

        (t
          (let* ( (row (first (first boardLocations)))
                  (col (first (rest (first boardLocations))))
                  (board (GetBoard gameState)) )

            (cond ( (eq (At board row col) find)
                    (SetEmpties (SetBoard gameState (UpdateBoard board row col setTo)) (rest boardLocations) find setTo) )

                  (t
                    (SetEmpties gameState (rest boardLocations) find setTo) )
            )


          ) )
  )
)

;Function Name: GetBoard
;Purpose: To get the board from a game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the current board of the game.
;Algorithm: None
;Assistance Received: None
(defun GetBoard (gameState)
  (nth 0 gameState)
)

;Function Name: SetBoard
;Purpose: To set the board into a game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;              board, a list representing a board that will replace the old board in the game state list.
;Return Value: A list, representing the updated game state list with the new board.
;Algorithm: None
;Assistance Received: None
(defun SetBoard(gameState board)  
  (cond ( (and (= (length board) 19) (= (length (first board)) 19))
          (list board
          (nth 1 gameState)
          (nth 2 gameState)
          (nth 3 gameState)
          (nth 4 gameState)
          (nth 5 gameState)
          (nth 6 gameState) ) )

        (t
          (princ "Invalid board!") 
          gameState )
  )
)

;Function Name: FixNextPlayer
;Purpose: To convert the next player from symbolic representation to string representation and vice versa.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game state list with the fixed next player value.
;Algorithm: None
;Assistance Received: None
(defun FixNextPlayer (gameState)
  ;Converting from symbolic representation to string representation --> for loading.
  (cond ( (eq (GetNextPlayer gameState) 'HUMAN)
          (SetNextPlayer gameState "Human") )

        ( (eq (GetNextPlayer gameState) 'COMPUTER)
          (SetNextPlayer gameState "Computer") )

        ;Converting from string representation to symbolic representation --> for saving.
        ( (string= (GetNextPlayer gameState) "Human")
          (SetNextPlayer gameState 'Human) )

        ( (string= (GetNextPlayer gameState) "Computer")
          (SetNextPlayer gameState 'Computer) )
  )
)

;Function Name: GetNextPlayer
;Purpose: To get the next player from the game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A string, representing which player plays next.
;Algorithm: None
;Assistance Received: None
(defun GetNextPlayer (gameState)
  (nth 5 gameState)
)

;Function Name: SetNextPlayer
;Purpose: To set the next player into a game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;              nextPlayer, a string representing the new next player.
;Return Value: A list, representing the updated game state list with the updated next player.
;Algorithm: None
;Assistance Received: None
(defun SetNextPlayer(gameState nextPlayer)
  (cond ( (not (or (string= nextPlayer "Human") (string= nextPlayer "Computer") (string= nextPlayer "unknown") (eq nextPlayer 'HUMAN) (eq nextPlayer 'COMPUTER)))
          (princ "Invalid next player!")
          gameState )

        (t
          (list (nth 0 gameState)
          (nth 1 gameState)
          (nth 2 gameState)
          (nth 3 gameState)
          (nth 4 gameState)
          nextPlayer
          (nth 6 gameState) ) )
  )
)

;Function Name: FixNextPlayerColor
;Purpose: To convert the next player color from symbolic representation to string representation and vice versa.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game state list with the fixed next player color value.
;Algorithm: None
;Assistance Received: None
(defun FixNextPlayerColor (gameState)
  ;Used for when loading a file.
  (cond ( (eq (GetNextPlayerColor gameState) 'WHITE)
          (SetNextPlayerColor gameState 'W) )

        ( (eq (GetNextPlayerColor gameState) 'BLACK)
          (SetNextPlayerColor gameState 'B) )

        ;Used for when saving the file.
        ( (eq (GetNextPlayerColor gameState) 'W)
          (SetNextPlayerColor gameState 'WHITE) )

        ( (eq (GetNextPlayerColor gameState) 'B)
          (SetNextPlayerColor gameState 'BLACK) )
  )
)

;Function Name: GetNextPlayerColor
;Purpose: To get the next player's color from the game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A character, representing the color of the next player.
;Algorithm: None
;Assistance Received: None
(defun GetNextPlayerColor (gameState)
  (nth 6 gameState)
)

;Function Name: SetNextPlayerColor
;Purpose: To set the next player's color into a game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;              nextPlayerColor, a character representing the new next player color.
;Return Value: A list, representing the updated game state list with the updated next player color.
;Algorithm: None
;Assistance Received: None
(defun SetNextPlayerColor(gameState nextPlayerColor)
  (cond ( (not (or (eq nextPlayerColor 'W) (eq nextPlayerColor 'B) (eq nextPlayerColor 'WHITE) (eq nextPlayerColor 'BLACK)))
          (princ "Invalid next player color!") 
          gameState )

        (t 
          (list (nth 0 gameState)
                (nth 1 gameState)
                (nth 2 gameState)
                (nth 3 gameState)
                (nth 4 gameState)
                (nth 5 gameState)
                nextPlayerColor ) )
  )
)

;Function Name: GetContinueDecision
;Purpose: To get whether or not the user would like to play another round of Pente.
;Parameters: None
;Return Value: A string, representing yes or no.
;Algorithm:
;              1) Ask the user whether they would like to continue playing.
;              2) Validate and return the user's input.
;Assistance Received: None
(defun GetContinueDecision()
  (princ "Would you like to continue playing and start a new round? Enter Y or N: ")
  (ValidateContinueDecision (read-line))
)

;Function Name: ValidateContinueDecision
;Purpose: To validate the user's continue decision.
;Parameters:
;              input, representing the user's choice.
;Return Value: A string, reprsenting the user's validated choice.
;Algorithm:
;              1) Validate the input is either "Y" or "N".
;              2) If the input is not valid, recursively ask for the user's continue decision.
;Assistance Received: None
(defun ValidateContinueDecision(input)
  (cond ( (not (or (string= input "Y") (string= input "N")))
          (princ "Invalid Continue Decision!")
          (terpri) 
          (terpri)
          (GetContinueDecision) )
        
        (t
          input)
  )
)

;Function Name: DisplayWinner
;Purpose: To determine and display the winner of the tournament.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: None
;Algorithm:
;              1) If the human has more points, the human has won the tournament.
;              2) If the computer has more points, the computer has won the tournament.
;              3) Otherwise, the tournament has ended in a draw.
;Assistance Received: None
(defun DisplayWinner (gameState)
  (terpri)

  ;The human has won the tournament.
  (cond ( (> (GetHumanScore gameState) (GetComputerScore gameState))
          (princ "The winner of the tournament is the Human player by a score of ") 
          (princ (GetHumanScore gameState))
          (princ " to ")
          (princ (GetComputerScore gameState)) 
          (princ ".") )

        ;The computer has won the tournament.
        ( (< (GetHumanScore gameState) (GetComputerScore gameState))
          (princ "The winner of the tournament is the Computer player by a score of ") 
          (princ (GetComputerScore gameState))
          (princ " to ")
          (princ (GetHumanScore gameState)) 
          (princ ".") )

        ;The tournament ended in a draw.
        (t
          (princ "The tournament has ended in a draw since the scores are tied."))
  )
  (terpri)
)

;Function Name: GetHumanScore
;Purpose: To get the Human's score from the game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: An integer, representing the Human's tournament score.
;Algorithm: None
;Assistance Received: None
(defun GetHumanScore(gameState)
  (nth 2 gameState)
)

;Function Name: GetComputerScore
;Purpose: To get the Computer's score from the game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: An integer, representing the Computer's tournament score.
;Algorithm: None
;Assistance Received: None
(defun GetComputerScore(gameState)
  (nth 4 gameState)
)

;Function Name: StartRound
;Purpose: To start and recursively play through a single round of Pente.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the game state of the completed round.
;Algorithm:
;              1) Determine the first player of the round, if it hasn't yet been determined (see DetermineFirstPlayer function).
;              2) While the round is not over:
;                2a) If it is the Human's turn, let the Human play its turn. Otherwise let the Computer play it's turn.
;                2b) Switch to the next player's turn.
;                2c) Recursively call StartRound again with the updated game state list (after a player has made their turn).
;              3) Display the points earned by each player for the round.
;              4) Update the tournament scores of each player.
;              5) Reset the game state list so it is prepared to play another round if the user chooses to.
;Assistance Received: None
(defun StartRound(gameState)  
  ;Determine who should go first, if that hasn't yet been determined.
  (cond ( (string= (GetNextPlayer gameState) "unknown")
         
          ;Re-call StartRound with the updated game list that contains the first player
          (StartRound (DetermineFirstPlayer gameState)) )
        
        (t
          (DisplayRoundInformation gameState)

          ;Continue alternating turns until the round ends either via five consecutive stones or five or more captured pairs for either player.
          (cond ( (not (RoundOver gameState))
                   ;Human's turn
                  (cond ( (string= (GetNextPlayer gameState) "Human")
                          (StartRound (SwitchPlayer (HumanTurn gameState))) )
                  
                        ;Computer's turn
                        (t
                          (StartRound (SwitchPlayer (ComputerTurn gameState))) )
                  
                  ) )

                (t
                  ;Display the points earned by the human.
                  (terpri)
                  (terpri)
                  (princ "Points earned by the Human player this round: ")
                  (princ (ScoreBoard gameState (GetHumanColor gameState)))
                  
                  ;Display the points earned by the computer.
                  (terpri)
                  (princ "Points earned by the Computer player this round: ")
                  (princ (ScoreBoard gameState (GetComputerColor gameState)))
                  (terpri)
                  (terpri)

                  ;Update the scores for both players, then reset the round in preparation of another. Scores are updated before resetting.
                  (ResetRound (UpdateScores gameState)) )
          ) )
  )
)

;Function Name: DetermineFirstPlayer
;Purpose: To determine which player goes first at the very beginning of a round.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game state list with the next player correctly set.
;Algorithm:
;              1) If the human has a higher tournament score, the human will play first.
;              2) If the computer has a higher tournament score, the computer will first.
;              3) If the tournament scores are tied, the first player is determined via coin toss.
;                3a) The human calls the coin toss.
;                3b) If the human called the coin toss correctly, they play first.
;                3c) Otherwise, the computer plays first.
;Assistance Received: None
(defun DetermineFirstPlayer(gameState)
  (let* ((humanScore (GetHumanScore gameState))
         (computerScore (GetComputerScore gameState)))
    
    ;The player with the higher score gets to go first, otherwise the first player is determined via coin toss.
    (terpri)
    (cond ( (> humanScore computerScore)
            (princ "The human player goes first because they have a higher score.") 
            (terpri) 
            (terpri)
            (SetNextPlayer gameState "Human") ) 
          
          ( (> computerScore humanScore)
            (princ "The computer player goes first because they have a higher score.") 
            (terpri) 
            (terpri)
            (SetNextPlayer gameState "Computer") )
          
          (t 
           (princ "The first player will be determined via coin toss, since the scores are tied or the tournament is just starting.") 
           (terpri) 
           (cond ( (CoinToss)
                   (princ "You will be going first because you won the coin toss.") 
                   (terpri)  
                   (terpri)
                   (SetNextPlayer gameState "Human") )
                 
                 (t
                   (princ "The computer will be going first because you lost the coin toss.") 
                   (terpri)
                   (terpri)
                   (SetNextPlayer gameState "Computer") )
           ) )
   
    )
      
  )
)

;Function Name: CoinToss
;Purpose: To simulate a coin toss.
;Parameters: None
;Return Value: A boolean, representing if the human called the coin toss correctly or not.
;Algorithm:
;              1) Randomly generate 1 or 2 to represent heads or tails.
;              2) Ask the user to call the toss.
;              3) If they called the toss correctly, return true. Otherwise return false.
;Assistance Received: https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node133.html
(defun CoinToss ()
  (let* ((coin (random 2))
         (coinTossCall (GetCoinTossCall)))
    
    ;Print the result of the coin toss.
    (terpri)
    (cond ( (= coin 0)
            (princ "The result of the coin toss was Heads! ") )
          
          (t
            (princ "The result of the coin toss was Tails! ") )
    )
    
    ;Return true if the user called the coin toss correctly, otherwise return false.
    (cond ( (or (and (string= coinTossCall "H") (= coin 0)) (and (string= coinTossCall "T") (= coin 1)))
            t )
          
          (t
            () )
    )
  )
)

;Function Name: GetCoinTossCall
;Purpose: To get the coin toss call from the user.
;Parameters: None
;Return Value: A string, representing the user's coin toss call (either "H" or "T")
;Algorithm:
;              1) Ask the user to enter their coin toss call.
;              2) Validate and return their choice.
;Assistance Received: None
(defun GetCoinTossCall()
  (princ "Enter H for heads or T for tails: ")
  (ValidateCoinTossCall (read-line))
)

;Function Name: ValidateCoinTossCall
;Purpose: To validate the user's coin toss call.
;Parameters:
;              input, a string representing the user's choice.
;Return Value: A string, representing the validated user's coin toss call.
;Algorithm:
;              1) Validate the user's choice is either "H" to represent heads or "T" to represent tails.
;              2) If the choice is not valid, recursively ask the user to enter their coin toss call.
;Assistance Received: http://www.lispworks.com/documentation/HyperSpec/Body/f_stgeq_.htm
(defun ValidateCoinTossCall(input)
  (cond ( (not (or (string= input "H") (string= input "T")))
          (princ "Invalid coin toss call!")
          (terpri) 
          (terpri)
          (GetCoinTossCall) )
        
        (t
          input)
  )
)

;Function Name: DisplayRoundInformation
;Purpose: To display everything about the current round to the screen.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: None
;Algorithm:
;              1) Display the board.
;              2) Display the human's information including their captured pair count and tournament score.
;              3) Display the computer's information including their captured pair count and tournament score.
;              4) Display the next player's information.
;Assistance Received: None
(defun DisplayRoundInformation (gameState)
  ;Display the board.
  (PrintBoard (GetBoard gameState) 0 (rowHeaders) (columnHeaders))
  
  ;Display the human's information
  (princ "Human:")
  (terpri)
  (princ "Captured Pairs: ")
  (princ (GetHumanCapturedPairs gameState))
  (terpri)
  (princ "Tournament Score: ")
  (princ (GetHumanScore gameState))
  (terpri)
  (terpri)

  ;Display the computer's information
  (princ "Computer:")
  (terpri)
  (princ "Captured Pairs: ")
  (princ (GetComputerCapturedPairs gameState))
  (terpri)
  (princ "Tournament Score: ")
  (princ (GetComputerScore gameState))
  (terpri)
  (terpri)

  ;Display the next player's information
  (princ "Next Player: ")
  (princ (GetNextPlayer gameState))
  (princ " ")

  (cond ( (eq (GetNextPlayerColor gameState) 'W)
          (princ "- White") )

        (t
          (princ "- Black") )
  )

  (terpri)
  (terpri)
)

;Function Name: RowHeaders
;Purpose: To generate a list of row headers used for display purposes.
;Parameters: None
;Return Value: A list, representing all of the row headers for the board.
;Algorithm: None
;Assistance Received: None
(defun RowHeaders ()
  (list 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1)
)

;Function Name: ColumnHeaders
;Purpose: To generate a list of column headers used for display purposes.
;Parameters: None
;Return Value: A list, representing all of the column headers for the board.
;Algorithm: None
;Assistance Received: None
(defun ColumnHeaders ()
  (list 'A 'B 'C 'D 'E 'F 'G 'H 'I 'J 'K 'L 'M 'N 'O 'P 'Q 'R 'S)
)

;Function Name: PrintBoard
;Purpose: To print the entire board onto the screen.
;Parameters:
;              board, a list representing the current board of the game.
;              index, an integer representing the current row that needs to be displayed.
;              rowHeaders, a list representing the row headers of the board.
;              columnHeaders, a list representing the column headers of the board.
;Return Value: None
;Algorithm: 
;              1) Recursively loop through each row on the board.
;              2) If the index is 0, representing nothing has been printed yet, print the column headers since they should be on the top of the board.
;              3) Attach the corresponding row header to the row list.
;              4) Print each row of the board (see PrintRow function) until all rows have been printed.
;Assistance Received: None
(defun PrintBoard (board index rowHeaders columnHeaders)
  ;Continue to print the rows until all rows are printed.
  (cond ((null board)
         (terpri) )
        
        (t 
          (cond ((= index 0)
                 (princ "   ")
                 (PrintRow columnHeaders)) 
                (t )
               ) 
  
         (PrintRow (cons (first rowHeaders) (first board)))
         (PrintBoard (rest board) (+ index 1) (rest rowHeaders) columnHeaders) ))
)

;Function Name: PrintRow
;Purpose: To print an individual row of the board on to the screen.
;Parameters:
;              row, a list representing a row of the board.
;Return Value: None
;Algorithm:
;              1) Recursively loop through each column of the row.
;              2) If the row header is less than 10, output an extra space for viewing purposes so that the board lines up correctly.
;              3) Print each element of the row until all have been printed.
;Assistance Received: None
(defun PrintRow (row)
  ;Continue to print the contents of the row until the row is an empty list.
  (cond ( (null row)
          (terpri) )
        
        (t 
          (princ (first row))
         
         ;Print an extra space for single digit row numbers for spacing purposes
         (cond ( (and (equal (numberp (first row)) t) (< (first row) 10))
                 (princ " ")) )
         
         (princ " ")
         (PrintRow (rest row)) )       
  )
)

;Function Name: GetHumanCapturedPairs
;Purpose: To get the Human captured pair count from the game state list.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: An integer, representing the Human's captured pair count.
;Algorithm: None
;Assistance Received: None
(defun GetHumanCapturedPairs (gameState)
  (nth 1 gameState)
)

;Function Name: GetComputerCapturedPairs
;Purpose: To get the Computer captured pair count from the game state list
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: An integer, representing the Computer's captured pair count.
;Algorithm: None
;Assistance Received: None
(defun GetComputerCapturedPairs (gameState)
  (nth 3 gameState)
)

;Determines if the current round is over.
;Function Name: RoundOver
;Purpose: To determine if the current round is over.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A boolean, representing if the round has ended or not.
;Algorithm:
 ;             1) Check to see if either player has achieved five consecutive stones on the board. If they have, return true.
 ;             2) Check to see if either player has achieved at least five captured pairs. If they have, return true.
 ;             3) Check to see if the board is completely full. If they have, return true.
 ;             4) Otherwise, the round is not over so return false.
;Assistance Received: None
(defun RoundOver (gameState)
  ;Check if the player with white stones has achieved five consecutive stones.
  (cond ( (CheckFiveConsecutive (GetBoard gameState) 'W (GetAllSequences 5))
          ;The human player has achieved five consecutive stones.
          (cond ( (eq (GetHumanColor gameState) 'W)
                  (princ "The round has ended because the Human player has achieved five consecutive stones.")
                  t )
                ;The computer player has achieved five consecutive stones.
                (t
                  (princ "The round has ended because the Computer player has achieved five consecutive stones.")
                  t )                
          ) )   
        ;Check if the player with black stones has achieved five consecutive stones.    
        ( (CheckFiveConsecutive (GetBoard gameState) 'B (GetAllSequences 5))
          (cond ( (eq (GetHumanColor gameState) 'B)
                  (princ "The round has ended because the Human player has achieved five consecutive stones.")
                  t )
                ;The computer player has achieved five consecutive stones.
                (t
                  (princ "The round has ended because the Computer player has achieved five consecutive stones.")
                  t )                
          ) )
          
        ;Check if the human player has captured at least five captured pairs.
        ( (>= (GetHumanCapturedPairs gameState) 5)
          (princ "The round has ended because the Human player has at least five captured pairs.")
          t )
          
        ;Check if the computer player has captured at least five captured pairs.
        ( (>= (GetComputerCapturedPairs gameState) 5)
          (princ "The round has ended because the Computer player has at least five captured pairs.")
          t )

        ;Check if the board is completely full (19 x 19 = 361).
        ( (= (StonesPlacedOnBoard gameState (AllBoardLocations 0 0)) 361)
          (princ "The round has ended because the board is full.")
          t )

        ;Otherwise, the round is not over.  
        (t
          () )    
    )
)

;Function Name: GetAllSequences
;Purpose: To get all valid sequences of locations on the board of a provided distance, in all directions.
;Parameters:
;              distance, an integer representing the length of sequences to generate.
;Return Value: A list, representing all of the possible sequences of the provided distance that are valid on the board.
;Algorithm:
;              1) Generate all of the sequences in the horizontal direction.
;              2) Generate all of the sequences in the vertical direction.
;              3) Generate all of the sequences in the main-disagonal direction.
;              4) Generate all of the sequences in the anti-diagonal direction.
;              5) Append all of the sequences and return a single list.
;Assistance Received: None
(defun GetAllSequences(distance)
	;Obtain the sequences for each major direction.
  (let* ( (horizontalSequences (GetSequencesInDirection (AllBoardLocations 0 0) 0 1 distance))
		      (verticalSequences (GetSequencesInDirection (AllBoardLocations 0 0) 1 0 distance))
		      (mainDiagonalSequences (GetSequencesInDirection (AllBoardLocations 0 0) 1 1 distance))
		      (antiDiagonalSequences (GetSequencesInDirection (AllBoardLocations 0 0) 1 -1 distance)) )
		   
	  ;Return an appended list of all valid sequences of the provided distance.
    (append horizontalSequences verticalSequences mainDiagonalSequences antiDiagonalSequences)
	)
)

;Function Name: GetSequencesInDirection
;Purpose: To get all of the possible sequences of a provided distance in a provided direction.
;Parameters:
;              boardLocations, a list representing all valid board locations on the board.
;              rowChange, an integer representing the directional change applied to each row.
;              colChange, an integer representing the directional change applied to each column.
;              distance, an integer representing the length of sequences to generate.
;Return Value: A list, representing all of the possible sequences of the provided distance in the provided direction.
;Algorithm:
;              1) Recursively loop through each board location on the board.
;              2) Generate a sequences in the provided direction starting from the current location being evaluated (see GetSequence function).
;              3) If the sequence is valid in terms of board constraints, add it to the return list.
;              4) Once all board locations have been checked, stop the recursion and return the list of sequences.
;Assistance Received: None
(defun GetSequencesInDirection(boardLocations rowChange colChange distance)
	(cond (	(null boardLocations)
			    ()	)
				
		    ;Create a sequence with the current location being evaluated as the starting position.
        (t
			    (let* ( (row (first (first boardLocations)))
				          (col (first (rest (first boardLocations))))
				          (sequence (GetSequence row col rowChange colChange distance)) )
				
				    ;If the sequence is valid, add it to the return list and continue searching the rest of the locations.
            (cond ( (ValidSequence sequence)
						        (cons sequence (GetSequencesInDirection (rest boardLocations) rowChange colChange distance)) ) 

                  ;Otherwise, don't add it to the return list and continue searching the rest of the locations.
					        (t
						        (GetSequencesInDirection (rest boardLocations) rowChange colChange distance)	)
				    )
			    )
		    )
	)
)

;Function Name: GetSequence
;Purpose: To generate a single sequence of a provided distance and direction, starting from a specified row and column. 
;Parameters:
;              startRow, and integer representing the starting row of the sequence.
;              startCol, and integer representing the starting column of the sequence.
;              rowChange, an integer representing the directional change applied to each row.
;              colChange, an integer representing the directional change applied to each column.
;              distance, an integer representing the length of sequences to generate.
;Return Value: A list, representing a single sequence with the provided restrictions.
;Algorithm:
;              1) Starting from the startRow and startCol, generate locations on the board up to five locations away (first -> sixth).
;              2) Return a slice of the sequence depending on the requested distance.
;Assistance Received: None
(defun GetSequence(startRow startCol rowChange colChange distance)
	;Generate the locations that will go into the sequence.
  (let* ( (first (list startRow startCol))
			    (second (list (+ startRow (* rowChange 1)) (+ startCol (* colChange 1))))
			    (third (list (+ startRow (* rowChange 2)) (+ startCol (* colChange 2))))
			    (fourth (list (+ startRow (* rowChange 3)) (+ startCol (* colChange 3))))
			    (fifth (list (+ startRow (* rowChange 4)) (+ startCol (* colChange 4))))
          (sixth (list (+ startRow (* rowChange 5)) (+ startCol (* colChange 5)))) )
 
		;Return the list of the locations in the sequence depending on the distance. 
    (cond ( (= distance 6)
		        (list first second third fourth fifth sixth) ) 
          ( (= distance 5)
		        (list first second third fourth fifth) ) 
		      ( (= distance 4)
		        (list first second third fourth) )
		      ( (= distance 3)
		        (list first second third) )
		      (t
		        () )
		)
	)
)

;Function Name: ValidSequence
;Purpose: To validate that a provided sequence contains all valid board locations.
;Parameters:
;              sequence, a list representing a sequence of board locations.
;Return Value: A boolean, representing whether or not the sequence is valid.
;Algorithm:
;              1) Recursively loop through each location within the sequence.
;              2) If any of the locations are not valid within constraints of the board, return false.
;              3) Otherwise, return true.
;Assistance Received: None
(defun ValidSequence (sequence)
	;If all of the locations in the sequence are valid, return true.
  (cond ((null sequence)
			t	)
 
		  (t 
				;Evaluate each location in the sequence and make sure they are valid indices. If not, return false.
        (cond ( (ValidIndices (first (first sequence)) (first (rest (first sequence))))
    					  (ValidSequence (rest sequence)) )
    				  (t 
                nil)
    			)
		  )
	)
)

;Function Name: ValidIndices
;Purpose: To validate that a provided row and column pair are valid.
;Parameters:
;              row, an integer representing a row of the board.
;              col, an integer representing a col of the board.
;Return Value: A boolean, representing whether or not the row and column are both between 0-18 inclusively. 
;Algorithm: None
;Assistance Received: None
(defun ValidIndices(row col)
	;A row/col pair is valid if both the row and col are between 0-18 inclusive.
  (cond ( (or (< row 0) (> row 18) (< col 0) (> col 18))
          nil )
    	  
        (t
        	t)
  )
)

;Function Name: CheckFiveConsecutive
;Purpose: To check if a player has achieved five consecutive stones.
;Parameters:
;              board, a list representing the current board of the game.
;              color, a character representing the color of stone being checked.
;              sequences, a list containing all valid sequences of length 5 on the board in all directions.
;Return Value: A boolean, representing whether or not a player of the provided color has achieved five consecutive stones on the board.
;Algorithm:
;              1) Recursively loop through each of the sequences of length 5 on the board.
;              2) For each sequence, count the number of stones of the player's color in that sequence (see StoneCountInSequence function).
;              3) If the number of stones is equal to 5, return true. Otherwise, return false.
;Assistance Received: None
(defun CheckFiveConsecutive (board color sequences)
    (cond ( (null sequences)
            () )
            
          ( (= (StoneCountInSequence board color (first sequences)) 5)
            t )
            
          (t 
            (CheckFiveConsecutive board color (rest sequences)) )
    )
)

;Function Name: StoneCountInSequence
;Purpose: To determine the number of placed stones of a provided color in a provided sequence of locations.
;Parameters:
;              board, a list representing the current board of the game.
;              color, a character representing the color of stone being checked.
;              sequences, a list containing a single sequence of board locations.
;Return Value: An integer, representing the number of placed stones of the provided color that are in the provided sequence of locations.
;Algorithm:
;              1) Recursively loop through each location within the provided sequence.
;              2) If there is a stone of the provided color placed at the location being evaluated, increment the return value and recursively call this function.
;              3) Once there are no more locations to search in the sequence, return the number of stones that were found.
;Assistance Received: None
(defun StoneCountInSequence (board color sequence)
    (let* ( (row (first (first sequence)))
			      (col (first (rest (first sequence)))) )
    
      (cond ( (null sequence)
              0 )
          
            ( (eq (At board row col) color)
              (+ (StoneCountInSequence board color (rest sequence)) 1) )
              
            (t
              (StoneCountInSequence board color (rest sequence)))
      )
    )
)

;Function Name: At
;Purpose: To determine what is on the board at a provided location.
;Parameters:
;              board, a list representing the current board of the game.
;              row, an integer representing a row of the board.
;              col, an integer representing a col of the board.
;Return Value: A character, representing what is on the board at the location provided.
;Algorithm: None
;Assistance Received: None
(defun At(board row col)
  (nth col (nth row board))
)

;Function Name: GetHumanColor
;Purpose: To get the Human's stone color from the gamestate based on the next player information.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: A character, representing the stone color of the Human player.
;Algorithm: None
;Assistance Received: None
(defun GetHumanColor (gameState)
  ;The color of the human player can be determined based on the next player information from the gameState. 
  (cond ( (and (string= (GetNextPlayer gameState) "Human") (eq (GetNextPlayerColor gameState) 'W))
          'W )

        ( (and (string= (GetNextPlayer gameState) "Human") (eq (GetNextPlayerColor gameState) 'B))
          'B )

        ( (and (string= (GetNextPlayer gameState) "Computer") (eq (GetNextPlayerColor gameState) 'W))
          'B )

        (t
          'W )
  )
)

;Function Name: GetComputerColor
;Purpose: To get the Computer's stone color from the gamestate based on the next player information.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: A character, representing the stone color of the Computer player.
;Algorithm: None
;Assistance Received: None
(defun GetComputerColor (gameState)
  (cond ( (and (string= (GetNextPlayer gameState) "Human") (eq (GetNextPlayerColor gameState) 'W))
          'B )

        ( (and (string= (GetNextPlayer gameState) "Human") (eq (GetNextPlayerColor gameState) 'B))
          'W )

        ( (and (string= (GetNextPlayer gameState) "Computer") (eq (GetNextPlayerColor gameState) 'W))
          'W )

        (t
          'B )
  )
)

;Function Name: StonesPlacedOnBoard
;Purpose: To count and return the total number of stones placed on the board.
;Parameters:
;              gameState, a list representing the current game state list.
;              boardLocations, a list representing all valid board locations on the board.
;Return Value: An integer, representing the total number of stones placed on the board.
;Algorithm:
;              1) Recursively loop through each of the board locations on the board.
;              2) If the location on the board is not empty, increment the return value by 1 and recursively call this function.
;              3) Once all board locations have been checked, return the total number of stones found on the board.
;Assistance Received: None
(defun StonesPlacedOnBoard (gameState boardLocations)
  (let* ( (board (GetBoard gameState))
		      (row (first (first boardLocations)))
		      (col (first (rest (first boardLocations)))) )
		 
    (cond ( (null boardLocations)
    		    0 )
    		  
    		  ( (not (eq (At board row col) '-))
    		    (+ (StonesPlacedOnBoard gameState (rest boardLocations)) 1) )
    		  
    		  (t
    		    (StonesPlacedOnBoard gameState (rest boardLocations))	)
    )
  )
)

;Function Name: HumanTurn
;Purpose: To play out the Human player's turn.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game state after the human has played through their turn.
;Algorithm:
;              1) Ask the user if they would like to place a stone, ask for help, or save and exit.
;              2) If the user wants to place a stone:
;                2a) Obtain the location the user wants to place their stone.
;                2b) Update the board with the newly placed stone.
;                2c) Clear any captured pairs and update the human's captured pair count if any occur.
;                2d) Return the updated game state.
;              3) If the user asks for help:
;                3a) Obtain the optimal play through the OptimalPlay function.
;                3b) Display the optimal play to the screen.
;                3c) Recursively call HumanTurn and continue to do so until the human player places their stone representing the end of the Human's turn.
;              4) If the user wants to save and exit:
;                4a) Save the game state into a file and terminate the program.
;Assistance Received: None
(defun HumanTurn(gameState)
  (let* ( (humanDecision (GetHumanTurnDecision)) )
                    
    ;The human wishes to place a stone
    (cond ( (= humanDecision 1)
            (let* ((board (GetBoard gameState))
                   (location (ReadLocation gameState))
                   (column (first location))
                   (row (first (rest location)))
                   (humanColor (GetHumanColor gameState))
                   ;First, place the stone in the desired location.
                   (updatedGameState (SetBoard gameState (UpdateBoard board row column humanColor))) 
                   ;Then, clear any captures that occured and update the Human's captured pair count accordingly.
                   (captureSequences (GenerateCaptureSequences row column (GenerateAllDirections)))
                   (clearedCapturesGameState (ClearCaptures updatedGameState captureSequences humanColor "Human")) )
              
              ;Print a new line, for spacing purposes.
              (terpri)
              
              ;Return the updated game state with the human's stone placed on the board any any captures cleared.
              clearedCapturesGameState   
            ) )
            
          ;The human wishes to ask for help.
          ( (= humanDecision 2)
            (let* ( (optimalPlay (OptimalPlay gameState)) 
                    (row (nth 0 optimalPlay))
                    (column (nth 1 optimalPlay)) 
                    (reasoning (nth 2 optimalPlay)) )

              ;Explain the computer's play recommendation.
              (terpri)
              (princ "The computer recommends you play your stone on ")
              (princ (ConvertNumToCharacter column))
              (princ (- 19 row))
              (princ reasoning) 
              (terpri)
              (terpri)
                
            )
            
            (HumanTurn gameState) )
                    
          ;The human wants to save an exit the game.
          (t
            (SaveTournament gameState) )
    )
  )
)

;Function Name: GetHumanTurnDecision
;Purpose: To get the Human player's turn decision.
;Parameters: None
;Return Value: An integer (1-3), representing the Human's choice.
;Algorithm:
;              1) Display the choices.
;              2) Return the validated input.
;Assistance Received: None
(defun GetHumanTurnDecision()
  (princ "It is your turn. Please choose one of these options:")
  (terpri)
  (princ "1. Place a tile.")
  (terpri)
  (princ "2. Ask for help.")
  (terpri)
  (princ "3. Save and exit.")
  (terpri)
  (terpri)
  
  (princ "Enter your choice (1-3): ")
  (ValidateHumanTurnDecision (read-line))
)

;Function Name: ValidateHumanTurnDecision
;Purpose: To validate the Human player's turn decision.
;Parameters:
;              input, a string representing the user's choice.
;Return Value: An integer, representing the validated input.
;Algorithm:
;              1) Convert the input into an integer.
;              2) Validate the input is between 1-3 inclusively.
;              3) If the input is not valid, recursively ask for the Human's turn decision.
;Assistance Received: None
(defun ValidateHumanTurnDecision(input)
  (let* ((numInput (parse-integer input :junk-allowed t)))
    
    (cond ( (or (null numInput) (< numInput 1) (> numInput 3))
            (princ "Invalid human turn decision!")
            (terpri)
            (terpri)
            (GetHumanTurnDecision))
        (t
          numInput)
    )
    
  )
)

;Function Name: ReadLocation
;Purpose: To obtain a location to place a stone, from the user.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the location. The list is in the format (column, row). Ex: (10 10).
;Algorithm:
;              1) Ask the user to enter a location on the board.
;              2) Return the validated input.
;Assistance Received: https://www.tutorialspoint.com/lisp/lisp_input_output.htm
(defun ReadLocation(gameState)
  (princ "Enter a location (ex: J10): ")
  (ValidateLocation (read-line) gameState)
)

;Function Name: ValidateLocation
;Purpose: To validate that the location entered by the user is sufficient. 
;Parameters:
;              location, a string reprsenting the location the user wishes to place their stone. Ex: "J10".
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the location. The list is in the format (column, row), where both the column and row are integers.
;Algorithm:
;              1) First, parse the location passed into a list containing the column and row.
;              2) Attempt to convert the parsed row and column into their integer representations. If they cannot be converted, recursively call ReadLocation.
;              3) If the row or column is not between 0-19 inclusively, recursively call ReadLocation.
;              4) If there are 0 stones placed on the board, and the location is not J10, recursively call ReadLocation since the first play must be on J10.
;              5) If there are 2 stones placed on the board, the handicap is active, so the play must be at least three intersections away from the center of the board (J10).
;                 If the play does not satisfy the handicap, recursively call ReadLocation and get a new location from the user.
;              6) If the location already has a stone placed there, the location invalid, recursively call ReadLocation to get a new location.
;              7) Otherwise, the location is valid. Return the location as a list containing the column and row. Ex: (4 12).
;Assistance Received: https://stackoverflow.com/questions/10989313/how-can-i-convert-a-string-to-integer-in-common-lisp
(defun ValidateLocation(location gameState)
  (let* ( (board (GetBoard gameState))
          (parsedInput (ParseLocation location)) )
    
    ;In case the location was not parsable, ask the user again. This ensures the program doesn't crash.
    (cond ( (null parsedInput)
            (princ "Invalid location! ")
            (ReadLocation gameState) )

          (t
            (let* ( (row (parse-integer (first (rest parsedInput)) :junk-allowed t))
                    (col (ConvertCharacterToNum (first parsedInput))) )

              (cond  ( (null row)
                        (princ "Rows must be numerical! ")
                        (ReadLocation gameState) )

                      ;Rows and columns must be between 0-19 inclusively. 
                      ( (or (> row 19) (< row 0))
                        (princ "Invalid row! Rows must be from 0-19! ")
                        (ReadLocation gameState) )
                    
                      ( (or (> col 19) (< col 0))
                        (princ "Invalid column! Columns must be from A-S! ")
                        (ReadLocation gameState) )
                    
                      ;First stone must be placed on J10 if going first.
                      ( (= (StonesPlacedOnBoard gameState (AllBoardLocations 0 0)) 0)
                        (cond ( (and (= row 10) (= col 9))
                                (list col (- 19 row)) )

                              (t
                                (princ "The first stone of the game must be placed on J10! ")
                                (ReadLocation gameState) ) 
                        ) )
                      
                      ;Second stone of the player that went first must be at least 3 intersections away from the center (J10).
                      ;It is invalid if G < col < M AND 7 < row < 13
                      ( (= (StonesPlacedOnBoard gameState (AllBoardLocations 0 0)) 2)
                        (cond ( (and (and (> col 6) (< col 12)) (and (> row 7) (< row 13)))
                                (princ "You must place your stone at least three intersections from the center on this turn! ")
                                (ReadLocation gameState) ) 
                              
                              (t
                                (list col (- 19 row)) )
                        ) )

                      ;The location needs to be empty, there can't be a stone already there.
                      ( (not (eq (At board (- 19 row) col) '-))
                        (princ "Location is not empty! ")
                        (ReadLocation gameState) ) 
                    
                      ;If the location passes all checks, it is valid. (- 19 row) represents the list index of the row (since rows go from bottom to top on the board).
                      (t 
                        (list col (- 19 row)) )
              )
            ) )
    )
  )
)

;Function Name: ParseLocation
;Purpose: To parse a location string into its column and row.
;Parameters:
;              location, a string representing a location on the board (Ex: J10).
;Return Value: A list, representing the split up column and row (Ex: (J, 10)).
;Algorithm: None
;Assistance Received: https://www.tutorialspoint.com/lisp/lisp_sequences.htm
(defun ParseLocation(location)
  ;In case the user enters an empty string by mistake.
  (cond ( (string= location "") 
          () )

        ;Split the read in string into its column and row. Ex: J10 --> (J, 10)
        (t
          (list (subseq location 0 1) (subseq location 1)) )
  )
)

;Function Name: ConvertCharacterToNum
;Purpose: To convert a character (representing a column) into its numerical board representation.
;Parameters:
;              character, a character representing the character to be converted.
;Return Value: An integer, representing the converted character to its numerical representation (Ex: C --> 2).
;Algorithm: None
;Assistance Received: http://www.lispworks.com/documentation/lw70/CLHS/Body/f_char_c.htm
;                     http://clhs.lisp.se/Body/f_coerce.htm
(defun ConvertCharacterToNum(character)
  (- (char-code (coerce character 'character)) 65)
)

;Function Name: UpdateBoard
;Purpose: To update a location on the baord with a provided symbol.
;Parameters:
;              board, a list representing the current board of the game.
;              rowIndex, an integer representing the index of row that needs to be updated.
;              columnIndex, an integer representing the index of the column that needs to be updated.
;              symbol, a character representing the symbol to update the column to.
;Return Value: A list, representing the updated board with the inserted symbol at the requested location.
;Algorithm:
;              1) If the rowIndex is 0, that means that we are at the correct row to be updated. 
;                1a) Update the column (see UpdateColumn function)
;                1b) Return a list from this row to the end of the rows.  
;              2) Otherwise, add the current row to the result board list, and recursively call this function with one subtracted from the row index.
;Assistance Received: None
(defun UpdateBoard (board rowIndex columnIndex symbol)
  ;If the rowIndex is equal to 0, we are at the correct row that needs to be updated.
  (cond ( (= rowIndex 0)
          (cons (UpdateColumn (first board) columnIndex symbol) (rest board)))
        
        (t
          (cons (first board) (UpdateBoard (rest board) (- rowIndex 1) columnIndex symbol)) )      
  )  
)

;Function Name: UpdateColumn
;Purpose: To update the column of a provided row on the board with a provided symbol.
;Parameters:
;              row, a list representing a row of the board.
;              columnIndex, an integer representing the index of the column that needs to be updated.
;              symbol, a character representing the symbol to update the column to.
;Return Value: A list, representing a row with the newly inserted symbol at the requested column.
;Algorithm:
;              1) If the columnIndex is 0, that means that we are at the correct column to be updated. 
;                1a) Insert the symbol.
;                2a) Return a list from this index to the end of the row.
;              2) Otherwise, add the current column to the result row list, and recursively call this function with one subtracted from the column index.
;Assistance Received: None
(defun UpdateColumn (row columnIndex symbol)
  ;If the columnIndex is equal to 0, we are at the correct column to update.
  (cond ( (= columnIndex 0)
          (cons symbol (rest row)))
        
        (t
          (cons (first row) (UpdateColumn (rest row) (- columnIndex 1) symbol)) )         
  )
)

;Function Name: GenerateAllDirections
;Purpose: To generate a list of all eight possible directions on the board in the form of (rowChange, colChange).
;Parameters: None
;Return Value: A list, representing all eight possible directions.
;Algorithm: None
;Assistance Received: None
(defun GenerateAllDirections()
  '((0 1) (0 -1) (1 0) (-1 0) (1 1) (-1 -1) (1 -1) (-1 1))
)

;Function Name: GenerateCaptureSequences
;Purpose: To generate all capture sequences that need to be checked, based on a provided location.
;Parameters: 
;              row, an integer representing a row of the board.
;              col, an integer representing a col of the board.
;              directions, a list representing all eight possible directions to search for.
;Return Value: A list, representing all of the sequences of locations that need to be checked if a capture occurred.
;Algorithm:
;              1) Recursively loop through each direction that needs to be searched.
;              2) For each direction, generate a sequence containing three locations away in the current direction.
;              3) If the sequence is valid in terms of board constraints, add it to the return list and recursively call this function.
;              4) Otherwise, ignore the invalid sequence and continue searching the rest of the directions with recursion.
;Assistance Received: None
(defun GenerateCaptureSequences (row col directions)
  (cond ( (null directions)
          () )
          
        (t
          (let* ( (rowChange (first (first directions))) 
                  (colChange (first (rest (first directions))))
                  ;Only need to consider the three locations away from the current location being evaluated. Ex: * W W B where * is being evaluated.
                  (captureSequence (rest (GetSequence row col rowChange colChange 4))) )
                  
            ;If the capture sequence is valid within board constraints, add it to the return list.
            (cond ( (ValidSequence captureSequence) 
                    (cons captureSequence (GenerateCaptureSequences row col (rest directions))) )
                
                  ;Otherwise ignore it and continue cycling through the rest of the directions.
                  (t
                    (GenerateCaptureSequences row col (rest directions)))
            )
          ) )
  )
)

;Function Name: ClearCaptures
;Purpose: To clear captured pairs off the board and update the player's captured pair count accordingly.
;Parameters:
;              gameState, a list representing the current state of the game.
;              captureSequences, a list reprsenting all of the possible capture sequences that need to be checked after a player has placed a stone.
;              color, a character representing the current player's stone color.
;              player, a string representing the name of the current player (either "Human" or "Computer").
;Return Value: A list, representing the updated game list with the captured pairs removed and player's captured pair count updated.
;Algorithm:
;              1) Recursively loop through each capture sequence in captureSequences.
;              2) For each capture sequence, extract and store the three locations within the capture sequence that needs to be evaluated.
;              3) If the three locations contain stones in the pattern: O O P where O represents the opponent's stones and P represents the player's stone:
;                3a) Remove the first and second stones in the sequence, and store this game state.
;                3b) If the player parameter is "Human", increment the Human's captured pair count by 1. Otherwise, increment the Computer's captured pair count.
;                3c) Recursively call this function with the updated game state to check the rest of the capture sequences (multiple captures can happen at one time).
;              4) Otherwise, continue checking the rest of the sequences through recursively calling this function.
;Assistance Received: None
(defun ClearCaptures (gameState captureSequences color player)
  ;Once all capture sequences have been checked, return the gamestate.
  (cond ( (null captureSequences) 
          gameState  )
      
        ;Otherwise, continue checking each sequence for a potential capture.
        (t
          (let* ( (board (GetBoard gameState))
                  (opponentColor (GetOpponentColor color))
                  (currentSequence (first captureSequences)) 
                  (firstLoc (first currentSequence))
                  (firstRow (first firstLoc))
                  (firstCol (first (rest firstLoc)))
                  (secondLoc (first (rest currentSequence)))
                  (secondRow (first secondLoc))
                  (secondCol (first (rest secondLoc)))
                  (thirdLoc (first (rest (rest currentSequence))))
                  (thirdRow (first thirdLoc))
                  (thirdCol (first (rest thirdLoc))) )
              
            ;If the stones are in the pattern O O P, where the O represents the opponent's stone and P represents the player's stone, a capture can be made.
            ;The O O P formation would be one of the sequences generated by the GenerateCaptureSequences function.
            (cond ( (and (eq (At board firstRow firstCol) opponentColor) 
                          (eq (At board secondRow secondCol) opponentColor) 
                          (eq (At board thirdRow thirdCol) color))
                    
                    ;Remove the first and second stones in the sequence, if they are being captured.
                    (let* ( (removedFirstStoneState (SetBoard gameState (UpdateBoard board firstRow firstCol '-)))
                            (removedSecondStoneState (SetBoard removedFirstStoneState (UpdateBoard (GetBoard removedFirstStoneState) secondRow secondCol '-))) )
                        
                        ;If the player was the Human player, update the Human's captured pair count by 1.
                        ;Otherwise, update the Computer's captured pair count by 1. 
                        ;Then, recursively call the ClearCaptures function with the updated gameState.
                        (cond ( (string= player "Human") 
                                (let* ( (currentCapturedPairs (GetHumanCapturedPairs removedSecondStoneState))
                                        (updatedCapturedPairs (+ currentCapturedPairs 1))
                                        (updatedCaptureState (SetHumanCapturedPairs removedSecondStoneState updatedCapturedPairs)) )
                                        
                                    (ClearCaptures updatedCaptureState (rest captureSequences) color player)
                                ) )
                                  
                              (t
                                (let* ( (currentCapturedPairs (GetComputerCapturedPairs removedSecondStoneState))
                                        (updatedCapturedPairs (+ currentCapturedPairs 1))
                                        (updatedCaptureState (SetComputerCapturedPairs removedSecondStoneState updatedCapturedPairs)) )
                                        
                                    (ClearCaptures updatedCaptureState (rest captureSequences) color player)
                                ) )
                        )
                    ) )
                
                  ;If no captures were found in the current captureSequence, continue searching the rest of the capture sequences.    
                  (t
                    (ClearCaptures gameState (rest captureSequences) color player) )
              )
          ) )
  )
)

;Simply returns the color of the opponent. Used for determining if a capture has occurred.
;Function Name: GetOpponentColor
;Purpose: To get the stone color of the opponent.
;Parameters:
;              playerColor, a character representing the stone color of the current player.
;Return Value: A character, representing the stone color of the opponent.
;Algorithm: None
;Assistance Received: None
(defun GetOpponentColor (playerColor)
  (cond ( (eq playerColor 'W) 
          'B )
          
        (t
          'W)
  )
)

;Function Name: SetHumanCapturedPairs
;Purpose: To set the Human's captured pair count into the game list.
;Parameters:
;              gameState, a list representing the current state of the game.
;              humanCapturedPairs, an integer representing the Human's captured pair count.
;Return Value: A list, representing the updated game list with the new Human captured pair count.
;Algorithm: None
;Assistance Received: None
(defun SetHumanCapturedPairs(gameState humanCapturedPairs)
  (cond ( (< humanCapturedPairs 0) 
          (princ "Invalid human captured pair count!")
          gameState )

        (t
          (list (nth 0 gameState)
          humanCapturedPairs
          (nth 2 gameState)
          (nth 3 gameState)
          (nth 4 gameState)
          (nth 5 gameState)
          (nth 6 gameState) ) )
  )
)

;Function Name: SetComputerCapturedPairs
;Purpose: To set the Computer's captured pair count into the game list. 
;Parameters:
;              gameState, a list representing the current state of the game.
;              computerCapturedPairs, an integer representing the Computer's captured pair count.
;Return Value: A list, representing the updated game list with the new Computer captured pair count.
;Algorithm: None
;Assistance Received: None
(defun SetComputerCapturedPairs(gameState computerCapturedPairs)
  (cond ( (< computerCapturedPairs 0)
          (princ "Invalid computer captured pair count!")
          gameState )

        (t
          (list (nth 0 gameState)
          (nth 1 gameState)
          (nth 2 gameState)
          computerCapturedPairs
          (nth 4 gameState)
          (nth 5 gameState)
          (nth 6 gameState) ) )
  )
)

;Function Name: ConvertNumToCharacter
;Purpose: To convert a number (representing a column) into its character representation. 
;Parameters:
;              number, an integer representing the number to be converted.
;Return Value: A character, representing the character representation of the number passed (Ex: 0 --> A). 
;Algorithm: None
;Assistance Received: http://clhs.lisp.se/Body/f_code_c.htm
(defun ConvertNumToCharacter(number)
  (code-char (+ number 65))
)

;Function Name: SaveTournament
;Purpose: To save the tournament to a file.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: None - The program is terminated after this function completes.
;Algorithm:
;              1) Obtain the file name the user wishes to save to.
;              2) Attempt to open the file (creates a file if it does not exist, and overwrites a file if it already exists).
;              3) If the file cannot be opened (ex: invalid file name), recursively call this function and ask the user for a new file name.
;              4) If the file could be opened, correctly format the game state list (see FixSaveState function) and write it to the file.
;              5) Close the file.
;              6) Terminate the program.
;Assistance Received: https://stackoverflow.com/questions/38507228/lisp-write-a-list-to-file
;                     https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node338.html
(defun SaveTournament(gameState)
  ;Handler-case acts as a try-catch block. Attempt to open the file requested.
  (handler-case
    ;Open the requested file. If it doesn't exit, create it, and if it does already exist overwrite it.
    (let* ( (fileName (GetSaveFileName)) 
            (out (open fileName :direction :output :if-exists :supersede :if-does-not-exist :create )) )

      ;Write the correctly fixed game state to the file.
      (princ (FixSaveState gameState) out)

      ;Close the file
      (close out)

      ;Exit the program.
      (exit)
    )
  ;If opening the file causes an error, ask the user for a new file name.  
  (error (c)
    (princ "Invalid file name! ")
    (SaveTournament gameState)
  ) )
  
  
)

;Function Name: GetSaveFileName
;Purpose: To get the name of the file the user wishes to save the tournament to.
;Parameters: None
;Return Value: A string, representing the name of the file.
;Algorithm: None
;Assistance Received: None
(defun GetSaveFileName()
  (princ "Enter the name of the file to save the tournament to (ex: file.txt): ")
  (read-line)
)

;Function Name: FixSaveState
;Purpose: To correctly format the game state list before writing it to a file.
;Parameters:
;              gameState, a list representing the game state list that will be written to a file.
;Return Value: A list, representing the correctly formatted game state list.
;Algorithm:
;              1) Fix the board by setting the empty cells to "O".
;              2) Fix the next player value from a string representation to a symbolic representation.
;              3) Fix the next player color's value from a character to a symbolic representation (ex: W --> White).
;Assistance Received: None
(defun FixSaveState (gameState)
  (let* ( (fixedBoard (SetEmpties gameState (AllBoardLocations 0 0) '- 'O)) 
          (fixedNextPlayer (FixNextPlayer fixedBoard)) 
          (fixedNextPlayerColor (FixNextPlayerColor fixedNextPlayer)) )
    fixedNextPlayerColor
  )
)

;Function Name: SwitchPlayer
;Purpose: To switch to the next player of the round.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: A list, representing, the updated game state list with the next player successfully updated (Ex: "Human" --> "Computer").
;Algorithm: None
;Assistance Received: None
(defun SwitchPlayer (gameState)
  (cond ( (string= (GetNextPlayer gameState) "Human")
          (SwitchColor (SetNextPlayer gameState "Computer")) )
        
        (t
          (SwitchColor (SetNextPlayer gameState "Human")) )
  )
)

;Function Name: SwitchColor
;Purpose: To switch the next player color of the round.
;Parameters:
;              gameState, a list representing the current state of the game.
;Return Value: A list, representing the updated game state list with the next player color successfully updated (Ex: W --> B).
;Algorithm: None
;Assistance Received: None
(defun SwitchColor (gameState)
  (cond ( (eq (GetNextPlayerColor gameState) 'W)
          (SetNextPlayerColor gameState 'B) )
        
        (t
          (SetNextPlayerColor gameState 'W) )
  )
)

;Function Name: ComputerTurn
;Purpose: To play out the Computer player's turn.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game state after the computer has played through its turn.
;Algorithm:
;              1) Ask the user if they would like the computer to place its stone, or save and exit.
;              2) If the user wants the comptuer to place its stone:
;                2a) Obtain the optimal play through the OptimalPlay function.
;                2b) Update the board with the newly placed stone at this location.
;                2c) Clear any captured pairs and update the computer's captured pair count if any occur.
;                2d) Display the computer's reasoning for placing its stone where it did.
;              3) If the user wants to save and exit:
;                3a) Save the game state into a file and terminate the program.
;Assistance Received: None
(defun ComputerTurn (gameState)
  (let* ((computerDecision (GetComputerTurnDecision)))           
    ;The user wants the computer to place a stone.
    (cond ( (= computerDecision 1)
            (let* ((optimalPlay (OptimalPlay gameState))
                    (board (GetBoard gameState))
                    (row (nth 0 optimalPlay))
                    (column (nth 1 optimalPlay))
                    (computerColor (GetComputerColor gameState))
                    (reasoning (nth 2 optimalPlay))
                    ;First, place the stone in the optimal location.
                    (updatedGameState (SetBoard gameState (UpdateBoard board row column computerColor)))
                    ;Then, clear any captures that occurred and update the Computer's captured pair count accordingly.
                    (captureSequences (GenerateCaptureSequences row column (GenerateAllDirections)))
                    (clearedCapturesGameState (ClearCaptures updatedGameState captureSequences computerColor "Computer")) )
              
              ;Explain the computer's play
              (terpri)
              (princ "The computer played its stone on ")
              (princ (ConvertNumToCharacter column))
              (princ (- 19 row))
              (princ reasoning) 
              (terpri)
              (terpri)
              
              ;Return the updated game state after the computer player has made its move and any captures has been cleared.
              clearedCapturesGameState   
            ) )
            
          ;The users wants to save an exit the tournament.
          (t
            (SaveTournament gameState) )
    )
  )
)

;Function Name: GetComputerTurnDecision
;Purpose: To get the Computer player's turn decision.
;Parameters: None
;Return Value: An integer (1 or 2), representing the user's choice on what the computer should do.
;Algorithm:
;              1) Display the choices.
;              2) Return the validated input
;Assistance Received: None
(defun GetComputerTurnDecision()
  (princ "It is the computer's turn. Please choose one of these options:")
  (terpri)
  (princ "1. Let the computer place a tile.")
  (terpri)
  (princ "2. Save and exit.")
  (terpri)
  (terpri)
  
  (princ "Enter your choice (1 or 2): ")
  (ValidateComputerTurnDecision (read-line))
)

;Function Name: ValidateComputerTurnDecision
;Purpose: To validate the Computer player's turn decision.
;Parameters:
;              input, a string representing the user's choice.
;Return Value: An integer, representing the validated input.
;Algorithm:
;              1) Convert the input into an integer.
;              2) Validate the input is either 1 or 2.
;              3) If the input is not valid, recursively ask the user for the Computer's turn decision.
;Assistance Received: None
(defun ValidateComputerTurnDecision(input)
  (let* ((numInput (parse-integer input :junk-allowed t)))
    
    (cond ( (or (null numInput) (< numInput 1) (> numInput 2))
            (princ "Invalid computer turn decision!")
            (terpri)
            (terpri)
            (GetComputerTurnDecision) )
        (t
          numInput )
    )
    
  )
)

;Function Name: OptimalPlay
;Purpose: To determine the most optimal location to place a stone.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the optimal play location and reasoning in the format: (row col reasoning)
;Algorithm: Several functions are used to determine the most optimal play. See individual function documentation for more information. The priorities are listed below:
;              1) If there are no stones placed on the board (the board is empty), the only possible move is the center of the board, or J10.
;              2) If it is the second turn of the player that went first, the optimal play generated must be at least three intersections away from the center (J10).
;                 The location returned will be at least three intersections away from the center (ex: W - - * -).
;              3) If it is possible to win the round with the player's next move, either by five consecutive stones or by capture, the location that results in a win is returned.
;                3a) If it's possible to delay the win to earn additional points, the win will be delayed (see MakeWinningMove function for details on delaying the win).
;              4) If the opponent is about to win the round, either by five consecutive stones or by capture, prevent it.
;              5) If it's possible to build a deadly tessera (ex: - W W W W -), build one.
;              6) If it's possible to block the opponent from building a deadly tessera, block it.
;              7) If the player can make a capture, make the move that results in the most captured pairs.
;			        8) If the opponent can make a capture on their following turn, make the move that prevents the most captured pairs.
;			        9) If the player can build initiative with three of their stones already placed, do it.
;                9a) Prioritize building four consecutive stones. If it isn't possible, return the location that results in three consecutive stones.  
;              10) If the opponent can build initiative with three of their stones already placed on their following turn, block it.
;              11) If the player can build initiative with two of their stones already placed, do it.
;                11a) Prioritize building three consecutive stones. If it isn't possible, return the location that results in the least amount of consecutive stones (ex: W - * - W).
;              12) If the opponent has placed two consecutive stones that can be captured, initiate a flank.
;              13) If the player can build initiative with one of their stones already placed, do it.
;                13a) The location returned is two locations away from where the stone is placed (ex: W - * - -).
;              14) If the opponent can build initiative with one of their stones already placed on their following turn, block it.
;                14a) This also is used to begin a player's initiative when they do not have any stones placed on the board.
;              15) As a fail-safe, return any random empty location on the board. This is only used when the board is nearly full and none of the above moves apply.

;Assistance Received: None
(defun OptimalPlay (gameState)
  (let* ( (board (GetBoard gameState))
          (color (GetNextPlayerColor gameState))
          (opponentColor (GetOpponentColor color))
          ;Winning plays.
          (winningPlay (MakeWinningMove gameState color t))
          (preventWinningPlay (PreventWinningMove gameState color))
          ;Capture plays.
          (capturePlay (MakeCapture board color))
          (preventCapturePlay (PreventCapture board color))
          ;Deadly tessera plays.
          (makeDeadlyTessera (FindDeadlyTessera board (SearchForSequences board (GetAllSequences 6) 3 3 color) color ()))
          (preventDeadlyTessera (FindDeadlyTessera board (SearchForSequences board (GetAllSequences 6) 3 3 opponentColor) color ()))
          ;Offensive Plays
          (buildInitiative_3 (BuildInitiative board 3 color color))
          (buildInitiative_2 (BuildInitiative board 2 color color))
          (buildInitiative_1 (BuildInitiative board 1 color color))
          ;Defensive Plays
          (counterInitiative_3 (CounterInitiative board 3 color))
          (counterInitiative_2 (CounterInitiative board 2 color))
          (counterInitiative_1 (CounterInitiative board 1 color))
          ;Fail-safe random move if none of the above strategies are valid (should never be used).
          (randomRow (random 19))
          (randomCol (random 19)) )

    ;The first stone of the game must be played on J10.
    (cond ( (= (StonesPlacedOnBoard gameState (AllBoardLocations 0 0)) 0)
            (list 9 9 " because the first stone of the game must be played here.") )

          ;If it is the second turn of the first player, the handicap is active.
          ( (= (StonesPlacedOnBoard gameState (AllBoardLocations 0 0)) 2)
            (let* ( (sequences (SearchForSequences board (GetAllSequences 5) 1 4 color))
                    (possibleHandicapPlays (FindHandicapPlay board sequences))
                    (pickedPlay (nth (random (length possibleHandicapPlays)) possibleHandicapPlays)) 
                    (row (first pickedPlay))
                    (col (first (rest pickedPlay))) )

              (list row col " to play optimally within the handicap.")
            ) )

          ;Attempt to win the round, if possible (either via 5 consecutive stones or via 5 capturing).
          ;Note: winningPlay is in the format: ((row col) reasoning))
          ( (> (length winningPlay) 0)
            (list (first (first winningPlay)) (first (rest (first winningPlay))) (first (rest winningPlay))) )

          ;Attempt to prevent the opponent from winning the round, if possible (either via 5 consecutive stones or via 5 capturing).
          ;Note: preventWinningPlay is in the format: ((row col) reasoning))
          ( (> (length preventWinningPlay) 0)
            (list (first (first preventWinningPlay)) (first (rest (first preventWinningPlay))) (first (rest preventWinningPlay))) )

          ;Attempt to build a deadly tessera, if possible.
          ( (> (length makeDeadlyTessera) 0)
            (list (first makeDeadlyTessera) (first (rest makeDeadlyTessera)) " to build a deadly tessera.") )

          ;Attempt to prevent a deadly tessera, if possible.
          ( (> (length preventDeadlyTessera) 0)
            (list (first preventDeadlyTessera) (first (rest preventDeadlyTessera)) " to prevent the opponent from building a deadly tessera.") )

          ;Attempt to make a capture, if possible. Prioritizes the most captures in a single move.
          ( (> (length capturePlay) 0)
            (list (first (first capturePlay)) (first (rest (first capturePlay))) " to capture the opponent's stones.") )

          ;Attempt to prevent a capture, if possible. Prioritizes the most captures blocked in a single move.
          ( (> (length preventCapturePlay) 0)
            (list (first (first preventCapturePlay)) (first (rest (first preventCapturePlay))) " to prevent the opponent from making a capture.") )

          ;Attempt to build initiative with 3 stones already placed.
          ( (> (length buildInitiative_3) 0) 
            (list (first buildInitiative_3) (first (rest buildInitiative_3)) " to build initiative and have four stones in an open five consecutive locations.") )

          ;Attempt to counter initiative with 3 of the opponent's stones already placed.
          ( (> (length counterInitiative_3) 0) 
            (list (first counterInitiative_3) (first (rest counterInitiative_3)) " to counter initiative and prevent the opponent from getting four stones in an open five consecutive locations.") )

          ;Attempt to build initiative with 2 stones already placed.
          ( (> (length buildInitiative_2) 0) 
            (list (first buildInitiative_2) (first (rest buildInitiative_2)) " to build initiative and have three stones in an open five consecutive locations.") )

          ;Attempt to initiate a flank.
          ( (> (length counterInitiative_2) 0) 
            (list (first counterInitiative_2) (first (rest counterInitiative_2)) " to initiate a flank.") )
          
          ;Attempt to build initiative with 1 stones already placed.
          ( (> (length buildInitiative_1) 0) 
            (list (first buildInitiative_1) (first (rest buildInitiative_1)) " to build initiative and have two stones in an open five consecutive locations.") )

          ;Attempt to counter initiative with 1 of the opponent's stones already placed.
          ;This is also used to begin building initiative if there are no stone's of the current player on the board yet.
          ( (> (length counterInitiative_1) 0) 
            (list (first counterInitiative_1) (first (rest counterInitiative_1)) " to counter the opponent's initiative and begin building initiative.") )

          ;Fail-safe if none of the above strategies apply (should never happen).
          ( (not (eq (At board randomRow randomCol) '-))
            (OptimalPlay gameState) )
          
          (t
            (list randomRow randomCol " because there are no other optimal plays.") )
    )
  )
)

;Function Name: MakeWinningMove
;Purpose: To find a move, if any exist, the results in the player winning the round.
;Parameters:
;              gameState, a list representing the current game state list.
;              color, a character representing the stone color of the player calling this function.
;              checkDelay, a boolean representing if it should be checked if the win can be delayed (only true when the player calling this is on offense)
;Return Value: A list, containing the row and column of the location that results in the player winning the round, and the reasoning of how they won. Ex: (row col reasoning).
;Algorithm:
;              1) First, check if it is possible to make five consecutive stones on the board.
;              2) If there are multiple locations that would result in five conscecutive stones on the board AND checkDelay is true:
;                2a) If the player is not at risk of being captured on their following turn, and they can capture the opponent's stones, opt to make the capture and delay the win.
;                2b) Otherwise, just return a location that results in five consecutive stones to win the round.
;              3) If there is only one location that results in five consecutive stones, return this location.
;              4) If there are no locations that result in five consecutive stones, check if the player can win by achieving five captured pairs.
;              5) If it's possible to win via capture, return this location. Otherwise, return an empty list.
;Assistance Received: None
(defun MakeWinningMove (gameState color checkDelay)
	;A possible winning sequence consists of four stones of the provided color and 1 empty location.
	(let* ( (board (GetBoard gameState)) 
			    (fiveConsecutive (SearchForSequences board (GetAllSequences 5) 4 1 color)) )
		
		;First check if it is possible to get five consecutive stones.
		(cond ( (> (length fiveConsecutive) 0) 
      
      ;If the player is on offense, check if it is possible to delay the win and earn additional points.
      (cond ( (and checkDelay (>= (length fiveConsecutive) 2))
              ;If there are more than two locations on the board that results in five consecutive stones, the player is not at risk of 
              ;being captured, and the player can make a capture, delay the win to score more points.
              (cond ( (and (> (length (MakeCapture (GetBoard gameState) color)) 0) (= (length (MakeCapture (GetBoard gameState) (GetOpponentColor color))) 0))
                      (list (first (MakeCapture (GetBoard gameState) color)) " to delay the win and score additional points via capture.") )

                    ;It isn't possible to delay the win.
                    (t
                      ;Find the empty index of the sequence, and return this location.
                      (let* ( (winningSequence (first fiveConsecutive))
                              (emptyIndex (first (FindEmptyIndices board winningSequence 0))) 
                              (returnLocation (nth emptyIndex winningSequence)) )
                        
                        (list returnLocation " to win by getting five consecutive stones.")
                      ) )
              ) )

            ;If the player isn't on offense, or if there is only one location that allows the player to make five consecutive stones, return this location.
            (t
              ;Find the empty index of the sequence, and return this location.
              (let* ( (winningSequence (first fiveConsecutive))
                      (emptyIndex (first (FindEmptyIndices board winningSequence 0))) 
                      (returnLocation (nth emptyIndex winningSequence)) )
                
                (list returnLocation " to win by getting five consecutive stones.")
              ) )  
      ) )
			
			;Next check if it's possible to win via capture.
			(t
				(let* ( (potentialCapture (MakeCapture (GetBoard gameState) color))
						    (humanCaptureCount (GetHumanCapturedPairs gameState))
						    (computerCaptureCount (GetComputerCapturedPairs gameState)) )
					
					(cond ( (> (length potentialCapture) 0)
							
                  ;If the number of captures makes the player get >= 5 captured pairs, return this move.
                  ;First, check if it is the human's turn to get the correct number of captures.
                  (cond ( (and (eq (GetHumanColor gameState) color) (>= (+ humanCaptureCount (first (rest potentialCapture))) 5 ))
                          (list (first potentialCapture) " to win by having at least five captured pairs.") )

                        ;Next, check if it is the computer's turn to get the correct number of captures.
                        ( (and (eq (GetComputerColor gameState) color) (>= (+ computerCaptureCount (first (rest potentialCapture))) 5 ))
                          (list (first potentialCapture) " to win by having at least five captured pairs.") )

                        (t
                          () )
                  ) )
						
						  ;There are no possible winning moves.	
						  (t
							  () )
					)
				
				) )
	  )
	)
)

;Function Name: SearchForSequences
;Purpose: To search for sequences that have a specific number of stones already placed and a specific number of empty locations. Used for determining optimal plays.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list representing all of the sequences of locations that needs to be searched.
;              stoneCount, an integer representing how many placed stones to search for within each sequence.
;              emptyCount, an integer representing how many empty locations to search for within each sequence.
;              color, a character representing the color of stone that is being searched for.
;Return Value: A list, representing all of the sequences of locations that match the search parameters.
;Algorithm:
;              1) Recursively search through all of the sequences passed to this function.
;              2) For each sequence, determine the number of stone placed as well as the number of empty locations within the sequence.
;              3) If the number of stones placed and empty locations matches the parameters passed to this function, add the sequence to the return list.
;              4) Once all sequences have been searched, return the list of found sequences if any exist.
;Assistance Received: None
(defun SearchForSequences (board sequences stoneCount emptyCount color)
  (cond ( (null sequences)
          () )
        
        (t
          ;Determine the number of stones placed, as well as the number of empty locations in the current sequence being evaluated.
          (let* ( (currentSequence (first sequences)) 
                  (numStones (StoneCountInSequence board color currentSequence))
                  (numEmpty (length (FindEmptyIndices board currentSequence 0))) )

            ;If the number of stones in the sequence and number of empty locations in the sequence is equal to the search parameters, add this sequence to the returned list.      
            (cond ( (and (= numStones stoneCount) (= numEmpty emptyCount)) 
                    (cons currentSequence (SearchForSequences board (rest sequences) stoneCount emptyCount color)) )
                  
                  ;Otherwise, continue searching the rest of the sequences.
                  (t
                      (SearchForSequences board (rest sequences) stoneCount emptyCount color) )
            )
          
          ) )
  )
)

;Function Name: FindEmptyIndices
;Purpose: To find all of the empty indices within a sequence of locations.
;Parameters:
;              board, a list representing the current board of the game.
;              sequence, a list representing a single sequence of locations on the board.
;              index, an integer representing the current index being evaluated.
;Return Value: A list, containing the indices in the sequence that contain empty locations. Ex: (0 2 3)
;Algorithm:
;              1) For each location within the sequence, determine if the location is empty (using the At function).
;              2) If the location is empty, add the current index being evaluated to the return list.
;              3) Recursively search through each location within the provided sequence until all have been checked. 
;Assistance Received: None
(defun FindEmptyIndices (board sequence index)
	(let* ( (row (first (first sequence)))
			    (col (first (rest (first sequence)))) )
	
		(cond ( (null sequence)
				    () )
		  
			    ;If the location on the board is empty, add the current index to the return list.
          ( (eq (At board row col) '-)
				    (cons index (FindEmptyIndices board (rest sequence) (+ index 1))) )
				
          ;Otherwise, continue searching the rest of the locations in the provided sequence.
			    (t
				    (FindEmptyIndices board (rest sequence) (+ index 1)) )
		)	
	)
)

;Function Name: MakeCapture
;Purpose: To find the most optimal location that results in the most captured pairs, if any exist.
;Parameters:
;              board, a list representing the current board of the game.
;              color, a character representing the color of stone of the player calling this function.
;Return Value: A list, containing the location that results in the most captures, as well as the number of captures that occured. Ex: ((row col) numCaptures).
;Algorithm:
;              1) Find all of the possible capture locations and resulting number of captures that would occur if placed there (see FindAllCaptures).
;              2) Out of all the possible locations, find the location that results in the most captures so that the most points are scored (see FindMostCaptures).
;              3) Return the location the results in the most captures.
;Assistance Received: None
(defun MakeCapture (board color)
  (let* ( (potentialCaptures (FindAllCaptures board (AllBoardLocations 0 0) color)) ) 
    (cond ( (null potentialCaptures)
            () )

          ;If there is a possible capture location, sort the possiblities by number of captures to prioritize the most optimal capture location.
          ;The most optimal location is at the beginning of the newly sorted list. 
          (t
            (let* ( (optimalCapture (FindMostCaptures potentialCaptures 0 ()))
                    (location (rest optimalCapture)) 
                    (numCaptures (first optimalCapture)) )
              
              ;The returned list is in the format ((row col) numCaptures).
              (list (first location) numCaptures)

            ) )
    )
  )
)

;Finds all possible capture locations. 
;Function Name: FindAllCaptures
;Purpose: To find all possible capture locations on the board, along with how many captures occur if a stone is placed there.
;Parameters:
;              board, a list representing the current board of the game.
;              boardLocations, a list representing all of the valid board locations on the board.
;              color, a character representing the color of stone of the player calling this function.
;Return Value: A list, containing all the possible capture locations and resulting number of captures.
;Algorithm:
;              1) Recursively search through each of the possible valid board locations.
;              2) For each board location, generate the capture sequences that need to be checked (see GenerateCaptureSequences). 
;              3) Determine the number of captures that would occur if a stone is placed at the current board location being evaluated (see FindCapturesAtLocation).
;              4) If the number of captures is greater than 0, add this location and number of captures to the return list.
;              5) Once all board locations have been searched, return the list of locations that result in captures, if any exist.
;Assistance Received: None
(defun FindAllCaptures (board boardLocations color)
  (cond ( (null boardLocations)
          () )
          
        (t
          (let* ( (currentLocation (first boardLocations))
                  (row (first currentLocation))
                  (col (first (rest currentLocation)))
                  (captureSequences (GenerateCaptureSequences row col (GenerateAllDirections))) )
              
            ;The location being evaluated must be empty
            (cond ( (eq (At board row col) '-)
                    (let* ( (captureInfo (FindCapturesAtLocation board currentLocation captureSequences 0 color)) 
                            (numCaptures (first captureInfo)) )
                            
                      ;If at least 1 captured pair is possible at the current location being evaluated, add it to the return list.
                      (cond ( (> numCaptures 0)
                              (cons captureInfo (FindAllCaptures board (rest boardLocations) color)) )

                            ;Otherwise, continue searching the other locations.  
                            (t
                              (FindAllCaptures board (rest boardLocations) color) )
                      )
                    
                    ) ) 
                    
                  (t
                    (FindAllCaptures board (rest boardLocations) color) )   
            )
                      
          ) ) 
  )
)

;Function Name: FindCapturesAtLocation
;Purpose: To find the number of captures that would occur at a specific location if a stone of a provided color is placed there.
;Parameters:
;              board, a list representing the current board of the game.
;              location, a list representing the location on the board being evalutated. Ex: (row col)
;              captureSequences, a list of sequences of locations that need to be checked if a capture occured there.
;              numCaptures, an integer used to keep track the number of captures that would occur if a stone is placed at the location. 
;              color, a character representing the color of stone of the player calling this function.
;Return Value: A list, containing the number of captures, as well as the location. Ex: (2 (4 5)).
;Algorithm:
;              1) Recursively search through each capture sequence.
;              2) For each capture sequence, extract the first, second, and third locations (capture sequences are sequences of 3 locations away from the current location).
;                 Also, determine and store the opponent's stone color.
;              3) If the stones in the sequence are in the pattern O O P, that means a capture can occur. Recursively call the function with numCaptures incremented by 1.
;              4) Otherwise, continuing searching the rest of the capture sequences.
;              5) After all capture sequences have been searched, return the list containing the number of captures and the location that was evaluated.
;Assistance Received: None
(defun FindCapturesAtLocation (board location captureSequences numCaptures color)
  ;Once all capture sequences have been checked for the location, return a list containing the (location, numCaptures).
  (cond ( (null CaptureSequences)
          (list numCaptures location) )
          
        (t
          (let* ( (opponentColor (GetOpponentColor color))
                  (currentSequence (first captureSequences)) 
                  (firstLoc (first currentSequence))
                  (firstRow (first firstLoc))
                  (firstCol (first (rest firstLoc)))
                  (secondLoc (first (rest currentSequence)))
                  (secondRow (first secondLoc))
                  (secondCol (first (rest secondLoc)))
                  (thirdLoc (first (rest (rest currentSequence))))
                  (thirdRow (first thirdLoc))
                  (thirdCol (first (rest thirdLoc))) )
              
            ;If the stones are in the pattern O O P, where the O represents the opponent's stone and P represents the player's stone, a capture can be made.
            ;The O O P formation would be one of the sequences generated by the GenerateCaptureSequences function.
            (cond ( (and (eq (At board firstRow firstCol) opponentColor) 
                          (eq (At board secondRow secondCol) opponentColor) 
                          (eq (At board thirdRow thirdCol) color))
                          
                    ;If a capture is found at the location, increment the number of captures.      
                    (FindCapturesAtLocation board location (rest captureSequences) (+ numCaptures 1) color) )

                  ;Otherwise, continue searching the rest of the capture sequences.  
                  (t
                    (FindCapturesAtLocation board location (rest captureSequences) numCaptures color) )     
            )
          ) )
  )
)

;Function Name: FindMostCaptures
;Purpose: To find the location on the board that results in the most captures, given a list of potential capture locations.
;Parameters:
;              potentalCaptures, a list representing locations on the board that result in captures, and their corresponding number of captures. Ex: ((1 (2 14)), ...).
;              maxCaptures, an integer representing the maximum amount of captures found in a single move.
;              maxCaptures, a list representing the location on the board that results in the maximum amount of captures in a single move.
;Return Value: A list containing the maximum number of captures, and the location that results in this maximum. Ex: (2 (9 2))
;Algorithm:
;              1) Recursively loop through each of the potential capture locations.
;              2) For each potential capture location, extract the number of captures that would occur from placing a stone there.
;              3) If the number of captures is the greatest found so far, recursively call this function again with the new max captures and location.
;              4) Otherwise, continue searching through all possible capture locations until all have been checked by calling this function again.
;              5) Once all locations have been checked, return a list of the maximum capture count and the corresponding location.
;Assistance Received: None
(defun FindMostCaptures (potentialCaptures maxCaptures maxCapturesLocation)
	(cond ( (null potentialCaptures)
			(list maxCaptures maxCapturesLocation) )
			
		  (t
			(let* ( (currentCaptureInfo (first potentialCaptures))
					    (numCaptures (first currentCaptureInfo)) 
					    (location (first (rest currentCaptureInfo))) )
					
				;If the number of captures is the largest found so far, recursively
				;call the function with the new max.
				(cond ( (> numCaptures maxCaptures)
						    (FindMostCaptures (rest potentialCaptures) numCaptures location) )
						 
					  ;Otherwise continue searching the rest of the possible capture locations.
					  (t
						  (FindMostCaptures (rest potentialCaptures) maxCaptures maxCapturesLocation) )
				)
			) )
	)
)

;Function Name: PreventWinningMove
;Purpose: To find a location on the board that prevents the opponent from winning on their following turn, either by five consecutive stones or by capture.
;Parameters:
;              gameState, a list representing the current game state list.
;              color, a character representing the color of stone of the player calling this function.
;Return Value: A list, containing the location that prevents the opponent from winning, as well as how the win was prevented. Ex: (row col reasoning).
;Algorithm:
;              1) Call MakeWinningMove with the opponent's stone color to see if it's possible for the opponent to win on their following turn.
;              2) If there is a move where the opponent can win on their following turn, this is the location that needs to be blocked.
;               2a) Fix the reasoning to make more sense to the user, and then return this location and alterted reasoning.
;              3) Otherwise, return an empty list.
;Assistance Received: None
(defun PreventWinningMove (gameState color)
  (let* ( (preventPlay (MakeWinningMove gamestate (GetOpponentColor color) ())) )

    ;If there is a move that prevents the opponent from winning, the reasoning for the play must be fixed so that it is in a more understandable manner.
    (cond ( (> (length preventPlay) 0) 

            ;The opponent can win by making five consecutive stones.
            (cond ( (string= (first (rest preventPlay)) " to win by getting five consecutive stones.")
                    (list (first preventPlay) " to prevent the opponent from winning by getting five consecutive stones.") )

                  ;The opponent can win by capturing.
                  (t
                    (list (first preventPlay) " to prevent the opponent from winning by getting at least five captured pairs.") )
            ) )

          (t
            () )
    )
  )
)

;Function Name: PreventCapture
;Purpose: To find any locations on the board that prevents the player from being captured on their following turn.
;Parameters:
;              board, a list representing the current board of the game.
;              color, a character representing the color of stone of the player calling this function.
;Return Value: A list, containing the location that prevents the opponent from capturing their stones.
;Algorithm:
;              1) Call MakeCapture with the opponent's stone to find out if they can make any captures on their following turn. This is the location that is returned.
;Assistance Received: None
(defun PreventCapture (board color)
  ;To prevent captures, all that needs to be checked is if the opponent can make a capture on their following turn. This will return the optimal location to prevent capture.
  (MakeCapture board (GetOpponentColor color))
)

;Function Name: FindDeadlyTessera
;Purpose: To find a location on the board that builds a deadly tessera for the player.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 6 that needs to be searched.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;              possiblePlacement, a list that is used to keep track of a possible placement of a deadly tessera.
;Return Value: A list, containing the location that would result in a deadly tessera forming for the player.
;Algorithm:
;              1) Recursively search through each of the provided sequences.
;              2) For each sequence, determine and store the empty indices of that sequence.
;              3) If two of the empty indices in the sequence or 0 and 5 (representing the ends of the sequence), a deadly tessera can be formed.
;                3a) The location that forms the deadly tessera is the middle empty index (ex: - W W * W -). If this location does not put the player at risk of being
;                    captured, return this location.
;                3b) If the location that forms a deadly tessera does put the player at risk of being captured, recursively call this location, but update possiblePlacement to
;                    this found location. If there are no other deadly tessera locations found, this is the location that will be returned. This is so safe placements are prioritized.
;              4) Otherwise continue searching the rest of the sequences recursively.
;                4a) If a deadly tessera was found, but it puts the player at risk of being captured, it should still be returned as it almost always results in that player winning.
;                4b) Otherwise, an empty list is returned.
;Assistance Received: None
(defun FindDeadlyTessera (board sequences dangerColor possiblePlacement)
  (cond ( (null sequences) 
          ;Even if the deadly tessera placement puts the player at risk of being captured, it should still be formed.
          ;However, it should be prioritized to place in locations that do not put the player at risk of being captured.
          possiblePlacement )
          
        (t
          (let* ( (currentSequence (first sequences))
                  (emptyIndices (FindEmptyIndices board currentSequence 0))
                  ;NOTE: There will always be 3 empty indices within each sequence when this function is called.
                  (firstEmpty (nth 0 emptyIndices))
                  (secondEmpty (nth 1 emptyIndices))
                  (thirdEmpty (nth 2 emptyIndices))
                  ;Store whether or not placing a stone at the location that creates a deadly tessera puts the player at risk of being captured.
                  (noDanger (NotInDangerOfCapture board (nth secondEmpty currentSequence) dangerColor (GenerateAllDirections))) )
      
            ;If both ends of the set of 6 locations are empty (the empty indices are 0 and 5), this means that a deadly tessera can be formed.
            (cond ( (and (= firstEmpty 0) (= thirdEmpty 5)) 
                    ;If the location does not put the player at risk of being caputred, return this location.
                    (cond ( noDanger
                            (nth secondEmpty currentSequence) )
                          
                          ;If the location does put the player at risk of being captured, store it as a possible placement.
                          ;If all possible build locations put the player at risk of being captured, one should still be returned as its still worth it to build a deadly tessera.
                          (t
                              (FindDeadlyTessera board (rest sequences) dangerColor (nth secondEmpty currentSequence)) )
                    ) )
                    
                  ;A deadly tessera could not be built with the current sequence. Search the rest of the sequences.  
                  (t
                    (FindDeadlyTessera board (rest sequences) dangerColor possiblePlacement) )    
            )	 
    ) )
  )
)

;Function Name: NotInDangerOfCapture
;Purpose: To determine if placing a stone at a provided location would not put the player at risk of being captured on their following turn.
;Parameters:
;              board, a list representing the current board of the game.
;              location, a list representing a valid location on the board.
;              color, a character representing the color of stone of the player calling this function.
;              directions, a list representing all eight directions on the board.
;Return Value: A boolean, which is true if placing a stone at the location does not put the player at risk of being captured, and false if it does.
;Algorithm:
;              1) Recursively search through all eight possible directions, since captures can happen in any direction.
;              2) For each direction, generate two locations in the current direction being evaluated and one location in the opposite direction.
;              3) If all locations generated in Step 2 are valid:
;                3a) Check if the stones are either in the pattern:  - * P O or O * P - (P is current player, O is opponent, - is an empty location, and * is the location
;                    passed to this function). If this pattern exists, return false, as the location would put the player at risk of being captured.
;                3b) Otherwise, continue searching the rest of the directions recursively.
;              4) Otherwise, continue checking the rest of the directions recursively.
;              5) If all directions have been checked, return true.
;Assistance Received: None
(defun NotInDangerOfCapture (board location color directions)
	;If all directions have been checked, return true indicating there is no risk of being captured after placing a stone at "location".
  (cond ( (null directions)
		      t )
		  
		    (t
			    (let* ( (opponentColor (GetOpponentColor color))
                  (currentDirection (first directions))
                  (rowChange (first currentDirection))
                  (colChange (first (rest currentDirection)))
                  ;Generating the opposite direction.
                  (oppositeRowChange (* rowChange -1))
                  (oppositeColChange (* colChange -1))
                  ;The row/col pair that was passed to this function.
                  (currentRow (first location))
                  (currentCol (first (rest location)))
                  ;To find risk of potential capture, two locations going in the current direction being 
                  ;evaluated, and one location going in the opposite direction needs to be stored.
                  (oneAwayRow (+ currentRow rowChange)) 
                  (oneAwayCol (+ currentCol colChange))
                  (twoAwayRow (+ oneAwayRow rowChange))
                  (twoAwayCol (+ oneAwayCol colChange))
                  (oneBehindRow (+ currentRow oppositeRowChange))
                  (oneBehindCol (+ currentCol oppositeColChange)) )
					
				    ;All of the locations being evaluated must be valid.
				    (cond ( (and (ValidIndices oneAwayRow oneAwayCol) 
                         (ValidIndices twoAwayRow twoAwayCol) 
                         (ValidIndices oneBehindRow oneBehindCol))
					  
                    ;If all of the locations are valid, there are two possible patterns that need to be checked.
                    ;Handling the pattern: - * P O (P is current player, O is opponent, - is an empty location)
					          (cond ( (and (eq (At board oneBehindRow oneBehindCol) '-)
								                 (eq (At board oneAwayRow oneAwayCol) color)
								                 (eq (At board twoAwayRow twoAwayCol) opponentColor))
							              () )
							
							            ;Handling the pattern: O * P - (P is current player, O is opponent, - is an empty location)
							            ( (and (eq (At board oneBehindRow oneBehindCol) opponentColor)
								                 (eq (At board oneAwayRow oneAwayCol) color)
								                 (eq (At board twoAwayRow twoAwayCol) '-))
							              () )
							  
                          ;Continue searching the rest of the directions.
                          (t
                            (NotInDangerOfCapture board location color (rest directions)) )
					          ) )
					  
                  ;Check the rest of the directions if any of the locations generated are not valid.
                  (t
                    (NotInDangerOfCapture board location color (rest directions)) )
				    )
			    ) )
			
	)
)

;Function Name: BuildInitiative
;Purpose: To find the most optimal location to build initiative for the player.
;Parameters:
;              board, a list representing the current board of the game.
;              numPlaced, an integer representing the number of stones placed by the current player in an open consecutive five locations to search for.
;              playerColor, a character representing the stone color of the player to search for.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn (used for defense).
;Return Value: A list, containing the optimal location to build initiative.
;Algorithm:
;              1) Find all of the possible open consecutive five locations that satify the search conditions passed to this function (using SearchForSequences).
;                1a) If there are no possible sequences of locations, simply return an empty list.
;              2) If numPlaced equals 1:
;                2a) Find all locations that are two away from a single placed stone (see FindTwoLocationsAway). Return one of these locations.
;              3) If numPlaced equals 2:
;                3a) Attempt to return a location that results in three consecutive stones (see ThreeConsecutive), if it exists.
;                3b) If it isn't possible to make three consecutive stones, return the location that results in the least amount of consecutive 
;                    stones (see FindLeastConsecutiveStones) to avoid capture risk.
;              4) If numPlaced equals 3:
;                4a) Attempt to return a location that results in four consecutive stones (see FourConsecutive), if it exists.
;                4b) If it isn't possible to make four consecutive stones, return the location that results in three conscecutive stones (always will be possible).
;Assistance Received: None
(defun BuildInitiative(board numPlaced playerColor dangerColor)
	;Note: The number of empty locations required is (5 - numPlaced)
	(let* ( (sequences (SearchForSequences board (GetAllSequences 5) numPlaced (- 5 numPlaced) playerColor)) )
		
		;If there are no sequences found, then there are no plays with this initiative.
		(cond ( (null sequences) 
				    () )
				
			    (t
            ;The player is attempting to build initiative with one of their stones already placed in an open 5.	
            (cond ( (= numPlaced 1)
                    (let* ( (possibleMoves (FindTwoLocationsAway board sequences dangerColor)) )
                         
                      ;Return any of the possible moves (there will often be many) so that the computer builds in all directions.
                      (cond ( (> (length possibleMoves) 0)
                              (nth (random (length possibleMoves)) possibleMoves) )
                              
                            (t
                              () )
                      )
                    ) )
					
                    ;The player is attempting to build initiative with two of their stones already placed in an open 5.	  
                  ( (= numPlaced 2)
                    (let* ( (possibleThreeConsecutive (ThreeConsecutive board sequences dangerColor)) 
                            (leastConsecutiveStones (FindLeastConsecutiveStones board sequences 5 () dangerColor)) )

                      ;Prioritize building three consecutive stones.
                      ;If it's not possible, return the location that results in the least amount of consecutive stones to avoid capture.
                      ;Example: W - * - W.
                      (cond ( (> (length possibleThreeConsecutive) 0)
                              possibleThreeConsecutive )
                            
                            (t
                              leastConsecutiveStones )
                      )
                    ) )
						
                  ;The player is attempting to build initiative with three of their stones already placed in an open 5.	
                  ( (= numPlaced 3)
                    (let* ( (possibleFourConsecutive (FourConsecutive board sequences dangerColor))
                            (possibleThreeConsecutive (ThreeConsecutive board sequences dangerColor)) )
                          
                      ;Prioritize building four consecutive stones.
                      ;If it's not possible, return the location that builds three consecutive stones (always will be possible in this case).
                      (cond ( (> (length possibleFourConsecutive) 0)
                              possibleFourConsecutive )
                              
                            (t
                              possibleThreeConsecutive )
                      ) 
                          
                    ) )
						
					        (t
						        () )
				    ) )
		)
	)
)

;Function Name: FindTwoLocationsAway
;Purpose: To find a list of possible locations that are a distance of two locations away from a placed stone.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 5 that needs to be searched.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;Return Value: A list of possible play locations two locations away from a placed stone in the format ((row col) (row col) ...).
;Algorithm:
;              1) Recursively loop through each of the sequences of locations passed to this function.
;              2) For each sequence of locations, extract the first and last locations of the sequence.
;              3) If the first or last location is not empty, meaning the sequence is in the format W - - - - or - - - - W:
;                3a) If the first location is not empty (the sequence is W - - - -), add the 3rd location (middle) of the sequeunce to the return list (ex: W - * - -).
;                    Recursively call this function to search the rest of the sequences.
;                3b) If the last location is not empty (the sequence is - - - - W), add the 3rd location (middle) of the sequence to the return list (ex: - - * - W).
;                    Recursively call this function to search the rest of the sequeunces.
;              4) Otherwise continue searching the rest of the sequences through recursion.
;              5) Once all sequences have been checked, return the list of possible handicap plays.
;Assistance Received: None
(defun FindTwoLocationsAway (board sequences dangerColor)
  (cond ( (null sequences)
          () )
      
        (t
          (let* ( (currentSequence (first sequences))
                  (emptyIndices (FindEmptyIndices board currentSequence 0))
                  ;The first location of the sequence.
                  (firstLocation (nth 0 currentSequence))
                  (firstRow (first firstLocation))
                  (firstCol (first (rest firstLocation)))
                  ;The last location of the sequence. The last location is in index 4 of the five locations in the sequence.
                  (lastLocation (nth 4 currentSequence))
                  (lastRow (first lastLocation))
                  (lastCol (first (rest lastLocation)))
                  ;The middle location has the index of 2 in the sequence. Ex: - - * - -.
                  (middleLocation (nth 2 currentSequence))
                  ;Make sure the middle location does not put the player at risk of capture.
                  (noDangerMiddle (NotInDangerOfCapture board middleLocation dangerColor (GenerateAllDirections))) )
              
            ;To be a valid place location, the single placed stone must be on one of the ends of the sequence so the middle can be easily found.
            ;Ex: W - - - - OR - - - - W. The ideal placement in this case is the middle location of the sequence. 
            ;If any sequences match this pattern, add the middle location to the return list.
            (cond ( (and (or (not (eq (At board firstRow firstCol) '-)) (not (eq (At board lastRow lastCol) '-))) noDangerMiddle) 
                    (cons middleLocation (FindTwoLocationsAway board (rest sequences) dangerColor)) )
                    
                  (t
                    (FindTwoLocationsAway board (rest sequences) dangerColor) )
                    
            )
              
          ) )    
  
  )
)

;Function Name: ThreeConsecutive
;Purpose: To find if there is a location that would result in three consecutive stones, given sequences of locations to search.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 5 that needs to be searched.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;Return Value: A list, containing the location that results in three consecutive stones for the player.
;Algorithm:
;              1) Recursively search through each of the provided sequences of locations.
;              2) For each sequence, find the empty indices within the sequence (there will either be two or three when this function is called).
;              3) Store whether or not placing a stone at each empty index would put the player at risk of being captured.
;              4) Test each empty index, and if placing a stone on any of them result in three consecutive stones (calculated through NumConsecutiveIfPlaced),
;                 AND placing a stone does there does not put the player at risk of being captured, return this location.
;              5) Otherwise, continue searching the rest of the sequences through recursion. 
;              6) If there are no locations found after all sequences are searched, return an empty list.
;Assistance Received: None
(defun ThreeConsecutive (board sequences dangerColor)
	;If there are no more sequences to search, then it is not possible to make three consecutive stones.
	(cond ( (null sequences) 
			    () )
			
        (t
          (let* ( (currentSequence (first sequences))
                  (emptyIndices (FindEmptyIndices board currentSequence 0))
                  ;There will always either 2 or 3 empty indices when this function is called.
                  (firstEmpty (nth 0 emptyIndices))
                  (secondEmpty (nth 1 emptyIndices)) 
                  ;Store whether or not placing a stone at each location would not put the player at risk of capture.
                  (noDanger1 (NotInDangerOfCapture board (nth firstEmpty currentSequence) dangerColor (GenerateAllDirections))) 
                  (noDanger2 (NotInDangerOfCapture board (nth secondEmpty currentSequence) dangerColor (GenerateAllDirections))) )
              
            ;There will either be two or three empty locations when this function is called.
            ;If there are 3 empty indices, the additional third empty location needs to be checked.
            (cond ( (= (length emptyIndices) 3) 
                    ;If it's possible to make three consecutive stones, return this location IF
                    ;the resulting play does not put the player at danger of being captured the following turn.
                    (let* ( (thirdEmpty (nth 2 emptyIndices))
                            (noDanger3 (NotInDangerOfCapture board (nth thirdEmpty currentSequence) dangerColor (GenerateAllDirections))) )
                            
                      ;If it's possible to make three consecutive stones, return this location IF
                      ;the resulting play does not put the player at danger of being captured the following turn.
                      (cond ( (and (= (NumConsecutiveIfPlaced board currentSequence firstEmpty) 3) noDanger1)
                              (nth firstEmpty currentSequence) )
                          
                            ( (and (= (NumConsecutiveIfPlaced board currentSequence secondEmpty) 3) noDanger2)
                              (nth secondEmpty currentSequence) ) 
                            
                            ( (and (= (NumConsecutiveIfPlaced board currentSequence thirdEmpty) 3) noDanger3)
                              (nth thirdEmpty currentSequence) ) 
                            
                            ;Continue searching the remaining sequences.
                            (t
                              (ThreeConsecutive board (rest sequences) dangerColor) )
                          
                      )
                    ) )
                
                  ;There are two empty indices in the sequence.	
                  (t
                      ;If it's possible to make three consecutive stones, return this location IF
                      ;the resulting play does not put the player at danger of being captured the following turn.
                      (cond ( (and (= (NumConsecutiveIfPlaced board currentSequence firstEmpty) 3) noDanger1)
                            (nth firstEmpty currentSequence) )
                        
                            ( (and (= (NumConsecutiveIfPlaced board currentSequence secondEmpty) 3) noDanger2)
                              (nth secondEmpty currentSequence) ) 
                        
                          ;Continue searching the remaining sequences.
                          (t
                            (ThreeConsecutive board (rest sequences) dangerColor) )
                        
                      ) )
          
            ) ) )
	)
)

;Function Name: NumConsecutiveIfPlaced
;Purpose: To determine the number of consecutive stones that would occur if a stone is placed at a provided index of the sequence.
;Parameters:
;              board, a list representing the current board of the game.
;              sequence, a list representing a single sequence of locations.
;              placeIndex, an integer representing the index of sequence where the stone would potentially be placed.
;Return Value: An integer, representing the number of consecutive stones that would occur in the sequence if a stone was placed at placeIndex of the sequence. 
;Algorithm:
;              1) Calculate the number of consecutive stones before the placeIndex in the sequence.
;              2) Calculate the number of consecutive stones after the placeIndex in the sequence.
;              3) Return the number of consecutive stones before placeIndex + the number of consecutive stones after placeIndex + 1 (to represent the stone itself).
;Assistance Received: None
(defun NumConsecutiveIfPlaced (board sequence placeIndex)
	(let* ( (beforeConsec (BeforeConsecutive board sequence (- placeIndex 1))) 
          (afterConsec (AfterConsecutive board sequence (+ placeIndex 1)))
          ;The total consecutive stones placed is the number of consecutive stones before the current location, 
          ;plus the number of consecutive stones after the current location, plus 1 (to represent the stone itself being placed).
          (totalConsec (+ beforeConsec afterConsec 1)) )
			
		totalConsec
	)
)

;Function Name: BeforeConsecutive
;Purpose: To determine the number of consecutive stones from an index, up to the left end of a sequence. Helper function for NumConsecutiveIfPlaced.
;Parameters:
;              board, a list representing the current board of the game.
;              sequence, a list representing a single sequence of locations.
;              index, an integer used to keep track of the index of the sequence that is being evaluated.
;Return Value: An integer, representing the number of consecutive stones found.
;Algorithm:
;              1) If the index is less than 0, return 0.
;              2) Extract the location that is at the provided index of sequence.
;              3) If the location has a stone placed there, return the result of recursively calling this function with one subtracted from index + 1.
;              4) Otherwise, if the location is empty the consecutive streak is over and 0 should be returned.
;Assistance Received: None
(defun BeforeConsecutive (board sequence index)
	
	;If the index goes out of bounds, return 0.
	(cond ( (< index 0)
			    0 )
			
		    (t
			    (let* ( (location (nth index sequence))
					        (row (first location))
					        (col (first (rest location))) )
				
				    ;If the location on the board is not empty, increment the returned value by 1.
				    ;And, continue searching the rest of the locations earlier in the sequence.
				    (cond ( (not (eq (At board row col) '-))
						        (+ (beforeConsecutive board sequence (- index 1)) 1) )
					
					        ;Once one of the locations are empty, the consecutive streak is over.
					        (t
						        0 )
				    )
			    ) )
	)
)

;Function Name: AfterConsecutive
;Purpose: To determine the number of consecutive stones from an index, up to the right end of a sequence. Helper function for NumConsecutiveIfPlaced.
;Parameters:
;              board, a list representing the current board of the game.
;              sequence, a list representing a single sequence of locations.
;              index, an integer used to keep track of the index of the sequence that is being evaluated.
;Return Value: An integer, representing the number of consecutive stones found.
;Algorithm:
;              1) If the index is greater than 4, return 0.
;              2) Extract the location that is at the provided index of sequence.
;              3) If the location has a stone placed there, return the result of recursively calling this function with one added to index + 1.
;              4) Otherwise, if the location is empty the consecutive streak is over and 0 should be returned.
;Assistance Received: None
(defun AfterConsecutive (board sequence index)
	;If the index goes out of bounds, return 0. In this case, sequences are always five consecutive locations.
	(cond ( (> index 4)
			    0 )
			
		    (t
			    (let* ( (location (nth index sequence))
					        (row (first location))
					        (col (first (rest location))) )
				
				    ;If the location on the board is not empty, increment the returned value by 1.
				    ;And, continue searching the rest of the locations after the current in the sequence.
				    (cond ( (not (eq (At board row col) '-))
						        (+ (afterConsecutive board sequence (+ index 1)) 1) )
					
					        ;Once one of the locations are empty, the consecutive streak is over.
					        (t
						        0 )
				    )
			    ) )
	)
)

;Function Name: FindLeastConsecutiveStones
;Purpose: To find the location that would result in the least amount of consecutive stones, given sequences of locations to search for.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 5 that needs to be searched.
;              minConsecutives, an integer representing the fewest consecutive stones found so far.
;              minConsecutivesLocation, a list representing the location that results in the fewest consecutive stones found so far.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;Return Value: A list, containing the location that results in the least consecutive stones for the player.
;Algorithm: 
;              1) Recursively search through each of the provided sequences of locations.
;              2) For each sequence, find the empty indices within the sequence (there will always be 3 when this function is called).
;              3) Store whether or not placing a stone at each empty index would put the player at risk of being captured.
;              4) Depending on which locations do not put the player at risk of being captured, find the location that results in the least amount of consecutive stones.
;                 Note: All 3 locations, 2 locations, or just 1 location may not put the player at risk of being captured. Ignore locations that do put the player at risk.
;              5) If the location that results in the least amount of consecutive stones is the least found so far, recursively call this function with the new
;                 least consecutive stones found and location.
;              6) Once all sequeunces have been checked, return the location that results in the minimum amount of consecutive stones.
;Assistance Received: None
(defun FindLeastConsecutiveStones (board sequences minConsecutives minConsecutivesLocation dangerColor)
  ;Once all sequences have been seen, return the location that would result in the minimum amount of consecutive stones if placed.
  (cond ( (null sequences)
          minConsecutivesLocation )
          
        (t
          (let* ( (currentSequence (first sequences))
                  (emptyIndices (FindEmptyIndices board currentSequence 0))
                  ;NOTE: There will always be 3 empty indices within each sequence when this function is called.
                  (firstEmpty (nth 0 emptyIndices))
                  (secondEmpty (nth 1 emptyIndices))
                  (thirdEmpty (nth 2 emptyIndices))
                  ;Store the number of consecutive stones if placed at each empty location.
                  (firstLocationConsecutives (NumConsecutiveIfPlaced board currentSequence firstEmpty))
                  (secondLocationConsecutives (NumConsecutiveIfPlaced board currentSequence secondEmpty))
                  (thirdLocationConsecutives (NumConsecutiveIfPlaced board currentSequence thirdEmpty))
                  ;Store whether or not placing a stone at each location would not put the player at risk of capture.
                  (noDanger1 (NotInDangerOfCapture board (nth firstEmpty currentSequence) dangerColor (GenerateAllDirections))) 
                  (noDanger2 (NotInDangerOfCapture board (nth secondEmpty currentSequence) dangerColor (GenerateAllDirections))) 
                  (noDanger3 (NotInDangerOfCapture board (nth thirdEmpty currentSequence) dangerColor (GenerateAllDirections))) ) 
      
            ;None of the locations put the player at risk of being captured.
            (cond ( (and noDanger1 noDanger2 noDanger3) 
                    ;The first empty location has the least consecutive stones if placed.
                    (cond ( (and (< firstLocationConsecutives secondLocationConsecutives) (< firstLocationConsecutives thirdLocationConsecutives))
                            (cond ( (< firstLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) firstLocationConsecutives (nth firstEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                        
                          ;The second empty location has the least consecutive stones if placed.    
                          ( (and (< secondLocationConsecutives firstLocationConsecutives) (< secondLocationConsecutives thirdLocationConsecutives))
                            (cond ( (< secondLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) secondLocationConsecutives (nth secondEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                            
                          ;The third location has the least consecutive stones if placed.
                          (t 
                            (cond ( (< thirdLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) thirdLocationConsecutives (nth thirdEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                    ) )
                    
                  ;Only the first and second locations do not put the player at risk of being captured.    
                  ( (and noDanger1 noDanger2) 
                    
                    ;The first location has the least consecutive stones if placed.
                    (cond ( (< firstLocationConsecutives secondLocationConsecutives)
                            (cond ( (< firstLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) firstLocationConsecutives (nth firstEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )

                          ;The second location has the least consecutive stones if placed.  
                          (t
                            (cond ( (< secondLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) secondLocationConsecutives (nth secondEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                    ) )
                    
                  ;Only the second and third locations do not put the player at risk of being captured.    
                  ( (and noDanger2 noDanger3) 
                    
                    ;The second location has the least consecutive stones if placed.
                    (cond ( (< secondLocationConsecutives thirdLocationConsecutives)
                            (cond ( (< secondLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) secondLocationConsecutives (nth secondEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                          
                          ;The third location has the least consecutive stones if placed.
                          (t
                            (cond ( (< thirdLocationConsecutives minConsecutives)
                                    (FindLeastConsecutiveStones board (rest sequences) thirdLocationConsecutives (nth thirdEmpty currentSequence) dangerColor) )
                                    
                                  (t
                                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                            ) )
                    ) )
                    
                  ;Only the first location does not put the player at risk of being captured.    
                  ( noDanger1
                    (cond ( (< firstLocationConsecutives minConsecutives)
                            (FindLeastConsecutiveStones board (rest sequences) firstLocationConsecutives (nth firstEmpty currentSequence) dangerColor) )
                            
                          (t
                            (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                          
                    ) )
                    
                  ;Only the second location does not put the player at risk of being captured.    
                  ( noDanger2 
                    (cond ( (< secondLocationConsecutives minConsecutives)
                            (FindLeastConsecutiveStones board (rest sequences) secondLocationConsecutives (nth secondEmpty currentSequence) dangerColor) )
                            
                          (t
                            (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                          
                    ) )
                    
                  ;Only the third location does not put the player at risk of being captured.    
                  ( noDanger3 
                    (cond ( (< thirdLocationConsecutives minConsecutives)
                            (FindLeastConsecutiveStones board (rest sequences) thirdLocationConsecutives (nth thirdEmpty currentSequence) dangerColor) )
                            
                          (t
                            (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
                          
                    ) )
                  
                  ;All of the locations put the player at risk of being captured, no further evaluation is needed for this sequence.   
                  (t
                    (FindLeastConsecutiveStones board (rest sequences) minConsecutives minConsecutivesLocation dangerColor) )
            )
    ) )    
  )
)

;Function Name: FourConsecutive
;Purpose: To find if there is a location that would result in four consecutive stones, given sequences of locations to search.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 5 that needs to be searched.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;Return Value: A list, containing the location that results in four consecutive stones for the player.
;Algorithm:
;              1) Recursively search through each of the provided sequences of locations.
;              2) For each sequence, find the empty indices within the sequence (there will always be 2 when this function is called).
;              3) Store whether or not placing a stone at each empty index would put the player at risk of being captured.
;              4) Test each empty index, and if placing a stone on any of them result in four consecutive stones (calculated through NumConsecutiveIfPlaced)
;                 AND placing a stone there does not put the player at risk of being captured, return this location.
;              5) Otherwise, continue searching the rest of the sequences through recursion.
;              6) If there are no locations found after all sequences are searched, return an empty list.
;Assistance Received: None
(defun FourConsecutive (board sequences dangerColor)
	;If there are no more sequences to search, then it is not possible to make four consecutive stones.
	(cond ( (null sequences) 
			    () )
			
		  (t
			  (let* ( (currentSequence (first sequences))
					      (emptyIndices (FindEmptyIndices board currentSequence 0))
					      ;There will always be 2 empty indices when this function is called.
					      (firstEmpty (nth 0 emptyIndices))
					      (secondEmpty (nth 1 emptyIndices))
					      ;Store whether or not placing a stone at each location would put the player at risk of capture.
					      (noDanger1 (NotInDangerOfCapture board (nth firstEmpty currentSequence) dangerColor (GenerateAllDirections))) 
					      (noDanger2 (NotInDangerOfCapture board (nth secondEmpty currentSequence) dangerColor (GenerateAllDirections))) )
					
				;If it's possible to make four consecutive stones, return this location IF
				;the location does not put the player at risk of being captured the following turn.
				(cond ( (and (= (NumConsecutiveIfPlaced board currentSequence firstEmpty) 4) noDanger1)
						    (nth firstEmpty currentSequence) )
						
					    ( (and (= (NumConsecutiveIfPlaced board currentSequence secondEmpty) 4) noDanger2)
						    (nth secondEmpty currentSequence) )
						
					    ;Continue searching the remaining sequences.
					    (t
						    (FourConsecutive board (rest sequences) dangerColor) )
				)
			) )
	)
)

;Function Name: CounterInitiative
;Purpose: To find the most optimal location to counter the opponent's initiative.
;Parameters:
;              board, a list representing the current board of the game.
;              numPlaced, an integer representing the number of stones placed by the opponent in an open consecutive five locations to search for.
;              color, a character representing the stone color of the player calling this function.
;Return Value: A list, containing the optimal location that counters the opponent's initiative.
;Algorithm:
;              1) If numPlaced is equal to 1:
;                1a) Call the BuildInitiative function with the opponent's color to find the opponent's next best possible move when building initiative.
;                1b) If a location is returned from the function above, return this location as it is the most optimal location to block. Otherwise, an empty list is returned.
;              2) If numplaced is equal to 2:
;                2a) Determine if it is possible to initiative a flank using the FindFlanks function. If there is a location, return it, otherwise an empty list is returned.
;              3) If numplaced is equal to 3:
;                3a) Call the BuildInitiative function with the opponent's color to find the opponent's next best possible move when building initiative.
;                3b) If a location is returned from the function above, return this location as it is the most optimal location to block. Otherwise, an empty list is returned.
;Assistance Received: None
(defun CounterInitiative (board numPlaced color)
  ;The player is attempting to counter initiative by preventing the opponent from getting 2 stones in an open 5 consecutive locations.  
  (cond ( (= numPlaced 1) 
          (BuildInitiative board 1 (GetOpponentColor color) color) )
          
        ;The player is attempting to counter initiative by initiating a flank (two-turn capture).
        ( (= numPlaced 2) 
          ;To find a flank, the sequences should be of length 4 where the pattern is: - W W -.
          (FindFlanks board (SearchForSequences board (GetAllSequences 4) 2 2 (GetOpponentColor color)) color) )
          
        ;The player is attempting to counter initiative by preventing the opponent from getting 4 stones in an open 5 consecutive locations.    
        ( (= numPlaced 3) 
          (BuildInitiative board 3 (GetOpponentColor color) color) )
          
        (t
          () )
  )
)

;Function Name: FindFlanks
;Purpose: To find a location on the board that initiates a flank on the opponent, if any exist.
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 4 that needs to be searched.
;              dangerColor, a character representing the stone color that would potentially be in danger of being captured on the following turn.
;Return Value: A list, containing the location on the board that initiates a flank on the opponent in the format (row col).
;Algorithm:
;              1) Recursively loop through each sequence of locations passed to this function.
;              2) For each sequence of locations, find and extract the empty locations.
;              3) For each empty location (there will always be 2 when this function is called), determine whether or not placing a stone there would put the player
;                 at risk of being captured.
;              4) If the empty indices in the sequence of locations are 0 and 3 (the ends of the sequence of 4 locations):
;                4a) A flank can be initiated. Return one of the two locations that do put the player at risk of being captured on the following turn.
;                4b) If both of the locations put the player at risk of being captured, continue searching the rest of the sequeunces by recursively calling this function.
;              5) Otherwise continue recursively searching the rest of the sequeunce of locations. If all are checked, return an empty list.
;Assistance Received: None
(defun FindFlanks (board sequences dangerColor)
  (cond ( (null sequences)
          () )
          
        (t
          (let* ( (currentSequence (first sequences)) 
                  (emptyIndices (FindEmptyIndices board currentSequence 0))
                  ;Note: There will always be two empty indices within each sequence provided to this function.
                  (firstEmpty (nth 0 emptyIndices))
                  (secondEmpty (nth 1 emptyIndices))
                  ;Store whether or not placing a stone at each location would not put the player at risk of capture.
                  (noDanger1 (NotInDangerOfCapture board (nth firstEmpty currentSequence) dangerColor (GenerateAllDirections))) 
                  (noDanger2 (NotInDangerOfCapture board (nth secondEmpty currentSequence) dangerColor (GenerateAllDirections))) )
              
            ;If the empty indices are 0 and 3, they are on the ends of the consecutive 4 locations (* W W *), and it means that a flank can be initiated.
            ;Return the location as long as it does not put the user 
            (cond ( (and (= firstEmpty 0) (= secondEmpty 3))
                    ;If a flank can be initiated, return one of the placement locations as long as it does not put the player at risk of being captured.
                    (cond ( noDanger1 
                            (nth firstEmpty currentSequence) )
                            
                          ( noDanger2
                            (nth secondEmpty currentSequence) )
                          
                          ;None of the possible flank locations are safe so search the rest of the sequences.    
                          (t
                            (FindFlanks board (rest sequences) dangerColor) )
                    
                    ) )
                  
                  (t
                    (FindFlanks board (rest sequences) dangerColor) )
            )
          ) )
  )
)

;Function Name: FindHandicapPlay
;Purpose: To find a list of possible optimal plays within the handicap (when it is the second turn of the player that went first).
;Parameters:
;              board, a list representing the current board of the game.
;              sequences, a list of sequences of locations of length 5 that needs to be searched.
;Return Value: A list of possible handicap play locations in the format ((row col) (row col) ...).
;Algorithm:
;              1) Recursively loop through each of the sequences of locations passed to this function.
;              2) For each sequence of locations, extract the first and last locations of the sequence.
;              3) If the first or last location is not empty, meaning the sequence is in the format W - - - - or - - - - W:
;                3a) If the first location is not empty (the sequence is W - - - -), add the 4th location of the sequeunce to the return list (ex: W - - * -).
;                    Recursively call this function to search the rest of the sequences.
;                3b) If the last location is not empty (the sequence is - - - - W), add the 2nd location of the sequence to the return list (ex: - * - - W).
;                    Recursively call this function to search the rest of the sequeunces.
;              4) Otherwise continue searching the rest of the sequences through recursion.
;              5) Once all sequences have been checked, return the list of possible handicap plays.
;Assistance Received: None
(defun FindHandicapPlay(board sequences)
  (cond ( (null sequences)
          () )
      
        (t
          (let* ( (currentSequence (first sequences))
                  ;The first location of the sequence.
                  (firstLocation (nth 0 currentSequence))
                  (firstRow (first firstLocation))
                  (firstCol (first (rest firstLocation)))
                  ;The last location of the sequence. The last location is in index 4 of the five locations in the sequence.
                  (lastLocation (nth 4 currentSequence))
                  (lastRow (first lastLocation))
                  (lastCol (first (rest lastLocation))) )
              
            ;To be a valid place location, the single placed stone must be on one of the ends of the sequence so the optimal play can be easily found.
            ;Ex: W - - - - OR - - - - W. The ideal placement in this case is w - - * - OR - * - - W so that it is valid within the second turn handicap for the first player.
            ;If any sequences match this pattern, add the middle location to the return list.
            
            ;Handling the W - - * - case. The index of the optimal location is 3 in the sequence of five locations.
            (cond ( (not (eq (At board firstRow firstCol) '-))
                    (cons (nth 3 currentSequence) (FindHandicapPlay board (rest sequences))) )
                
                  ;Handling the - * - - W case. The index of the optimal location is 1 in the sequence of five locations.    
                  ( (not (eq (At board lastRow lastCol) '-))
                    (cons (nth 1 currentSequence) (FindHandicapPlay board (rest sequences))) )
                    
                  (t
                    (FindHandicapPlay board (rest sequences)) )
                    
            )
              
          ) )    
  
  )
)

;Function Name: ScoreBoard
;Purpose: To score the board for a given stone color.
;Parameters:
;              gameState, a list representing the current game state list.
;              color, a character representing the stone color to be scored.
;Return Value: An integer, representing the total points earned by the player that has the provided stone color.
;Algorithm:
;              1) First, tally up all the points earned from five (or more) consecutive stones on the board (see ScoreFiveConsecutives). Call this function all four of
;                 the major directions (horizontal, vertical, main-diagonal, anti-diagonal). 
;              2) Extract the score earned, as well as the marked board (so that consecutive fives do not get recounted as conscecutive fours), from the returned values
;                 in Step 1.
;              3) Next, tally up all the points earned from four consecutive stones on the board. The marked board from step 2 is used so that consecutive fives
;                 do not accidently get recounted.
;              4) Last, sum up all of the scores earned from consecutive fives and consecutive fours with the number of captured pairs that player has. Return this sum
;                 as the scored earned by that player for the round.
;Assistance Received: None
(defun ScoreBoard (gameState color)
    
  ;To tally the score for a color, given a board state, the scores must be broken up into each major direction (horizontal, vertical, main-diagonal, anti-diagonal)
  ;This ensures that scores are accurate and tallied correctly, without accidently recounting anything.
  (let* ( (board (GetBoard gameState)) 
          ;Note: ScoreFiveConsecutives returns a list that contains (markedBoard, scoreEarned)
          (consecutive5_h (ScoreFiveConsecutives board (AllBoardLocations 0 0) color 0 1 0))
          (consecutive5Score_h (first (rest consecutive5_h)))
          (consecutive5_v (ScoreFiveConsecutives board (AllBoardLocations 0 0) color 1 0 0))
          (consecutive5Score_v (first (rest consecutive5_v)))
          (consecutive5_md (ScoreFiveConsecutives board (AllBoardLocations 0 0) color 1 1 0))
          (consecutive5Score_md (first (rest consecutive5_md)))
          (consecutive5_ad (ScoreFiveConsecutives board (AllBoardLocations 0 0) color 1 -1 0))
          (consecutive5Score_ad (first (rest consecutive5_ad)))
          ;The score from four consecutives in each direction uses the marked board for each direction, to ensure that "winning moves" do not get recounted.
          (consecutive4Score_h (ScoreFourConsecutives (first consecutive5_h) (GetSequencesInDirection (AllBoardLocations 0 0) 0 1 4) color)) 
          (consecutive4Score_v (ScoreFourConsecutives (first consecutive5_v) (GetSequencesInDirection (AllBoardLocations 0 0) 1 0 4) color)) 
          (consecutive4Score_md (ScoreFourConsecutives (first consecutive5_md) (GetSequencesInDirection (AllBoardLocations 0 0) 1 1 4) color)) 
          (consecutive4Score_ad (ScoreFourConsecutives (first consecutive5_ad) (GetSequencesInDirection (AllBoardLocations 0 0) 1 -1 4) color))
          ;Total scores are just the sums of the scores in each major direction for both the consecutive5 score and consecutive4 score.
          (consecutive5TotalScore (+ consecutive5Score_h consecutive5Score_v consecutive5Score_md consecutive5Score_ad)) 
          (consecutive4TotalScore (+ consecutive4Score_h consecutive4Score_v consecutive4Score_md consecutive4Score_ad)) )
      
      ;If the current player being scored is the human, add the human's captured pair count to the score.
      (cond ( (eq (GetHumanColor gameState) color)
              (+ consecutive5TotalScore consecutive4TotalScore (GetHumanCapturedPairs gameState)) )

            ;Otherwise, the current player being scored is the computer. Add the computer's captured pair count to the score. 
            (t
              (+ consecutive5TotalScore consecutive4TotalScore (GetComputerCapturedPairs gameState)) )
      )
  )
)

;Function Name: ScoreFiveConsecutives
;Purpose: To return the score earned from five consecutive stones in a specific direction, as well as the marked board (used for later processing).
;Parameters:
;              board, a list representing the current board of the game.
;              boardLocations, a list representing all valid board locations on the board.
;              color, a character representing the stone color to be scored.
;              rowChange, an integer representing the directional change applied to each row.
;              colChange, an integer representing the directional change applied to each column.
;              scoreEarned, an integer used to keep track of the score earned from five consecutives.
;Return Value: A list, containing the marked board and score earned in the format (marked board, score earned).
;Algorithm:
;              1) Recursively loop through each of the valid board locations.
;              2) For each board locations, find the maximum consecutive stone streak in the provided direction (rowChange, colChange).
;              3) If the maximum consecutive stone streak is greater than or equal to 5, mark the consecutive as seen (so that it never gets recounted),
;                 and recursively call this function with the marked board and the score incremented by 5.
;              4) Otherwise, continue searching the rest of the board locations.
;              5) Once all board locations have been searched, return a list containing the marked board and the score earned from five consecutive stones in
;                 the specific direction provided to this function.
;Assistance Received: None
(defun ScoreFiveConsecutives (board boardLocations color rowChange colChange scoreEarned)
    (cond ( (null boardLocations)
            (list board scoreEarned) )
            
          (t
            ;Find the number of consecutive stones from the current location going in the provided direction.
            (let* ( (consecutiveStones (MaxConsecutiveStones board (first boardLocations) color rowChange colChange)) )
                
                ;If the number of consecutive stones is greater than 5, mark the board (so it doesn't get recounted) and increment the score earned by 5.
                (cond ( (>= (length consecutiveStones) 5)
                        (ScoreFiveConsecutives (MarkBoard board consecutiveStones) (rest boardLocations) color rowChange colChange (+ 5 scoreEarned)) )
                        
                      ;Otherwise, continue searching through the board locations.
                      (t
                        (ScoreFiveConsecutives board (rest boardLocations) color rowChange colChange scoreEarned) )
                )
            ) )
        
    )
)

;Function Name: MaxConsecutiveStones
;Purpose: To find the maximum number of consecutive stones starting from "location" going in a specific direction.
;Parameters:
;              board, a list representing the current board of the game.
;              location, a list representing a location on the board in the form (row col).
;              color, a character representing the stone color to be searched for.
;              rowChange, an integer representing the directional change applied to each row.
;              colChange, an integer representing the directional change applied to each column.
;Return Value: A list, containing a sequence of locations of the longest consecutive stone streak. Ex: ((0 0) (0 1) ...)
;Algorithm:
;              1) Extract the row and column from "location".
;              2) Generate the next location in the direction provided to this function (rowChange colChange).
;              3) If there is a stone of the color being searched for at the current location being evaluated, and the location is valid, 
;                 add the location to the return list and recursively call this function and set the "location" parameter to the location generated in Step 2.
;              4) Once a location generated is not valid, OR the consecutive streak ends, return the list containing the sequence of locations.
;Assistance Received: None
(defun MaxConsecutiveStones (board location color rowChange colChange)
    ;Extract the row and column of the location being evaluated, and generate the next location.
    (let* ( (row (first location))
            (col (first (rest location)))
            (nextRow (+ row rowChange))
            (nextCol (+ col colChange)) 
            (nextLocation (list nextRow nextCol)) )
        
        ;The location being evaluated needs to be valid.
        (cond ( (not (ValidIndices row col))
                () )
                
              ;If the location is valid and there is the correct stone placed at the location, continue adding to the maximum streak found.
              ( (eq (At board row col) color)
                (cons (list row col) (MaxConsecutiveStones board nextLocation color rowChange colChange)) )
                
              ;Otherwise the streak is over and the longest streak found can be returned.
              (t
                () )
        )
        
    )
)

;Function Name: MarkBoard
;Purpose: To mark locations on a provided board with "S" to represent seen. Helper function used when scoring a board.
;Parameters:
;              board, a list representing the current board of the game.
;              boardLocations, a list representing the board locations that need to be marked.
;Return Value: A list, representing the updated board with the correct locations marked with an "S".
;Algorithm:
;              1) Recursively loop through each of the board locations that need to be marked.
;              2) Update the location with an "S" to represent it as seen.
;              3) Once all locations have been marked, return the marked board.
;Assistance Received: None
(defun MarkBoard (board boardLocations)
  ;Once all the locations are marked, return the marked board.
  (cond ( (null boardLocations)
          board )
        
        ;Update the location to be an S to represent marked. Then, using recursion, mark the rest of the locations.  
        (t
          (MarkBoard (UpdateBoard board (first (first boardLocations)) (first (rest (first boardLocations))) 'S) (rest boardLocations)) )
  )
)

;Scores all four consecutive stones of a given color. Returns the score earned.
;Function Name: ScoreFourConsecutives
;Purpose: To return the score earned from four consecutive stones in a specific direction.
;Parameters:
;              board, a list representing a marked board after all five or more consecutive stones have been scored to avoid recounting.
;              sequences, a list of sequences of locations of length four that needs to be checked for four consecutive stones.
;              color, a character representing the stone color to be scored.
;Return Value: An integer, representing the score earned for four consecutive stones in a specific direction.
;Algorithm:
;              1) Recursively loop through each of the sequences that need to be searched.
;              2) For each sequence, check if the number of stones placed in that sequence of locations is equal to four (see StoneCountInSequence).
;              3) If it is equal to four, return the result of recursively calling this function (to search the remaining sequences) with 1.
;              4) Otherwise, continue searching the rest of the sequences. Once all sequences have been checked, return the resulting sum.
;Assistance Received: None
(defun ScoreFourConsecutives (board sequences color)
  (cond ( (null sequences)
          0 )
          
        ( (= (StoneCountInSequence board color (first sequences)) 4)
          (+ (ScoreFourConsecutives board (rest sequences) color) 1) )
          
        (t
          (ScoreFourConsecutives board (rest sequences) color))
  )
)


;Function Name: UpdateScores
;Purpose: To update and display both the Human and Computer players' tournament score after a round is completed.
;Parameters:
;              gameState, a list representing the current game state list.
;Return Value: A list, representing the updated game list after each player's scores have been updated.
;Algorithm:
;              1) Update the Human's score.
;              2) Update the Computer's score.
;              3) Display the updated tournament scores to the screen and return the updated game state.
;Assistance Received: None
(defun UpdateScores (gameState)
  (let* ( (updatedHumanScore (+ (ScoreBoard gameState (GetHumanColor gameState)) (GetHumanScore gameState)))
          (updatedComputerScore (+ (ScoreBoard gameState (GetComputerColor gameState)) (GetComputerScore gameState)))
          (updatedGameState (SetComputerScore (SetHumanScore gameState updatedHumanScore) updatedComputerScore)) )
    
    ;Display the updated tournament scores.
    (princ "The updated Human player's tournament score is: ")
    (princ (GetHumanScore updatedGameState))
    (terpri)

    (princ "The updated Computer player's tournament score is: ")
    (princ (GetComputerScore updatedGameState))
    (terpri)
    (terpri)

    ;Return the updated game state with the scores correctly updated.
    updatedGameState
  )
)

;Function Name: SetHumanScore
;Purpose: To set the human score into the game state.
;Parameters:
;              gameState, a list representing the game state list that was read in from the file.
;              humanScore, an integer representing the score to set the Human's tournament score to.
;Return Value: A list, representing the updated game state with the new Human tournament score.
;Algorithm: None
;Assistance Received: None
(defun SetHumanScore(gameState humanScore)
  (cond ( (< humanScore 0) 
          (princ "Invalid human score!")
          gameState )

        (t
          (list (nth 0 gameState)
          (nth 1 gameState)
          humanScore        
          (nth 3 gameState)
          (nth 4 gameState)
          (nth 5 gameState)
          (nth 6 gameState) ) )
  )
)

;Function Name: SetComputerScore
;Purpose: To set the computer score into the game state.
;Parameters:
;              gameState, a list representing the game state list that was read in from the file.
;              computerScore, an integer representing the score to set the Computer's tournament score to.
;Return Value: A list, representing the updated game state with the new Computer tournament score.
;Algorithm: None
;Assistance Received: None
(defun SetComputerScore(gameState computerScore)
  (cond ( (< computerScore 0)
          (princ "Invalid computer score!")
          gameState )
        
        (t
          (list (nth 0 gameState)
          (nth 1 gameState)
          (nth 2 gameState)
          (nth 3 gameState)
          computerScore 
          (nth 5 gameState)
          (nth 6 gameState) ) )
  )
)

;Resets the round by setting the human and computer captured pair count to 0, and resetting the board back to being empty.
;Also reset the next player information - NextPlayer -> unknown, NextPlayerColor -> white.
;Function Name: ResetRound
;Purpose: To reset the gameState to be ready to play another round of Pente, if the user chooses to do so.
;Parameters:
;              gameState, a list representing the game state list that was read in from the file.
;Return Value: A list, representing the updated game state reset to be ready to play another round after tournament scores have been updated.
;Algorithm:
;              1) Set the Human and Computer player's captured pair count back to 0.
;              2) Set the board to an empty board.
;              3) Set the next player to "unknown" so that the first player is determined at the start of the new round.
;              4) Set the next player color to "W" since the player going first always plays with white stones.
;              5) Return the updated game state list.
;Assistance Received: None
(defun ResetRound (gameState)
  (SetNextPlayerColor (SetNextPlayer (SetBoard (SetComputerCapturedPairs (SetHumanCapturedPairs gameState 0) 0) (CreateBoard)) "unknown") 'W)
)