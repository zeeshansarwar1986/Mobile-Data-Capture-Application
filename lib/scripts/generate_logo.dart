import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  print('Generating logo...');
  
  // Create a 1024x1024 image
  final image = img.Image(width: 1024, height: 1024);
  
  // Fill with Teal color (#008080)
  img.fill(image, color: img.ColorRgb8(0, 128, 128));
  
  // Draw a white border/frame
  img.drawRect(image, x1: 50, y1: 50, x2: 974, y2: 974, color: img.ColorRgb8(255, 255, 255), thickness: 20);
  
  // Note: Drawing text with the 'image' package usually needs a font file.
  // Since we might not have one, let's use a very simple shutter icon representation using rectangles/lines.
  
  // Center Shutter/Lens circle (approx) using multiple circles for thickness
  img.drawCircle(image, x: 512, y: 512, radius: 250, color: img.ColorRgb8(255, 255, 255));
  img.drawCircle(image, x: 512, y: 512, radius: 240, color: img.ColorRgb8(0, 128, 128)); // Hollow out
  
  img.drawCircle(image, x: 512, y: 512, radius: 100, color: img.ColorRgb8(255, 255, 255));
  img.drawCircle(image, x: 512, y: 512, radius: 90, color: img.ColorRgb8(0, 128, 128)); // Hollow out
  
  // Represent "DATA CAPTURE" with bars
  // Top bar
  img.fillRect(image, x1: 300, y1: 200, x2: 724, y2: 240, color: img.ColorRgb8(255, 255, 255));
  // Bottom bar
  img.fillRect(image, x1: 300, y1: 784, x2: 724, y2: 824, color: img.ColorRgb8(255, 255, 255));

  // Save to assets/logo.png
  final encoder = img.PngEncoder();
  final png = encoder.encode(image);
  
  final file = File('assets/logo.png');
  await file.create(recursive: true);
  await file.writeAsBytes(png);
  
  print('Logo generated successfully at assets/logo.png');
}
