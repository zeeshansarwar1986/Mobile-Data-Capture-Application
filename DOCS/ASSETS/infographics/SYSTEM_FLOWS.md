# System Infographics

## a) User Flow (Mobile App)

From opening the app to final confirmation.

```mermaid
graph TD
    A[Open App] --> B[Home: Start Capture]
    B --> C[Camera: Photo or Video]
    C --> D[Automatically Get GPS & Time]
    D --> E[Fill Form: Category, Severity, Tags]
    E --> F[Preview Screen: Review Data]
    F --> G{Confirm & Upload}
    G -->|Success| H[Success Screen: Show Upload ID]
    G -->|Error| I[Show Error Message]
```

---

## b) Admin Flow (Web Panel)

Secure management and data review.

```mermaid
graph LR
    A[Admin Login] --> B[Dashboard]
    B --> C[Filter: Date/Category/Severity]
    C --> D[View Records]
    D --> E[Preview Media]
    D --> F[Open Location in Google Maps]
    D --> G[Download Media]
```

---

## c) Data Flow Architecture

Communication between device and cloud.

```mermaid
flowchart TD
    subgraph "Mobile Device"
    CA[Camera] --> MD[Media File]
    GP[GPS] --> LC[Coordinates]
    UI[Form Input] --> DT[Metadata]
    end

    MD -->|Upload| FS[(Firebase Storage)]
    LC -->|Save| FD[(Firestore)]
    DT -->|Save| FD

    subgraph "Firebase Backend"
    FS
    FD
    end

    FD -->|Fetch| WA[Web Admin Panel]
    FS -->|Fetch| WA
```

---

## d) Quick Reference (ASCII)

```text
+-----------------------+       +-----------------------+
|   MOBILE USER APP     |       |   ADMIN WEB PANEL      |
+-----------------------+       +-----------------------+
| [Camera] -> [Form]    | ----> | [Filters] -> [List]   |
| [GPS]    -> [Upload]  |       | [Analytics] -> [Export]|
+-----------------------+       +-----------------------+
           |                             ^
           v                             |
+-------------------------------------------------------+
|                 FIREBASE BACKEND                      |
+-------------------------------------------------------+
|  [Auth]      [Firestore]      [Storage]    [Hosting]  |
+-------------------------------------------------------+
```
