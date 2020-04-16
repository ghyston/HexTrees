//
//  ShaderManager.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 14.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol IShaderManager {
	var selectableHighlightShader: AnimatedShader { get set }
	var selectableMuffleShader: AnimatedShader { get set }
	var collectableButtonShader: AnimatedShader { get set }
	
	func updateSelectableAnimation(_ delta: TimeInterval)
	func fadeInSelectable()
	func fadeOutSelectable()
}

class ShaderManager: IShaderManager {
	lazy var selectableHighlightShader = ShaderManager.loadSelectableHighlight()
	lazy var selectableMuffleShader = ShaderManager.loadSelectableMuffle()
	lazy var collectableButtonShader = ShaderManager.loadCollectableButtonShader()
	
	private var selectorIdlePlayback: IPlayback?
	private var selectorAppearPlayback: IPlayback?
	private var selectorDisappearPlayback: IPlayback?
	
	func fadeInSelectable() {
		self.createFadeInPlayback()
		self.createIdlePlayback()
	}
	
	func fadeOutSelectable() {
		self.createFadeOutPlayback()
	}
	
	private class func loadSelectableHighlight() -> AnimatedShader {
		let shader = AnimatedShader(fileNamed: "selectableHighlight")
		shader.addUniform(name: "u_appear", value: 0.0)
		return shader
	}
	
	private class func loadSelectableMuffle() -> AnimatedShader {
		let shader = AnimatedShader(fileNamed: "selectableMuffle")
		shader.updateUniform(1.0)
		return shader
	}
	
	private class func loadCollectableButtonShader() -> AnimatedShader {
		let shader = AnimatedShader(fileNamed: "collectableButton")
		shader.attributes = [SKAttribute(name: "aPos", type: .float)]
		return shader
	}
	
	private func createIdlePlayback() {
		self.selectorIdlePlayback = Playback(
			duration: 1.0,
			repeated: true)
	}
	
	private func createFadeInPlayback() {
		self.selectorAppearPlayback = Playback(
			duration: GameConstants.CellAppearAnimationDuration,
			onFinish: {
				self.selectorAppearPlayback = nil
			})
	}
	
	private func createFadeOutPlayback() {
		self.selectorDisappearPlayback = Playback(
			duration: GameConstants.CellAppearAnimationDuration,
			reversed: true,
			onFinish: {
				self.selectorIdlePlayback = nil
				self.selectorDisappearPlayback = nil
			});
	}
	
	func updateSelectableAnimation(_ delta: TimeInterval) {
		if let idlePlaybackValue = self.selectorIdlePlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(idlePlaybackValue)
		}
		
		if let appearPlaybackValue = self.selectorAppearPlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(appearPlaybackValue, variableName: "u_appear")
			self.selectableMuffleShader.updateUniform(appearPlaybackValue)
		}
		
		if let dissapearPlaybackValue = self.selectorDisappearPlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(dissapearPlaybackValue, variableName: "u_appear")
			self.selectableMuffleShader.updateUniform(dissapearPlaybackValue)
		}
	}
}
