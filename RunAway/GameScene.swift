//
//  GameScene.swift
//  RunAway
//
//  Created by Nityam Shrestha on 7/18/16.
//  Copyright (c) 2016 nityamshrestha.com. All rights reserved.
//

import SpriteKit
import Foundation

enum State{
    case Active, Paused, GameOver, LanternGlow
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var gameState:State = .Active
    var groundScroll: SKNode!
    var cloudScroll: SKNode!
    var backScroll: SKNode!
    var hero: SKSpriteNode!
    var ghost: SKSpriteNode!
    
    // background effect
    var backPart1: SKSpriteNode!
    var backPart2: SKSpriteNode!
    var backPart3: SKSpriteNode!
    var backPart4: SKSpriteNode!
    var backPart5: SKSpriteNode!
    var backPart6: SKSpriteNode!
    var backPart7: SKSpriteNode!
    var backPart8: SKSpriteNode!
    var backPart9: SKSpriteNode!
    var backPart10: SKSpriteNode!
    var backPart11: SKSpriteNode!
    var backPart12: SKSpriteNode!
    var backPart13: SKSpriteNode!
    var backPart14: SKSpriteNode!
    
    var potionSpawnTimer: CFTimeInterval = 0
    var pitSpawnTimer: CFTimeInterval = 0
    var lanternSpawnTimer: CFTimeInterval = 0
    var ghostSpawnTimer: CFTimeInterval = -5
    var boostSpawnTimer: CFTimeInterval = 0
    var generalLanternTimeCounter:CFTimeInterval = 19
    
    var originalGravity:CGFloat!
    
    let ghostOriginalPos:CGPoint = CGPoint(x: -54, y: 89.963)
    
    var myBox:SKSpriteNode!
    
    var potion:Int = 0
    var jumpImpulse:CGFloat = 18
    // var superLanternRectangle: CGRect
    var lamp1:SKNode!
    var lamp2:SKNode!
    var lamp3:SKNode!
    var lamp4:SKNode!
    var light1: SKLightNode!
    var light2: SKLightNode!
    
    var scrollSpeed:CGFloat = 230
    var backSpeed: CGFloat = 0
    var cloudSpeed: CGFloat = 0
    
    var fixedDelta: CFTimeInterval = 1.0/60.0  // 60 FPS
    var lastLanternTime: CFTimeInterval = 0
    
    var score: Int = 1
    var scoreCounter = 0
    var scoreLabel:SKLabelNode!
    var speedLabel: SKLabelNode!
    
    var isAtGround: Bool = true
    var tempLabel: SKLabelNode?
    
    var gameReset:SKAction!
    //  var ambientColor: UIColor?
    
