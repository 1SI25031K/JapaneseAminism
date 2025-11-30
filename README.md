# Japanese Animism (iOS)

## 1. Overview
This project is a SwiftUI application developed for a final class presentation. It serves as an interactive digital exhibit exploring how ancient Japanese spiritual concepts-Tsukumogami, Shikigami, and Yorishiro-can provide a unique ethical framework for understanding modern Brain-Computer Interfaces (BCI).

Unlike Western dualism which separates the "mind" from the "machine," this application demonstrates a fluid worldview where objects can possess souls, intentions can be embedded in tools, and devices can become sacred vessels. The app utilizes advanced macOS interactions such as hover effects, drag-and-drop, and long-press gestures to create an immersive narrative experience.

## 2. Installation Instructions (For Audience)
To run this application on your local machine (Mac or iPad), please follow these steps:

1.  **Download the Source Code**
    * Go to the main page of this GitHub repository.
    * Click the green "Code" button.
    * Select "Download ZIP".

2.  **Unzip the File**
    * Locate the downloaded file in your Downloads folder.
    * Double-click the ZIP file to extract the project folder.

3.  **Open in Xcode**
    * Ensure you have Xcode installed (available from the Mac App Store).
    * Open the extracted folder.
    * Double-click the `.xcodeproj` file (e.g., `BCIAnimism.xcodeproj`).

4.  **Run the Application**
    * In the top toolbar of Xcode, select your target device (e.g., "My Mac (Designed for iPad)" or a specific iPad Simulator).
    * Click the "Run" button (the triangle icon) or press `Command + R`.
    * The application will launch in a separate window.

## 3. User Experience & Interactivity
This app goes beyond static text by implementing distinct interactive metaphors for each spiritual concept:

* **Tsukumogami (The Awakening Tool):** Utilizing `onHover` and animation modifiers, objects on the screen tremble and react to the user's gaze (mouse cursor), simulating the eerie feeling of a tool gaining a soul.
* **Shikigami (The Ritual Bound Spirit):** Utilizing `.draggable` and `.dropDestination`, users must physically drag a paper effigy (Katashiro) into a ritual circle to summon the spirit, mimicking the intentional act of a sorcerer.
* **Yorishiro (The Divine Vessel):** Utilizing `.onLongPressGesture` and a custom particle system, users must press and hold to "pray," charging the object with light until the divinity manifests with a flash and sound.

## 4. Tech Stack
* **Platform:** macOS (Optimized) / iPadOS
* **Language:** Swift 5+
* **Framework:** SwiftUI
* **IDE:** Xcode 16+
* **Key Frameworks:**
    * `SwiftUI` (NavigationSplitView, Animations, Gestures)
    * `AVFoundation` (Audio playback for immersive sound effects)
    * `WebKit` (YouTube video integration)
    * `UniformTypeIdentifiers` (Data management for Drag and Drop)

## 5. Directory Structure
The project adheres to a standard SwiftUI structure with clear separation of concerns.

```text
BCIAnimism/
├── BCIAnimismApp.swift       // Entry point
├── ContentView.swift         // Main NavigationSplitView layout
├── Localizable.xcstrings     // String Catalog for English text management
├── Assets.xcassets/          // Images and Color Sets (AppBackground, AppText)
│
├── Views/
│   ├── IntroductionView.swift  // Introduction to BCI and Dualism
│   ├── TsukumogamiView.swift   // Interactive Hover view
│   ├── ShikigamiView.swift     // Interactive Drag & Drop view
│   ├── YorishiroView.swift     // Interactive Long-press & Particle view
│   ├── ConclusionView.swift    // Final synthesis
│   └── Components/
│       └── YouTubeView.swift   // Reusable WKWebView wrapper
│
├── Sounds/
│   ├── wood_creak.mp3        // Sound for Tsukumogami
│   ├── paper_snap.mp3        // Sound for Shikigami
│   └── shrine_bell.mp3       // Sound for Yorishiro
│
└── Resources/
    └── (Video/Image assets are managed within Assets.xcassets)

```

## 6. Functional Requirements

The following table outlines the core functionalities implemented in the application.

| Function ID | Category | Function Name | Description | Remarks |
| :--- | :--- | :--- | :--- | :--- |
| FUNC-001 | Navigation | Sidebar Navigation | Provides a persistent sidebar using `NavigationSplitView` to navigate between chapters. | Styled like iPadOS Files app. |
| FUNC-002 | Interactivity | Hover Feedback | Detects mouse hover events to trigger rotation and scale animations on images. | Used in TsukumogamiView. |
| FUNC-003 | Interactivity | Drag and Drop | Allows users to drag an image element and drop it into a designated target zone. | Used in ShikigamiView. |
| FUNC-004 | Interactivity | Long Press Gesture | Detects a long-press action to trigger a charging animation and state change. | Used in YorishiroView. |
| FUNC-005 | Interactivity | Neural Synch Visualizer | Simulates BCI calibration where users must align wave frequency and amplitude using mouse movements. | Used in NeuralView. |
| FUNC-006 | Visual Effects | Particle System | Generates moving light particles using SwiftUI geometry and animation. | Custom implementation for Yorishiro. |
| FUNC-007 | Audio | Sound Effect Playback | Plays specific mp3 files triggered by user interactions (tap, drop, long-press). | Uses AVFoundation. |
| FUNC-008 | Media | Video Playback | Embeds a YouTube player to display relevant cultural or scientific footage. | Uses WKWebView. |
| FUNC-009 | UI/Design | Theming | Enforces a strict black-and-white color scheme using Asset Catalogs. | Supports Dark/Light mode logic. |
| FUNC-010 | Localization | Text Management | Manages all long-form text content via String Catalogs (`.xcstrings`). | Currently English only. |

## 7. Design Philosophy

* **Visuals:** A monochromatic (Black & White) aesthetic is used to convey a "chic," academic, and spiritual atmosphere, avoiding distraction.
* **Typography:** Clean, readable sans-serif fonts ensure the extensive text content is legible on large presentation screens.
* **Motion & "Ma":** "Dynamic" is interpreted not just as moving elements, but as reactive interfaces. The app rests in stillness (representing "Ma" or negative space) until the user interacts, at which point it responds with sudden, meaningful action (sound, flash, or transformation).

## 8. License

**MIT License**

Copyright (c) 2025 Kosei Miyamoto

* **Author:** Kosei Miyamoto
* **Affiliation:** Kyushu University
* **Student ID:** 1SI25031K
* **Email:** miyamoto.kosei.698@s.kyushu-u.ac.jp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
    
