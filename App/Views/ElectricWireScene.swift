import SpriteKit

class ElectricWireScene: SKScene, SKPhysicsContactDelegate {
    var onGameOver: ((Int) -> Void)?
    
    private var playerDot: SKShapeNode!
    private var isGameOver = false
    private var score = 0
    private var lastWallTime: TimeInterval = 0
    private var wallSpawnInterval: TimeInterval = 2.0
    private var wallSpeed: CGFloat = 200.0
    
    // Categorias de Colisão
    let playerCategory: UInt32 = 0x1 << 0
    let wallCategory: UInt32 = 0x1 << 1
    let scoreCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 0.05, green: 0.1, blue: 0.2, alpha: 1.0)
        
        setupPlayer()
        setupBoundaries()
    }
    
    private func setupPlayer() {
        playerDot = SKShapeNode(circleOfRadius: 15)
        playerDot.fillColor = .yellow
        playerDot.strokeColor = .white
        playerDot.position = CGPoint(x: size.width * 0.3, y: size.height * 0.5)
        
        playerDot.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        playerDot.physicsBody?.categoryBitMask = playerCategory
        playerDot.physicsBody?.contactTestBitMask = wallCategory | scoreCategory
        playerDot.physicsBody?.collisionBitMask = wallCategory
        playerDot.physicsBody?.allowsRotation = false
        playerDot.physicsBody?.restitution = 0.0
        
        addChild(playerDot)
        
        // Efeito de brilho
        let glow = SKEmitterNode()
        glow.particleTexture = SKTexture(imageNamed: "spark") // Caso não exista, falha silenciosamente
        glow.particleColorSequence = SKKeyframeSequence(keyframeValues: [SKColor.yellow, SKColor.white], times: [0, 1])
        glow.particleBirthRate = 50
        glow.particleLifetime = 0.5
        glow.particlePositionRange = CGVector(dx: 10, dy: 10)
        glow.particleSpeed = 20
        glow.particleAlpha = 0.5
        glow.particleBlendMode = .add
        playerDot.addChild(glow)
    }
    
    private func setupBoundaries() {
        let ground = SKNode()
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: size.width, y: 0))
        let roof = SKNode()
        roof.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: size.height), to: CGPoint(x: size.width, y: size.height))
        
        for boundary in [ground, roof] {
            boundary.physicsBody?.categoryBitMask = wallCategory
            boundary.physicsBody?.isDynamic = false
            addChild(boundary)
        }
    }
    
    private func spawnWall() {
        let gapSize: CGFloat = 200.0 // Abertura para passar
        let gapY = CGFloat.random(in: (gapSize + 50)...(size.height - gapSize - 50))
        
        let wallWidth: CGFloat = 50.0
        
        // Parede de baixo
        let bottomHeight = gapY - gapSize / 2
        let bottomWall = SKShapeNode(rectOf: CGSize(width: wallWidth, height: bottomHeight))
        bottomWall.fillColor = .cyan
        bottomWall.strokeColor = .blue
        bottomWall.position = CGPoint(x: size.width + wallWidth, y: bottomHeight / 2)
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallWidth, height: bottomHeight))
        
        // Parede de cima
        let topHeight = size.height - (gapY + gapSize / 2)
        let topWall = SKShapeNode(rectOf: CGSize(width: wallWidth, height: topHeight))
        topWall.fillColor = .cyan
        topWall.strokeColor = .blue
        topWall.position = CGPoint(x: size.width + wallWidth, y: size.height - topHeight / 2)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallWidth, height: topHeight))
        
        // Score Node (invisível no meio do gap)
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: size.width + wallWidth + playerDot.frame.width, y: gapY)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallWidth, height: gapSize))
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = scoreCategory
        
        for node in [bottomWall, topWall] {
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = wallCategory
            addChild(node)
            
            let moveLeft = SKAction.moveBy(x: -(size.width + wallWidth * 2), y: 0, duration: TimeInterval((size.width + wallWidth * 2) / wallSpeed))
            let remove = SKAction.removeFromParent()
            node.run(SKAction.sequence([moveLeft, remove]))
        }
        
        addChild(scoreNode)
        let moveScoreLeft = SKAction.moveBy(x: -(size.width + wallWidth * 2), y: 0, duration: TimeInterval((size.width + wallWidth * 2) / wallSpeed))
        scoreNode.run(SKAction.sequence([moveScoreLeft, SKAction.removeFromParent()]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        // Impulso para cima
        playerDot.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerDot.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        if lastWallTime == 0 {
            lastWallTime = currentTime
            spawnWall()
        } else if currentTime - lastWallTime > wallSpawnInterval {
            lastWallTime = currentTime
            spawnWall()
            
            // Dificuldade Progressiva
            if wallSpawnInterval > 0.8 {
                wallSpawnInterval -= 0.05
            }
            wallSpeed += 10.0
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }
        
        let a = contact.bodyA.categoryBitMask
        let b = contact.bodyB.categoryBitMask
        let collision = a | b
        
        if collision == (playerCategory | scoreCategory) {
            score += 1
            if a == scoreCategory { contact.bodyA.node?.removeFromParent() }
            if b == scoreCategory { contact.bodyB.node?.removeFromParent() }
        } else if collision == (playerCategory | wallCategory) {
            triggerGameOver()
        }
    }
    
    private func triggerGameOver() {
        isGameOver = true
        playerDot.physicsBody?.isDynamic = false
        
        // Explosão visual simples
        let expand = SKAction.scale(to: 3.0, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        playerDot.run(SKAction.group([expand, fade])) {
            self.onGameOver?(self.score)
        }
    }
}
