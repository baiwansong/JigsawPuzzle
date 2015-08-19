//
//  SliddingPuzzle.swift
//  puzzleGame
//
//  Created by Arturs Derkintis on 8/11/15.
//  Copyright (c) 2015 Starfly. All rights reserved.
//

import SpriteKit

class SliddingPuzzle: SKScene {
    var border : SKNode?
    var points = [CGPoint]()
    var tilesCount : Int = 0
    var tiles = [Tile]()
    var labelTitles = [Int]()
    var emptyPoint : CGPoint?
    var hidenTile : Tile?
    var movingTile : Tile?
    var movableTiles = [Tile]()
    var width : CGFloat = 0
    var correctCount : Int = 0
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.lightGrayColor()
    
        
        setBorder()
        //\//\\
        ///\\//
        startNewImageGameLevel(ImageLevels.easy, image: UIImage(named: "car.jpg")!)
       
    }
    func startNewNumberGameLevel(level : NumberLevels){
        border?.removeAllChildren()
        let tilesInLine = level.rawValue
        tilesCount = tilesInLine * tilesInLine
        
        width = CGFloat(min(Int(frame.height - 50), Int(frame.width - 50)) / tilesInLine)
        var line = tilesInLine - 1
        var row = 0
        for var i = 0; i < tilesCount; ++i {
            points.append(CGPoint(x: (CGFloat(row) * width), y: (CGFloat(line) * width)))
            if row == tilesInLine - 1{
                line -= 1
                row = 0
            }else{
                row += 1
            }
        }
        for point in points{
            setTile(point, size: CGSize(width: width - 1, height: width - 1))
            tiles[points.indexOf(point)!].textLabel?.text = String(points.indexOf(point)! + 1)
        }
        
        putTilesInRandomPoints(false)
        hideOneRandomTile(false)
        
    }
    func startNewImageGameLevel(level : ImageLevels, image : UIImage){
        border?.removeAllChildren()
        let tilesInLine = level.rawValue
        tilesCount = tilesInLine * tilesInLine
        
        width = CGFloat(min(Int(frame.height - 50), Int(frame.width - 50)) / tilesInLine)
        var line = tilesInLine - 1
        var row = 0
        for var i = 0; i < tilesCount; ++i {
            points.append(CGPoint(x: (CGFloat(row) * width), y: (CGFloat(line) * width)))
            if row == tilesInLine - 1{
                line -= 1
                row = 0
            }else{
                row += 1
            }
        }
        let w = min(frame.height - 10, frame.width - 10)
        let imagesArr = image.sliceImageToPieces(CGSize(width: w, height: w), pieceSize: CGSize(width: width, height: width))
        
        for point in points{
            
            setTileWithImage(SKTexture(image: imagesArr[points.indexOf(point)!]), position: point, size: CGSize(width: width - 1, height: width - 1))
            //tiles[points.indexOf(point)!].textLabel?.text = String(points.indexOf(point)! + 1)
        }
        
        putTilesInRandomPoints(true)
        hideOneRandomTile(true)
        
    }
    
    func putTilesInRandomPoints(animate : Bool){
        let randomizedPoints = points.shuffle()
        for tile in tiles {
            if animate{
                tile.wrongPostion = randomizedPoints[self.tiles.indexOf(tile)!]
                let wait = SKAction.waitForDuration(3.0)
                let action = SKAction.moveTo(randomizedPoints[tiles.indexOf(tile)!], duration: 0.65)
                
                let group = SKAction.sequence([wait, action])
                tile.runAction(group, completion: { () -> Void in
                    self.hideOneRandomTile(false)
                    
                })
            }else{
                tile.position = randomizedPoints[tiles.indexOf(tile)!]
                tile.wrongPostion = randomizedPoints[tiles.indexOf(tile)!]
                
            }
        }
        
    }
    func hideOneRandomTile(animate : Bool){
        let tileToHide = tiles.last
        tileToHide!.hide(true)
        hidenTile = tileToHide
        emptyPoint = tileToHide!.position
        self.hidenTile?.position = (self.hidenTile?.correctPosition)!
        radarForMovableTiles(emptyPoint!)
    }
    func radarForMovableTiles(centerNodePosition : CGPoint){
        movableTiles.removeAll()
        for tile in tiles{
            tile.move = TileMoves.notMove
        }
        let upPoint = CGPoint(x: centerNodePosition.x + (width * 0.5), y: centerNodePosition.y + (width * 1.5))
        let rightPoint = CGPoint(x: centerNodePosition.x + (width * 1.5), y: centerNodePosition.y + (width * 0.5))
        let leftPoint = CGPoint(x: centerNodePosition.x - (width * 0.5), y: centerNodePosition.y + (width * 0.5))
        let downPoint = CGPoint(x: centerNodePosition.x + (width * 0.5), y: centerNodePosition.y - (width * 0.5))
        let upNodes = border?.nodesAtPoint(upPoint)
        let rightNodes = border?.nodesAtPoint(rightPoint)
        let leftNodes  = border?.nodesAtPoint(leftPoint)
        let downNodes = border?.nodesAtPoint(downPoint)
        if let subNodes = upNodes{
            for  node in subNodes where node.name == "tile"{
                (node as! Tile).move = TileMoves.down
                movableTiles.append(node as! Tile)
            }}
        if let subNodes = rightNodes{
            for  node in subNodes where node.name == "tile"{
                (node as! Tile).move = TileMoves.left
                movableTiles.append(node as! Tile)
            }}
        if let subNodes = leftNodes{
            for  node in subNodes where node.name == "tile"{
                (node as! Tile).move = TileMoves.left
                movableTiles.append(node as! Tile)
            }}
        if let subNodes = downNodes{
            for  node in subNodes where node.name == "tile"{
                (node as! Tile).move = TileMoves.up
                movableTiles.append(node as! Tile)
            }}
        
        
    }
    func setBorder(){
        let sprite = SKSpriteNode()
        let widthOfHolder = CGFloat(min(frame.height - 50, frame.width - 50))
        sprite.color = UIColor.clearColor()
        sprite.size = CGSize(width: widthOfHolder, height: widthOfHolder)
        sprite.position = CGPoint(x: (frame.width - widthOfHolder) * 0.5, y: 25)
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(sprite)
        border = sprite
    }
    func setTile(position : CGPoint, size : CGSize){
        let sprite = Tile()
        sprite.name = "tile"
        sprite.color = UIColor(rgba: "#01837f")
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.correctPosition = position
        sprite.position = position
        
        sprite.size = size
        sprite.setLabel()
        border!.addChild(sprite)
        tiles.append(sprite)
        
    }
    func setTileWithImage(texture: SKTexture, position : CGPoint, size : CGSize){
        let sprite = Tile(texture: texture)
        sprite.name = "tile"
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        sprite.correctPosition = position
        sprite.position = position
        sprite.size = size
        border!.addChild(sprite)
        tiles.append(sprite)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let loc = touch.locationInNode(border!)
            let movableNodes = border?.nodesAtPoint(loc)
            if let subNodes = movableNodes{
                for  node in subNodes where node.name == "tile"{
                    
                    movingTile = node as? Tile
                    if movableTiles.contains(movingTile!){
                        movingTile?.removeAllActions()
                        let oldEmpty = emptyPoint!
                        let action = SKAction.moveTo(emptyPoint!, duration: 0.2)
                        
                        emptyPoint = movingTile!.wrongPostion
                        self.movingTile?.wrongPostion = oldEmpty
                        movingTile!.runAction(action, completion: { () -> Void in
                            
                            self.radarForMovableTiles(self.emptyPoint!)
                            var correctCounter = 0
                            for tile in self.tiles{
                                
                                if tile.position == tile.correctPosition{
                                    correctCounter += 1
                                    
                                }
                            }
                            print(correctCounter)
                            self.correctCount = correctCounter
                            if self.correctCount == self.tiles.count{
                                let action = SKAction.fadeAlphaTo(1.0, duration: 0.2)
                                self.hidenTile?.showAfterGame()
                                self.hidenTile?.runAction(action)
                                
                            }
                            
                        })
                        
                    }
                }
            }
            
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

class Tile : SKSpriteNode{
    var correctPosition : CGPoint?
    var wrongPostion : CGPoint?
    var textLabel : SKLabelNode?
    var index : Int?
    var move : TileMoves = .notMove
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        zPosition = 100
    }
    func setLabel(){
        textLabel = SKLabelNode()
        textLabel?.fontName = "ChalkboardSE-Bold"
        textLabel?.fontSize = self.frame.size.width * 0.4
        textLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        textLabel?.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        addChild(textLabel!)
    }
    func hide(animate : Bool){
        if animate{
            runAction(SKAction.fadeAlphaTo(0.01, duration: 3.0)) { () -> Void in
                self.hidden = true
            }}else{
            alpha = 0.01
            hidden = true
        }
        
    }
    func showAfterGame(){
        hidden = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
