# Example 1 – SoundGridVisualizer

This Processing sketch visualizes microphone audio from **inside** a colorful 3D room. Each wall, the floor and the ceiling consist of a grid of small 3D bars. Five frequency bands from the microphone input are mapped to those walls. As the levels rise the bars extrude further into the room like an equalizer.

## Usage

1. Open `SoundGridVisualizer.pde` in the Processing IDE.
2. Make sure the **Sound** library is installed (Sketch \> Import Library \> Add Library... \> search for "Sound").
3. Run the sketch. It will request access to your microphone and place the camera at the center of the room.

Adjust the grid size, colors or `maxDepth` constant in the code to tweak how far the bars move.
