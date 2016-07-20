//
//  ViewController.swift
//  Real tic tac
//  Created by Nick L on 7/12/16.
//  Copyright © 2016 Nick L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cellOne: UIView!
    @IBOutlet var cellTwo: UIView!
    @IBOutlet var cellThree: UIView!
    @IBOutlet var cellFour: UIView!
    @IBOutlet var cellFive: UIView!
    @IBOutlet var cellSix: UIView!
    @IBOutlet var cellSeven: UIView!
    @IBOutlet var cellEight: UIView!
    @IBOutlet var cellNine: UIView!
    
    @IBOutlet var ticTacImg1: UIImageView!
    @IBOutlet var ticTacImg2: UIImageView!
    @IBOutlet var ticTacImg3: UIImageView!
    @IBOutlet var ticTacImg4: UIImageView!
    @IBOutlet var ticTacImg5: UIImageView!
    @IBOutlet var ticTacImg6: UIImageView!
    @IBOutlet var ticTacImg7: UIImageView!
    @IBOutlet var ticTacImg8: UIImageView!
    @IBOutlet var ticTacImg9: UIImageView!
    
    @IBOutlet var ticTacButton1: UIButton!
    @IBOutlet var ticTacButton2: UIButton!
    @IBOutlet var ticTacButton3: UIButton!
    @IBOutlet var ticTacButton4: UIButton!
    @IBOutlet var ticTacButton5: UIButton!
    @IBOutlet var ticTacButton6: UIButton!
    @IBOutlet var ticTacButton7: UIButton!
    @IBOutlet var ticTacButton8: UIButton!
    @IBOutlet var ticTacButton9: UIButton!
    
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var userMSG: UILabel!
    
    // dictionary of plays that have happened during game
    var plays =  Dictionary <Int, Int>()
    var done = false
    var aiDeciding = false
    
    // Resets the game
    @IBAction func resetButtonClicked(sender: UIButton) {
        done = false
        resetButton.hidden = true
        userMSG.hidden = true
        reset()
    }
    
    // Erases all images accross the board so a fresh game can start
    func reset() {
        plays = [:]
        ticTacImg1.image = nil
        ticTacImg2.image = nil
        ticTacImg3.image = nil
        ticTacImg4.image = nil
        ticTacImg5.image = nil
        ticTacImg6.image = nil
        ticTacImg7.image = nil
        ticTacImg8.image = nil
        ticTacImg9.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellOne.layer.borderWidth = 5
        cellTwo.layer.borderWidth = 5
        cellThree.layer.borderWidth = 5
        cellFour.layer.borderWidth = 5
        cellFive.layer.borderWidth = 5
        cellSix.layer.borderWidth = 5
        cellSeven.layer.borderWidth = 5
        cellEight.layer.borderWidth = 5
        cellNine.layer.borderWidth = 5
    }
    
    /*
     All algorithims that the AI uses to calculate where it is going to move
     These are all the possible win conditions for the game, it checks the value if it meets the condition
     */
    func checkBottom(value: Int) -> (location: String, pattern: String) {
        return ("bottom", checkFor(value, inList: [7, 8, 9]))
    }
    
    func checkMiddleAcross(value: Int) -> (location: String, pattern: String) {
        return ("middleHoriz", checkFor(value, inList: [4, 5, 6]))
    }
    
    func checkTop(value: Int) -> (location: String, pattern: String) {
        return ("top", checkFor(value, inList: [1, 2, 3]))
    }
    
    func checkLeft(value: Int) -> (location: String, pattern: String) {
        return ("left", checkFor(value, inList: [1, 4, 7]))
    }
    
    func checkMiddleDown(value: Int) -> (location: String, pattern: String) {
        return ("middleVertical", checkFor(value, inList: [2, 5, 8]))
    }
    
    func checkRight(value: Int) -> (location: String, pattern: String) {
        return ("right", checkFor(value, inList: [3, 6, 9]))
    }
    
    func checkDiagRightLeft(value: Int) -> (location: String, pattern: String) {
        return ("diagLeftRight", checkFor(value, inList: [3, 5, 7]))
    }
    
    func checkDiagLeftRight(value: Int) -> (location: String, pattern: String) {
        return ("diagRightLeft", checkFor(value, inList: [1, 5, 9]))
    }
    
    // checking for what spots have been played on the board
    func checkFor(value: Int, inList: [Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            } else {
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    //checks for what spots have not been played
    func rowCheck(value: Int) -> (location: String, pattern: String)?  {
        var acceptableFinds = ["011","110","101"]
        let findFuncts = [checkTop, checkBottom, checkLeft, checkRight, checkMiddleAcross, checkMiddleDown, checkDiagRightLeft, checkDiagLeftRight]
        // for each of the new algorthms created in find funcs to check if there are matches
        for algorthm in findFuncts {
            // this is the result of the algorithim. if in this case player 1 clicks, it loops through the algorithims and checks if one of the following conditions is true. If so, store algorthmResults
            let algorthmResults = algorthm(value)
            if acceptableFinds[0] == algorthmResults.pattern || acceptableFinds[1] == algorthmResults.pattern || acceptableFinds[2] == algorthmResults.pattern {
                return algorthmResults
            }
        }
        return nil
    }
    
    //if the spot is not occupied by an image, it is passed as a playable spot to the AI
    func isOccupied(spot: Int) -> Bool  {
        return plays[spot] != nil
    }
    
    // All operations of AI inside here
    func aiTurn()  {
        print("a")
        if done {
            return
        }
        aiDeciding = true
        
        // IF THE AI HAS TWO IN A ROW this function handles next AI turn and goes for one of the win conditions based on spots played and available
        if let result = rowCheck(0) {
            var whereToPlayResult = whereToPlay(result.location, pattern: result.pattern)
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        
        // IF THE PLAYER HAS TWO IN A ROW This function handles next AI turn and tries to block the player based on position on grid
        
        if let result = rowCheck(1) {
            var whereToPlayResult = whereToPlay(result.location, pattern: result.pattern)
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        
        //checks if the middle is available. If available, AI will always go middle
        if !isOccupied(5) {
            setImageForSpot(5, player:0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        // searches for the first available spot the AI can play
        func firstAvailable (isCorner: Bool) -> Int? {
            let spots = isCorner ? [1,3,7,9] : [2,4,6,8]
            for spot in spots {
                if !isOccupied(spot) {
                    return spot
                }
                
            }
            return nil
        }
        
        // checks if one of the corners are available based on spots played
        if let cornerAvailable = firstAvailable(true) {
            setImageForSpot(cornerAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        //checks if side is available based on spots played
        if let sideAvailable = firstAvailable(false) {
            setImageForSpot(sideAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMSG.hidden = false
        userMSG.text = "looks like it was a tie"
        
        reset()
        
        aiDeciding = false
    }
    
    // chooses where the AI plays based on location and pattern of cells in the switch statement
    func whereToPlay(location: String, pattern: String) -> Int {
        let leftPattern = "011"
        let rightPattern = "110"
        switch location {
        case "top":
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 3
            } else {
                return 2
            }
            
        case "bottom":
            if pattern == leftPattern {
                return 7
            } else if pattern == rightPattern {
                return 9
            } else {
                return 8
            }
            
        case "left":
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 7
            } else {
                return 4
            }
            
        case "right":
            if pattern == leftPattern {
                return 3
            } else if pattern == rightPattern {
                return 9
            } else {
                return 6
            }
            
        case "middleVert":
            if pattern == leftPattern {
                return 2
            } else if pattern == rightPattern {
                return 8
            } else {
                return 5
            }
            
        case "middleHorz":
            if pattern == leftPattern {
                return 4
            } else if pattern == rightPattern {
                return 6
            } else {
                return 5
            }
            
        case "diagRightLeft":
            if pattern == leftPattern {
                return 3
            } else if pattern == rightPattern {
                return 7
            } else {
                return 5
            }
            
        case "diagLeftRight":
            if pattern == leftPattern {
                return 1
            } else if pattern == rightPattern {
                return 9
            } else {
                return 5
            }
            
        default: return 4
        }
    }
    
    // Check who won and print corresponding message
    func checkForWin() {
        let whoWon = ["I": 0, "you": 1]
        for (key, value) in whoWon {
            if (plays[7] == value && plays[8] == value && plays[9] == value) ||
                (plays[4] == value && plays[5] == value && plays[6] == value) ||
                (plays[1] == value && plays[2] == value && plays[3] == value) ||
                (plays[1] == value && plays[4] == value && plays[7] == value) ||
                (plays[2] == value && plays[5] == value && plays[8] == value) ||
                (plays[3] == value && plays[6] == value && plays[9] == value) ||
                (plays[1] == value && plays[5] == value && plays[9] == value) ||
                (plays[3] == value && plays[5] == value && plays[7] == value) {
                userMSG.hidden = false
                userMSG.text = "Looks like \(key) won America is Doomed!"
                resetButton.hidden = false
                done = true
            }
        }
    }
    
    // This registers that a user clicked a button on the grid
    @IBAction func UIButtonClicked(sender:UIButton) {
        userMSG.hidden = true
        if (plays[sender.tag] == nil && !aiDeciding && !done) {
            setImageForSpot(sender.tag, player: 1)
            
            checkForWin()
            aiTurn()
        }
    }
    
    //sets the image for the spot the user clicked or AI plays, the  player will always be "Trump"
    func setImageForSpot(spot: Int, player: Int) {
        let playermark = player == 1 ? "Trump" : "Hillary"
        plays[spot] = player
        switch spot {
        case 1:
            ticTacImg1.image = UIImage(named: playermark)
            
        case 2:
            ticTacImg2.image = UIImage(named: playermark)
            
        case 3:
            ticTacImg3.image = UIImage(named: playermark)
            
        case 4:
            ticTacImg4.image = UIImage(named: playermark)
            
        case 5:
            ticTacImg5.image = UIImage(named: playermark)
            
        case 6:
            ticTacImg6.image = UIImage(named: playermark)
            
        case 7:
            ticTacImg7.image = UIImage(named: playermark)
            
        case 8:
            ticTacImg8.image = UIImage(named: playermark)
            
        case 9:
            ticTacImg9.image = UIImage(named: playermark)
            
        default:
            ticTacImg5.image = UIImage(named: playermark)
        }
    }
}
