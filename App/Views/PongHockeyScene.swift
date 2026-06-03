import SpriteKit

class PongHockeyScene: SKScene, SKPhysicsContactDelegate {
    let gameType: GameType
    var onGameOver: ((Int) -> Void)?
    
    private var ball: SKShapeNode!
    private var paddle1: SKShapeNode! // Bottom
    private var paddle2: SKShapeNode! // Top
    
    private var isGameOver = false
    private var activeTouches: [UITouch: SKShapeNode] = [:]
    
    // Categorias de colisão
    let ballCategory: UInt32 = 0x1 << 0
    let paddleCategory: UInt32 = 0x1 << 1
    let wallCategory: UInt32 = 0x1 << 2
    let goal1Category: UInt32 = 0x1 << 3 // Fundo (P1 perde)
    let goal2Category: UInt32 = 0x1 << 4 // Topo (P2 perde)
    
    init(gameType: GameType) {
        self.gameType = gameType
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        setupBackground()
        setupBoundaries()
        setupPaddles()
        setupBall()
    }
    
    private func setupBackground() {
        let bgNode = SKSpriteNode(color: gameType == .hockey ? SKColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1) : SKColor(red: 0.1, green: 0.5, blue: 0.2, alpha: 1), size: self.size)
        bgNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bgNode.zPosition = -10
        addChild(bgNode)
        
        // Linha do meio
        let middleLine = SKShapeNode(rectOf: CGSize(width: size.width, height: 4))
        middleLine.fillColor = .white.withAlphaComponent(0.3)
        middleLine.strokeColor = .clear
        middleLine.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(middleLine)
    }
    
    private func setupBoundaries() {
        // Paredes laterais
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: size.height))
        let rightWall = SKNode()
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: size.width, y: 0), to: CGPoint(x: size.width, y: size.height))
        
        for wall in [leftWall, rightWall] {
            wall.physicsBody?.categoryBitMask = wallCategory
            wall.physicsBody?.restitution = 1.0
            wall.physicsBody?.friction = 0.0
            addChild(wall)
        }
        
        // Goals
        let bottomGoal = SKNode()
        bottomGoal.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -50), to: CGPoint(x: size.width, y: -50))
        bottomGoal.physicsBody?.categoryBitMask = goal1Category
        
        let topGoal = SKNode()
        topGoal.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: size.height + 50), to: CGPoint(x: size.width, y: size.height + 50))
        topGoal.physicsBody?.categoryBitMask = goal2Category
        
        for goal in [bottomGoal, topGoal] {
            goal.physicsBody?.isDynamic = false
            addChild(goal)
        }
    }
    
    private func setupPaddles() {
        paddle1 = SKShapeNode(rectOf: CGSize(width: 100, height: 20), cornerRadius: 10)
        paddle1.fillColor = .red
        paddle1.position = CGPoint(x: size.width / 2, y: 100)
        
        paddle2 = SKShapeNode(rectOf: CGSize(width: 100, height: 20), cornerRadius: 10)
        paddle2.fillColor = .blue
        paddle2.position = CGPoint(x: size.width / 2, y: size.height - 100)
        
        for paddle in [paddle1, paddle2] {
            paddle!.strokeColor = .clear
            paddle!.physicsBody = SKPhysicsBody(polygonFrom: paddle!.path!)
            paddle!.physicsBody?.isDynamic = true // Move via touches but influences impact
            paddle!.physicsBody?.affectedByGravity = false
            paddle!.physicsBody?.mass = 100.0
            paddle!.physicsBody?.categoryBitMask = paddleCategory
            paddle!.physicsBody?.restitution = 1.0
            paddle!.physicsBody?.friction = 0.0
            addChild(paddle!)
        }
    }
    
    private func setupBall() {
        ball = SKShapeNode(circleOfRadius: 15)
        ball.fillColor = .black
        ball.strokeColor = .clear
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = goal1Category | goal2Category | paddleCategory
        ball.physicsBody?.collisionBitMask = wallCategory | paddleCategory
        
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.restitution = 1.0 // Bounce perfeito
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.allowsRotation = true
        
        addChild(ball)
        
        // Iniciar com uma pequena velocidade aleatória
        let dx = CGFloat.random(in: -200...200)
        let dy = CGFloat([-300, 300].randomElement()!)
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Identificar se tocou na metade de baixo (Player 1) ou de cima (Player 2)
            if location.y < size.height / 2 {
                activeTouches[touch] = paddle1
            } else {
                activeTouches[touch] = paddle2
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let paddle = activeTouches[touch] {
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                
                // Mover paddle
                var newX = location.x
                var newY = location.y
                
                // Restringir à sua metade e ao ecrã
                newX = max(50, min(size.width - 50, newX))
                if paddle == paddle1 {
                    newY = max(20, min(size.height / 2 - 20, newY))
                } else {
                    newY = max(size.height / 2 + 20, min(size.height - 20, newY))
                }
                
                paddle.position = CGPoint(x: newX, y: newY)
                
                let dx = location.x - previousLocation.x
                let dy = location.y - previousLocation.y
                paddle.physicsBody?.velocity = CGVector(dx: dx * 60, dy: dy * 60)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let paddle = activeTouches[touch] {
                paddle.physicsBody?.velocity = .zero // Reset
            }
            activeTouches.removeValue(forKey: touch)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: - Physics & Update
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }
        
        let a = contact.bodyA.categoryBitMask
        let b = contact.bodyB.categoryBitMask
        
        let collision = a | b
        
        if collision == (ballCategory | goal1Category) {
            triggerWin(for: 2) // P1 (bottom) falhou, P2 (top) ganha
        } else if collision == (ballCategory | goal2Category) {
            triggerWin(for: 1) // P2 (top) falhou, P1 (bottom) ganha
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        // Garantir que a bola não fica horizontalmente parada (anti-lock)
        if let v = ball.physicsBody?.velocity {
            if abs(v.dy) < 50 && abs(v.dx) > 100 {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: v.dy >= 0 ? 10 : -10))
            }
        }
    }
    
    private func triggerWin(for player: Int) {
        guard !isGameOver else { return }
        isGameOver = true
        ball.physicsBody?.isDynamic = false // Parar a bola
        
        onGameOver?(player)
    }
}
