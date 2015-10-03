//
//  ViewController.swift
//  WitAI
//
//  Created by Julian Abentheuer on 10.01.15.
//  Copyright (c) 2015 Alexandra and Steve. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WitDelegate {
    
    @IBOutlet weak var labelView2: UILabel!
    
    
    //-------- cards views ------------------
    
    @IBOutlet var CardCollection: [UIImageView]!
    
    
    @IBOutlet weak var ImageView1: UIImageView!
    @IBOutlet weak var ImageView2: UIImageView!
    @IBOutlet weak var ImageView3: UIImageView!
    @IBOutlet weak var ImageView4: UIImageView!
    @IBOutlet weak var ImageView5: UIImageView!
    @IBOutlet weak var ImageView6: UIImageView!
    @IBOutlet weak var ImageView7: UIImageView!
    @IBOutlet weak var ImageView8: UIImageView!

    
    //--- end of card views -------------------
    
    
    
    
    
    //var labelView : UILabel?
    var witButton : WITMicButton?
    
    var cardsName = ["ace", "two","three","four","five","six","seven","eight","nine","ten","jack","queen","king"]
    var cardsValue = ["11","2","3","4","5","6","7","8","9","10","10","10","10"]
    var cardsSuit = ["diamonds", "clubs", "hearts", "spades"]
    var game = false
    
    var deck = [[String]]()
    var playerhand = [[String]]()
    var playerValue = 0
    
    var computerhand = [[String]]()
    var computerValue = 0
    var text = ""
    
    func buildDeck() {
        deck = []
        
        for (var i = 0; i < cardsName.count; i++){
            for (var j = 0; j < cardsSuit.count; j++){
                
                let card = [cardsName[i], cardsSuit[j], cardsValue[i]]
                deck.append(card)
                
            }
            
        }
        
    }
    //helper function to shuffle the deck
    func shuffleDeck(){
        for(var i = 0; i<20000; i++){
            let random = Int(arc4random_uniform(52))
            let random2 = Int(arc4random_uniform(52))
            
            let temp = deck[random]
            deck[random] = deck[random2]
            deck[random2] = temp
            
        }
    }
    
    //helper function to return a card
    func dealCard() -> [String]{
        
        let pop = deck.removeAtIndex(Int(0))
        
        
        return pop
        
    }
    
    func startGame() {
        
        buildDeck()
        shuffleDeck()

        playerhand = []
        computerhand = []
        
        playerhand.append(dealCard())
        playerhand.append(dealCard())
        
        
        calculateValue()
        
        if (playerValue == 21){
            blackJack()
        }
        
        computerhand.append(dealCard())
        
        print(playerhand)
        print(computerhand)
        
        showCards()
        

    }
    
    func blackJack(){
       
        text = " You were dealt "
        
        for (var i = 0; i < playerhand.count; i++)
        {
            text += playerhand[i][0] + " of " + playerhand[i][1] + ", "
        }
        
        text += " You have blackjack You win!"
        game = false;
    }
    
    func playerHand(){
        print(playerhand)
        
         text += " Your hand is "
        
        for (var i = 0; i < playerhand.count; i++)
        {
            text += playerhand[i][0] + " of " + playerhand[i][1] + ", "
        }
        calculateValue()
        text += ". The total value is " + String(playerValue)
        
        
        
    }
    func computerHand(){
        text += "The computer's hand is " + computerhand[0][0] + " of " + computerhand[0][1] +  " "
        
    }
    
    
    func calculateValue(){
        playerValue = 0
        for (var i = 0; i < playerhand.count; i++){
            playerValue += Int(playerhand[i][2])!
            
            
        }
        if (playerValue > 21){
            for (var i = 0; i < playerhand.count; i++){
                if (playerhand[i][0] == "Ace"){
                    playerValue -= 10
                }
            }
        }
    }
    func calculateCompValue(){
        computerValue = 0
        for (var i = 0; i < computerhand.count; i++){
            computerValue += Int(computerhand[i][2])!
            
        }
        if (computerValue > 21){
            for (var i = 0; i < computerhand.count; i++){
                if (computerhand[i][0] == "Ace"){
                    computerValue -= 10
                }
            }
        }
    }
    
    func hit(){
        if (playerValue < 21 && playerValue > 0)
        {
            playerhand.append(dealCard())
            calculateValue()
            
        }

        
        
    }
    func stay(){
        text = ""
        computerHand()
        
        text += " The computer was dealt "
        while (computerValue < 18){
            computerhand.append(dealCard())
            calculateCompValue()
            
            text += " a " + computerhand[computerhand.count-1][0]
            text += " of " + computerhand[computerhand.count-1][1]
        
        }
        
        //print(text)
        

        
        
        checkCompWin()
        
    }

    
    func checkCompWin(){
        
        calculateValue()
        calculateCompValue()
        text += " Your total value is " + String(playerValue) + " The computer's value is " + String(computerValue)
        
        if (computerValue > 21){
            text += " The computer has busted"
        }
        else if (computerValue < playerValue){
           text += " You win"
        }
        else if (playerValue < computerValue){
           text += " You have lost"
        }
        else if (playerValue == computerValue){
           text += " It was a draw"
        }
        
        
    }
    func showCards(){
        for ( var i = 0; i < 8; i++)
        {
            CardCollection[i].image = nil
        }
        
        
        for ( var i = 0; i < playerhand.count; i++){
            
            let string = playerhand[i][0] + " " + playerhand[i][1] + ".png"
            print(string)
            let card = UIImage(named: string)
            CardCollection[i].image = card
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "background.jpg")
        view.backgroundColor = UIColor(patternImage: image!)
        labelView2.textColor = UIColor.whiteColor()
        labelView2.font = labelView2.font.fontWithSize(30)
    
        
        // set the WitDelegate object
        Wit.sharedInstance().delegate = self
        
        // create the button
        let screen : CGRect = UIScreen.mainScreen().bounds
        let w : CGFloat = 100
        let rect : CGRect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100)
        
        witButton = WITMicButton(frame: rect)
        self.view.addSubview(witButton!)
        
        
        //startGame()

    }
        
        func witDidGraspIntent(outcomes: [AnyObject]!, messageId: String!, customData: AnyObject!, error e: NSError!) {
        if ((e) != nil) {
            print("\(e.localizedDescription)")
            return
        }
        
        let outcomes : NSArray = outcomes!
        let firstOutcome : NSDictionary = outcomes.objectAtIndex(0) as! NSDictionary
        let intent : String = firstOutcome.objectForKey("intent")as! String
        labelView2.text = intent
        
        print(intent);
        
        if (intent == "bet") {
            //betAmount();
        }
        
        if (intent == "show_my_hand") {
            text = ""
            playerHand()
            Speech(text)
            
           
        }
        if (intent == "start_game") {
            if (game == false){
                game = true
                text = ""
                startGame()
                playerHand()
                computerHand()
            
            if (playerValue != 21){
                Speech(text)
            }
            } else {
                Speech("There is already a current game. To hear your hand say Player Hand, to hear the computer's hand say computer hand")
            }
            
            
        }
        if( intent == "draw") {
            if (game == true){
                hit()
                text = "You were dealt " + playerhand[playerhand.count-1][0] + " of " + playerhand[playerhand.count-1][1]
                
                calculateValue()
                if (playerValue > 21)
                {
                    text += " Your total is " + String(playerValue) + " You have busted You lose"
                    game = false
                }
                else
                {
                    text += " Your total is " + String(playerValue)
                }
            
            showCards()
            
            }
            else
            {
                Speech("You cannot Hit. Please start a new game by Saying New game")
            }
            
            //print(text)
            Speech(text)
            
            
            }
        if (intent == "stand") {
            if (game == true)
            {
                text = ""
                stay()
                print(text)
                game = false
                Speech(text)
            }
            else
            {
                Speech("You cannot Stay. Please start a new game by Saying New game")
            }
            
        }
        if (intent == "computer_s_hand") {
            text = ""
            computerHand()
            Speech(text)
            
        }
    
        
    }
    
    //---text to speech -----///
    
    var currentlanguage = "en-AU"
    

    func Speech(Thing: String) {
        let string = Thing
        let utterance = AVSpeechUtterance(string: string)
        
        
        utterance.voice = AVSpeechSynthesisVoice(language: currentlanguage)
        utterance.rate = 0.1
        utterance.volume = 1.0
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
        view.endEditing(true)
        
    }

    
    func betAmount() {
        //        let string = customText.text!
        let string = "You have just bet 50 gold coins"
        let utterance = AVSpeechUtterance(string: string)
        
        utterance.voice = AVSpeechSynthesisVoice(language: currentlanguage)
        utterance.rate = 0.1
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
        view.endEditing(true)
        
    }
    
    //---text to speech -----///
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

