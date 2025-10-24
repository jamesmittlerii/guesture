/**
 
 * __Homework 14__
 * Jim Mittler
 * 24 October 2025
 
 
 Some basic gestures applied to an image.
 
 We are going to support pinch zooming and double tapping.
 
 For fun we threw in a progress view because we worked on that too.
 
 _Italic text__
 __Bold text__
 ~~Strikethrough text~~
 
 */

import SwiftUI

struct ContentView: View {
    // we need to keep track of our current scale and previous
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    // Tracks the zoomed state of the image from double-tapping.
    @State private var isZoomed = false
    
    // Define the range for zooming.
    private let zoomRange: ClosedRange<CGFloat> = 0.5...3.0
    
    // we need a percentage for the progress slider expressed 0-1
    private var normalizedScale: Double {
        // Normalize the scale to a 0-1 range for the ProgressView.
        (currentScale - zoomRange.lowerBound) / (zoomRange.upperBound - zoomRange.lowerBound)
    }
    
    var body: some View {
        VStack {
            // a little header
            Text("Pinch or double tap to zoom").font(.headline)
            // some gummi bears
            Image("bears")
                .resizable()
                .scaledToFit()
                .scaleEffect(currentScale)
                .gesture(
                    /// pinching = magnifygestures
                    MagnifyGesture()
                        .onChanged { value in
                            let updatedScale = lastScale * value.magnification
                            // Clamp the scale to our defined range.
                            currentScale = max(zoomRange.lowerBound, min(updatedScale, zoomRange.upperBound))
                        }
                        .onEnded { value in
                            lastScale = currentScale
                        }
                )
            // dounle tapping
                .simultaneousGesture(
                    TapGesture(count: 2)
                        .onEnded {
                            withAnimation {
                                isZoomed.toggle()
                                if isZoomed {
                                    currentScale = 2.0
                                    lastScale = 2.0
                                } else {
                                    currentScale = 1.0
                                    lastScale = 1.0
                                }
                            }
                        }
                )
            
            Spacer()

            // here's our progress bar
            VStack {
                Text("Zoom: \(Int(currentScale * 100))%")
                ProgressView(value: normalizedScale)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