    override func didMoveToView(view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        groundScroll = self.childNodeWithName("groundScroll")
        cloudScroll = self.childNodeWithName("cloudScroll")
        backScroll = self.childNodeWithName("backScroll")
        
        lamp1 = self.childNodeWithName("lamp1")
        lamp2 = self.childNodeWithName("lamp2")
        lamp3 = self.childNodeWithName("lamp3")
        lamp4 = self.childNodeWithName("lamp4")
        light1 = self.childNodeWithName("light1") as! SKLightNode
        light2 = self.childNodeWithName("light2") as! SKLightNode
        
        
        hero = self.childNodeWithName("//hero") as! SKSpriteNode
        ghost = self.childNodeWithName("//ghost") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        speedLabel = self.childNodeWithName("speedLabel") as! SKLabelNode
        
        // background color effects
        backPart1 = self.childNodeWithName("part1") as! SKSpriteNode
        backPart2 = self.childNodeWithName("part2") as! SKSpriteNode
        backPart3 = self.childNodeWithName("part3") as! SKSpriteNode
        backPart4 = self.childNodeWithName("part4") as! SKSpriteNode
        backPart5 = self.childNodeWithName("part5") as! SKSpriteNode
        backPart6 = self.childNodeWithName("part6") as! SKSpriteNode
        backPart7 = self.childNodeWithName("part7") as! SKSpriteNode
        backPart8 = self.childNodeWithName("part8") as! SKSpriteNode
        backPart9 = self.childNodeWithName("part9") as! SKSpriteNode
        backPart10 = self.childNodeWithName("part10") as! SKSpriteNode
        backPart11 = self.childNodeWithName("part11") as! SKSpriteNode
        backPart12 = self.childNodeWithName("part12") as! SKSpriteNode
        backPart13 = self.childNodeWithName("part13") as! SKSpriteNode
        backPart14 = self.childNodeWithName("part14") as! SKSpriteNode
//        
//        backPart1.zPosition = 0
//        backPart2.zPosition = 0
//        backPart3.zPosition = 0
//        backPart4.zPosition = 0
//        backPart5.zPosition = 0
//        backPart6.zPosition = 0
//        backPart7.zPosition = 0
//        backPart8.zPosition = 0
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
         gameReset = SKAction.runBlock({
            let skView = self.view as SKView!
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene!
         //   scene.highscore = self.score
            scene.scaleMode = .AspectFit
            
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            skView.presentScene(scene)
        })
        //    ambientColor = UIColor.darkGrayColor()
        initSprite()
        initLight()
        
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("Swipped Right here")
    }
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("Swipped Left here")
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if hero.xScale < 1
        {
            restoreActions()
        }
        else
        {
            heroJump()
        }
        print("up swipe here")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer)
    {
        heroSlide()
        print("Down swipped")
    }
    
    func restoreActions()
    {
        print("restored")
        hero.paused = false
        hero.yScale = 1
        hero.xScale = 1
    }
    
    func heroSlide()
    {
        hero.paused = true
        hero.texture =  SKTexture(imageNamed: "punkSlide")
        hero.xScale = 0.4
        hero.yScale = 0.4
        
        print("hero texture changed")
    }
    
    func heroSizeReset()
    {
        hero.xScale = 1
        hero.yScale = 1
        
    }
    func initSprite(){
        
    }
    func initLight()
    {
        //www.codeandweb.com/spriteilluminator/tutorials/spritekit-dynamic-light-tutorial
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches
        {
            if gameState == .GameOver
            {
                self.runAction(gameReset)
            }
            
            if gameState == .Active
            {
                heroPowerUp()
                
                if potion >= 12
                {
                    let pt = touch.locationInNode(self)
                    if(nodeAtPoint(pt).name == "lamp1"||nodeAtPoint(pt).name == "lamp2"||nodeAtPoint(pt).name == "lamp3"||nodeAtPoint(pt).name == "lamp4")
                    {
                        // print("Super Lanter Power up")
                        heroPowerUp()
                        potion = 0
                    }
                }
                //heroSlide()
            }
        }
    }
    
    func heroJump()
    {
        if(isAtGround)
        {
            hero.physicsBody?.applyImpulse(CGVectorMake(0, jumpImpulse))
            hero.paused = true;
            isAtGround = false
        }
    }
    
    func lightsDrama(x: Int)
    {
        switch x {
        case 1:
            backPart1.runAction(SKAction.fadeOutWithDuration(2))
        case 2:
            backPart2.runAction(SKAction.fadeOutWithDuration(2))
        case 3:
            backPart3.runAction(SKAction.fadeOutWithDuration(2))
        case 4:
            backPart4.runAction(SKAction.fadeOutWithDuration(2))
        case 5:
            backPart5.runAction(SKAction.fadeOutWithDuration(2))
        case 6:
            backPart6.runAction(SKAction.fadeOutWithDuration(2))
        case 7:
            backPart7.runAction(SKAction.fadeOutWithDuration(2))
        case 8:
            backPart8.runAction(SKAction.fadeOutWithDuration(2))
        case 9:
            backPart9.runAction(SKAction.fadeOutWithDuration(2))
        case 10:
            backPart10.runAction(SKAction.fadeOutWithDuration(2))
        case 11:
            backPart11.runAction(SKAction.fadeOutWithDuration(2))
        case 12:
            backPart12.runAction(SKAction.fadeOutWithDuration(2))
        case 13:
            backPart13.runAction(SKAction.fadeOutWithDuration(2))
        case 14:
            backPart14.runAction(SKAction.fadeOutWithDuration(2))
        default:
            return
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if gameState == .GameOver{
            hero.removeAllActions()
            groundScroll.removeAllActions()
            cloudScroll.removeAllActions()
            backScroll.removeAllActions()
            hero.removeFromParent()
            
            let resourchPath = NSBundle.mainBundle().pathForResource("TempLabel", ofType: "sks")
                let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
                box.position = CGPoint(x: 100, y: 100)
                self.addChild(box)
                
                return
        }
        
        if gameState == .Active{
            
            if ghost.position.x > 382
            {
               // lightsDrama(14)
            }
//            else if ghost.position.x > 361
//            {
//                lightsDrama(13)
//            }
//            else if ghost.position.x > 340
//            {
//                lightsDrama(12)
//            }
            else if ghost.position.x > 319
            {
                lightsDrama(11)
            }else if ghost.position.x > 298
            {
                lightsDrama(10)
            }
            else if ghost.position.x > 277
            {
                lightsDrama(9)
            }else if ghost.position.x > 256
            {
                lightsDrama(8)
            }
            else if ghost.position.x > 235
            {
                lightsDrama(7)
            }
            else if ghost.position.x > 214
            {
                lightsDrama(6)
            }
            else if ghost.position.x > 193
            {
                lightsDrama(5)
            }else if ghost.position.x > 172
            {
                lightsDrama(4)
            }
            else if ghost.position.x > 151
            {
                lightsDrama(3)
            }else if ghost.position.x > 130
            {
                lightsDrama(2)
            }
            else if ghost.position.x > 109
            {
                lightsDrama(1)
            }
            else
            {//do nothing
            }
            
            if potion >= 12
            {
                lamp1.zPosition = 3
                
            } else if potion >= 9
            {
                lamp2.zPosition = 3
            } else if potion >= 6
            {
                lamp3.zPosition = 3
            } else if potion >= 3
            {
                lamp4.zPosition = 3
            }else
            {
                lamp1.zPosition = -2
                lamp2.zPosition = -2
                lamp3.zPosition = -2
                lamp4.zPosition = -2
                
            }
            
            
            
            if (score % 97 == 0 && scrollSpeed < 800)
            {
                //   print(scrollSpeed)
                scrollSpeed += 65
                //   print(scrollSpeed)
                print("")
                score += 1
            }
            scoreLabel.text = String(score)
            speedLabel.text = String (scrollSpeed)   // printing speed
            
            //    if hero.position.x < -200
            if hero.parent?.position.x < -20
            {
                gameState = .GameOver
                return;
            }
            
            //   if hero.position.x > 30
            if hero.parent?.position.x > 300 // make this dynamic screen size
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! - 100, duration: 1)
                hero.runAction(heroLimit)
            }
            
            if scoreCounter % 31 == 0
            {
                score += 1
                //  print("Score: \(score)")
            }
            
            if scoreCounter % 79 == 0
            {
                let randomNumber = Int(arc4random_uniform(UInt32(18)))
                //  print("Number of boxes: \(randomNumber)")
                
                //  let randomNumber = 18
                
                if randomNumber >= 16
                {
                    addBox(4)
                }
                else if randomNumber >= 13
                {
                    addBox(3)
                }
                else if randomNumber >= 8{
                    addBox(2)
                }else if randomNumber >= 0{
                    addBox(1)
                }else{
                    //do nothing
                }
                
            }
            
            updateGroundScroll()
            updateCloudScroll()
            updateBackScroll()
            updateObstacles()
            
            scoreCounter += 1
        }
    }
    
    //    func timerAction()
    //    {
    //        counter += 1
    //        print("counter \(counter)")
    //    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        if (contactA.node == nil || contactB.node == nil)
        {
            return
        }
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "box" || nodeB.name == "box"
        {
            //            if (counter > 10)
            //            {
            //                counter = 0
            //                timer?.invalidate()
            //                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            //                timer?.fire()
            //                hero.paused = false
            //                isAtGround = true
            //                }
            isAtGround = true;
            hero.paused = false
            return
        }
        
        if nodeA.name == "pressurePoint" || nodeB.name == "pressurePoint"
        {
            
            //print("presure point hit")
            isAtGround = true;
            hero.paused = false
            return
            
        }
        
        if nodeA.name == "ground" || nodeB.name == "ground"
        {
            //    print("ground")
            
            isAtGround = true;
            if hero.xScale < 1
            {
                return
            }else{
                hero.paused = false
            }
            return
            
        }
        
        if nodeA.name == "jumpNode" || nodeB.name == "jumpNode"
        {
            //   hero.removeActionForKey("hero limit")
            isAtGround = true;
            hero.paused = false;
            return
        }
        
        if nodeA.name == "lantern" || nodeB.name == "lantern"
        {
            heroPowerUp()                       // powerUp Effects
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
        }
        
        if nodeA.name == "monster" || nodeB.name == "monster"
        {
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
        }
        
        if nodeA.name == "potion" || nodeB.name == "potion"
        {
            potion += 1
            
            if hero.parent?.position.x < 200
            {
                let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! + 10, duration: 1.5)
                hero.runAction(heroLimit, withKey: "hero limit")
            }
            
            print("potion collected: \(potion)")
            
            if  nodeA.name != "hero"
            {
                nodeA.removeFromParent()
            }
            else
            {
                nodeB.removeFromParent()
            }
            
        }
        
        if nodeA.name == "ghost" || nodeB.name == "ghost"
        {
            gameState = .GameOver
            return
        }
        
    }
    
    /*
     @param: that decideds the reward brightness of the gameplay
     */
    func heroPowerUp()
    {
        
        // add effects of bright glow
        // world brightness = current.brightness + 30, not fully bright, i.e done by superLantern
        
        /* Effects #1 */
        // world pause
        hero.paused = true
        hero.physicsBody?.dynamic = false
        hero.physicsBody?.affectedByGravity = false
        
        gameState = .LanternGlow
        light1.falloff = -1
        light2.falloff = -1
        
        let pauseTime = SKAction.waitForDuration(2)
        let unpause = SKAction.performSelector(#selector(resume), onTarget: self)
        let stepSequence = SKAction.sequence([pauseTime, unpause])
        self.runAction(stepSequence)
        
        
        /* Effects #2 */
        ghostReset()
        
        /* Effects #3 */
        obstacleDisappear()
        
        //     heroBoost()
        
    }
    func resume()
    {
        hero.paused = false
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.affectedByGravity = true
        if hero.parent?.position.x < 200
        {
            let heroLimit =  SKAction.moveToX((hero.parent?.position.x)! + 50, duration: 1)
            hero.runAction(heroLimit)
        }
        //  physicsWorld.gravity.dx = originalGravity
        gameState = .Active
    }
    
    func ghostReset()
    {
        let ghostreset = SKAction.moveTo(ghostOriginalPos, duration: 2.5)
        ghost.runAction(ghostreset)
        ghost.removeActionForKey("creepIn")
        
        ghostSpawnTimer = -5
        light1.falloff -= 0.5
        light2.falloff -= 0.5
        
        backPart6.runAction(SKAction.fadeInWithDuration(2))
        backPart5.runAction(SKAction.fadeInWithDuration(2))
        backPart3.runAction(SKAction.fadeInWithDuration(2))
        backPart2.runAction(SKAction.fadeInWithDuration(2))
        backPart1.runAction(SKAction.fadeInWithDuration(2))
        
        
        
    }
    
    func ghostCreepIn()
    {
        let creepIn = SKAction.moveToX(CGFloat(800), duration:80)
        ghost.runAction(creepIn, withKey: "creepIn")
        //ghost.physicsBody?.applyImpulse(CGVectorMake(1, 0))
    }
    
    func obstacleDisappear()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for node in groundScroll.children
        {
            
            if let _ = node as? SKSpriteNode
            {
                "do nothing"
            }else
            {
                let obstacleFadeOut = SKAction.fadeOutWithDuration(0.9)
                let obstacleRemove = SKAction.removeFromParent()
                let disappearSequence = SKAction.sequence([obstacleFadeOut, obstacleRemove])
                // may need to repeat disappearSequence
                node.runAction(disappearSequence)
            }
        }
        //spawnTimer = 0
        pitSpawnTimer = 5
        lanternSpawnTimer = 0
    }
    
    
    func updateObstacles()
    {
        for elements in groundScroll.children
        {
            if elements.position.x < -5
            {
                elements.removeFromParent()
            }
        }
        if ghostSpawnTimer > 2  //ghost Spawn
        {
            print("Ghost Move: \(ghost.position.x)")
            ghostCreepIn()
            //  print("Ghost After Move \(ghost.position.x)")
            ghostSpawnTimer = 0
        }
        
        /*
         if pitSpawnTimer > 17     //pit Spawn
         {
         let resourchPath = NSBundle.mainBundle().pathForResource("Pit", ofType: "sks")
         let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
         box.position = self.convertPoint(CGPoint(x: 600, y: 56), toNode: groundScroll)
         groundScroll.addChild(box)
         //  print("pit")
         pitSpawnTimer = 0
         return
         
         }
         */
        if potion < 12              // i.e, if SuperLantern is complete no more potions
        {
            if potionSpawnTimer > 4       //potions spawn
            {
                let resourchPath = NSBundle.mainBundle().pathForResource("Boost", ofType: "sks")
                let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
                box.position = self.convertPoint(CGPoint(x: 600, y: 176), toNode: groundScroll)
                groundScroll.addChild(box)
                
                //
                potionSpawnTimer = 0
                return
                
            }
            generalLanternTimeCounter = 19
            
        }else
        {
            generalLanternTimeCounter = 21
        }
        // add potions here and pops out after x time
        //more potions then lanterns
        
        
        if lanternSpawnTimer > generalLanternTimeCounter   //lantern spawn
        {
            let resourchPath = NSBundle.mainBundle().pathForResource("Lantern", ofType: "sks")
            let box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourchPath!))
            let randomNumber = Int(arc4random_uniform(UInt32(50)))
            box.position = self.convertPoint(CGPoint(x: 600 + randomNumber, y: 176), toNode: groundScroll)
            groundScroll.addChild(box)
            //    print("Lantern")
            lanternSpawnTimer = 0
            return
        }
        
        potionSpawnTimer+=fixedDelta
        pitSpawnTimer += fixedDelta
        lanternSpawnTimer += fixedDelta
        ghostSpawnTimer += fixedDelta
        
    }
    
    
    /*
     @func: adds type of boxes to the game scene
     @param: x == 1 for Box1.sks
     x == 2 for Box2.sks
     x == 3 for Box3.sks
     */
    func addBox(x: Int)
    {
        var resourcePath:String!
        var box:SKReferenceNode!
        if x <= 3{
            
            if x == 1{
                resourcePath = NSBundle.mainBundle().pathForResource("Box1", ofType: "sks")
            }
            else if x == 2{
                resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            }
            else{
                resourcePath = NSBundle.mainBundle().pathForResource("Box4", ofType: "sks")
                addDummyBox()
            }
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
            box.position = self.convertPoint(CGPoint(x: 600, y: 70), toNode: groundScroll)
            
        }
        else
        {
            resourcePath = NSBundle.mainBundle().pathForResource("Box2", ofType: "sks")
            box = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath))
            box.position = self.convertPoint(CGPoint(x: 600, y: 100), toNode: groundScroll)
        }
        groundScroll.addChild(box)
        
    }
    /*
     To create dummy box after box4
     */
    func addDummyBox()
    {
        let resourcePath = NSBundle.mainBundle().pathForResource("Box1_dummy", ofType: "sks")
        let myNil = SKReferenceNode(URL: NSURL(fileURLWithPath: resourcePath!))
        myNil.position = self.convertPoint(CGPoint(x: 650, y: 70), toNode: groundScroll)
        groundScroll.addChild(myNil)
        
    }
    
    func updateGroundScroll()
    {
        groundScroll.position.x -= scrollSpeed * CGFloat(fixedDelta)
        for node in groundScroll.children as [SKNode]
        {
            
            if let ground = node as? SKSpriteNode {
                let groundposition = groundScroll.convertPoint(ground.position, toNode: self)
                if groundposition.x <= -ground.size.width/2
                {
                    let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10 , groundposition.y)
                    ground.position = self.convertPoint(newPosition, toNode: groundScroll)
                }
            }
        }
    }
    func updateCloudScroll()
    {
        cloudSpeed = scrollSpeed * 0.1
        
        cloudScroll.position.x -= cloudSpeed * CGFloat(fixedDelta)
        for ground in cloudScroll.children as! [SKSpriteNode]
        {
            let groundposition = cloudScroll.convertPoint(ground.position, toNode: self)
            if groundposition.x <= -ground.size.width/2
            {
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width , groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: cloudScroll)
            }
        }
    }
    
    func updateBackScroll()
    {
        
        backSpeed = scrollSpeed * 0.3
        
        backScroll.position.x -= backSpeed * CGFloat(fixedDelta)
        
        for ground in backScroll.children as! [SKSpriteNode]
        {
            let groundposition = backScroll.convertPoint(ground.position, toNode: self)
            if groundposition.x <= -ground.size.width/2
            {
                let newPosition = CGPointMake((self.size.width/2) + ground.size.width - 10, groundposition.y)
                ground.position = self.convertPoint(newPosition, toNode: backScroll)
            }
        }
    }
    
}