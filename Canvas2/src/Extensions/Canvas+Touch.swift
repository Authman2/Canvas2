//
//  Canvas+Touch.swift
//  Canvas2
//
//  Created by Adeola Uthman on 11/12/19.
//  Copyright © 2019 Adeola Uthman. All rights reserved.
//

import Foundation
import Metal
import MetalKit

public extension Canvas {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.metalLocation(in: self)
        
        // Start a new quad when a touch is down.
        nextQuad = Quad(start: point, brush: self.currentBrush.copy())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let coalesced = event?.coalescedTouches(for: touch) else { return }
        
        // NOTE: Run the following code for all of the coalesced touches.
        for cTouch in coalesced {
            let point = cTouch.metalLocation(in: self)
            
            // Every time you move, end the current quad and that position.
            guard var next = nextQuad else { continue }
            let last: Quad = lastQuad ?? next
            let c: CGPoint = lastQuad != nil ? last.c : next.start
            let d: CGPoint = lastQuad != nil ? last.d : next.start
            next.end(at: point, prevA: c, prevB: d)
            
            // Add that finalized quad onto the list of quads on the canvas.
            quads.append(next)
            
            // Set the last quad so that while you are still drawing, you can
            // use it to get the last quad coordinate points.
            lastQuad = next
            
            // Start the next quad from the end position, in case the touch is still moving.
            nextQuad = Quad(start: point, brush: self.currentBrush.copy())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Close the current and last quads, no touches on the screen.
        nextQuad = nil
        lastQuad = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Close the current and last quads, no touches on the screen.
        nextQuad = nil
        lastQuad = nil
    }
}
