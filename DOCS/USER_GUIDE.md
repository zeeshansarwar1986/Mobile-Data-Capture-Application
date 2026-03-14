# DataCaptureMVP User Guide

## For Mobile Users (Field Agents)

### 1. Starting a Capture

- Open the app on your Android or iOS device.
- Tap the **Start Capture** button on the home screen.

### 2. Capturing Data

- **Media**: Tap the large "Camera" or "Video" icons (now centered for easier use) to capture media.
- **Watermarking**: The app will automatically overlay your GPS coordinates and the current time onto your photos and videos.
- **Location**: The app records high-precision coordinates for every record.
- **Details**:
  - Select a **Category** (Incident, Observation, etc.).
  - Choose the **Severity** level.
  - Check relevant **Tags** (Safety, Personnel, etc.).
  - Enter optional **Notes**.

### 3. Uploading

- Review your captured data on the **Preview** screen.
- Tap **Confirm & Upload**. You will receive a unique Upload ID upon success.

---

## For Administrators (Web Portal)

### 1. Logging In

- Navigate to the admin URL (or run in browser).
- Enter your admin credentials.
- *Default Admin*: `admin@example.com` / `password123` (Note: Must be created in Firebase Auth first).

### 2. Dashboard Navigation

- All uploads appear in the dashboard, sorted by most recent.
- Use the **Category** and **Severity** filters to narrow down results.

### 3. Reviewing Records

- Click on an item to see full details.
- Tap **View on Map** to see the exact capture location in Google Maps.
- Tap **Download Media** to save the original file to your computer.
