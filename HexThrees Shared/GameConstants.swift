//
//  GameConstants.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

class GameConstants {
    
    static let BonusTurnsLifetime = 2
    static let MaxBonusesOnScreen = 3
    
    // Animations
    static let SecondsPerCell = 0.15
    static let BonusAnimationDuration = 0.5
    static let GameOverScreenDelay = 1.2
    static let StressTimerInterval = 3.0
    static let StressTimerRollbackInterval = 0.5
    static let HelpVCAnimationDelay = 1.0
    static let BlockAnimationDuration = 1.0
    static let CellAppearAnimationDuration = 0.5
    
    // Probabilities
    static let RandomCellIsValue2Probability: Float = 0.3
    static let BaseBonusDropProbability = 1.0//0.1
    static let LockBonusProbability: Float = 0.0//0.5
    static let UnlockBonusProbability: Float = 0.0//0.3
    static let LastBlockedUnlockBonusProbability: Float = 0.05
    static let X2BonusProbability: Float = 0.0//0.2
    static let X3BonusProbability: Float = 0.0//0.1
    static let CollectableBonusType1Probability: Float = 1.0// 0.1
}

enum SettingsKey : String {
    
    case FieldSize = "field_size"
    case Palette = "palette"
    case MotionBlur = "motion_blur"
    case HapticFeedback = "haptic_feedback"
    case StressTimer = "stress_timer"
}
