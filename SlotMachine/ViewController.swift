//
//  ViewController.swift
//  SlotMachine
//
//  Created by Ben Blanchard on 06/02/2015.
//  Copyright (c) 2015 Ben Blanchard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    var titleLabel: UILabel!
    
    // Information Labels
    var creditsLabel:UILabel!
    var betLabel:UILabel!
    var winnerPaidLabel:UILabel!
    var creditsTitleLabel:UILabel!
    var betTitleLabel:UILabel!
    var winnerPaidTitleLabel:UILabel!
    //
    
    // buttons in fourthContainer
    var resetButton:UIButton!
    var betOneButton:UIButton!
    var betMaxButton:UIButton!
    var spinButton:UIButton!
    //
    
    let kMarginForView:CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0
    let kSixth:CGFloat = 1.0/6.0
    let kNumberOfColumns = 3
    let kNumberOfRows = 3
    let kThird:CGFloat = 1.0/3.0
    let kHalf:CGFloat = 1.0/2.0
    let kEigth:CGFloat = 1.0/8.0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupContainerViews()
        setupFirstContainer(firstContainer)
        setupThirdContainer(thirdContainer)
        setupFourthContainer(fourthContainer)
        hardReset()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var board:[[Card]] = []
    
    //Stats
    var credits = 0.0
    var currentBet = 0.0
    var winnings = 0.0

    // IBActions
    func resetButtonPressed(button:UIButton) {
        println("resetButton Pressed")
        hardReset()
    }
    func betOneButtonPressed(button:UIButton) {
        println("betOneButton Pressed")
        
        if credits <= 0 {
            showAlertWithText(header: "No more credits!", message: "Reset game")
        }
        else {
            if currentBet < 5 {
                currentBet += 1
                credits -= 1
                updateLabels()
            }
            else {
                showAlertWithText(message:"You can only bet 5 credits at a time")
            
            }
        }
        
    }
    func betMaxButtonPressed(button:UIButton) {
        if credits <= 5 {
            showAlertWithText(header: "Not enough credits", message: "Bet less")
        } else {
            if currentBet < 5 {
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateLabels()
            } else {
                showAlertWithText(message: "You can only bet 5 credits at a time")
            }
        }
    }

    func spinButtonPressed(button:UIButton) {
        removeCardImageViews()
        println("spinButton")
        board = Factory.createCards()
        setupSecondContainer(self.secondContainer)
        var winningsMultiplier = GameBrain.computeWinnings(board)
        

        winnings = currentBet * Double(winningsMultiplier)
        credits += winnings
        currentBet = 0
        updateLabels()
    }
    //
    
    
    
    func setupContainerViews() {
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.firstContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height:  self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height, width: self.view.bounds.width - (kMarginForView  * 2), height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
        
    }
    
    
    func setupFirstContainer(containerView:UIView) {
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots!"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(titleLabel)
    }
    
    func setupSecondContainer(containerView:UIView) {
        for var columnNumber = 0; columnNumber < kNumberOfColumns; ++columnNumber {
            for var rowNumber = 0; rowNumber < kNumberOfRows; ++rowNumber {
                
                var card:Card
                var cardImageView = UIImageView()
                
                if board.count != 0 {
                    card = board[columnNumber][rowNumber]
                    cardImageView.image = card.image
                }
                else {
                    cardImageView.image = UIImage(named:"Ace")
                }
                

                cardImageView.backgroundColor = UIColor.yellowColor()
                cardImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(columnNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(rowNumber) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(cardImageView)
            }
        }
        
        
    }
    
    func setupThirdContainer(containerView:UIView) {
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.redColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
        self.creditsLabel.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(creditsLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird * 2)
        self.creditsTitleLabel.textAlignment = NSTextAlignment.Center
        self.creditsTitleLabel.backgroundColor = UIColor.greenColor()
        containerView.addSubview(creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird * 2)
        self.betTitleLabel.textAlignment = NSTextAlignment.Center
        self.betTitleLabel.backgroundColor = UIColor.greenColor()
        containerView.addSubview(betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypeWriter", size: 14)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird * 2)
        self.winnerPaidTitleLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidTitleLabel.backgroundColor = UIColor.greenColor()
        containerView.addSubview(winnerPaidTitleLabel)
        
    }
    
    func setupFourthContainer(containerView:UIView) {
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEigth, y: containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.lightGrayColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEigth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.lightGrayColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * 5 * kEigth, y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.lightGrayColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEigth, y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(spinButton)
    }
    
    
    func removeCardImageViews() {
        if self.secondContainer != nil {
            let container: UIView? = self.secondContainer
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeCardImageViews()
        board.removeAll(keepCapacity: true)
        self.setupSecondContainer(secondContainer)
        credits = 50.0
        winnings = 0.0
        currentBet = 0.0
        updateLabels()
    }
    
    func updateLabels() {
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertWithText(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}


