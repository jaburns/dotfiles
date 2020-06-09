#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>
#include <assert.h>
#include <X11/cursorfont.h>
#include <X11/extensions/shape.h>

// Include the mouse cursor xbm directly
#define mouse_width 12
#define mouse_height 21
static unsigned char mouse_bits[] = {
   0x01, 0x00, 0x03, 0x00, 0x07, 0x00, 0x0f, 0x00, 0x1f, 0x00, 0x3f, 0x00,
   0x7f, 0x00, 0xff, 0x00, 0xff, 0x01, 0xff, 0x03, 0xff, 0x07, 0xff, 0x0f,
   0xff, 0x00, 0xff, 0x00, 0xe7, 0x01, 0xe3, 0x01, 0xc1, 0x03, 0xc0, 0x03,
   0x80, 0x07, 0x80, 0x07, 0x00, 0x03 };

/*
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Some ideas taken from oneko-1.2.sakura (http://www.daidouji.com/oneko/)
	and shape.c (http://www.edwardrosten.com/code/).
	
                  sudo apt install libxext-dev libx11-dev
	Compile with: gcc extramaus.c -o extramaus -lX11 -lXext -g
*/


int main(argc, argv) int argc; char *argv[];
{
	Display					*display;
	int						screenNr;
	Colormap				colorMap;
	XSetWindowAttributes	windowAttributes;
	Pixmap					mouseCursor;
	XColor					red, exact_red;
	Window 					mouseWindow, QueryRoot, QueryChild;
	int						mouseX, mouseY, winX, winY, mouseOldX, mouseOldY;
	unsigned int			mask;
	XSizeHints				*s_hints;
	XWindowChanges			windowChanges;
	unsigned long			windowMask;

	// Open the X11 display and get back a pointer to it
	display = XOpenDisplay(NULL);

	// Get the screen number
	screenNr = DefaultScreen(display);

	// Get the color map (ID)
	colorMap = DefaultColormap(display, screenNr);

	// Stop the program, if display is false (NULL)
	assert(display);

	// Get the "nearest" color matching the color name "red" and store it in the variable "red"
	XAllocNamedColor(display, colorMap, "red", &red, &exact_red);

	// Set the mouse coordinates to invalid values
	mouseOldX = -1;
	mouseOldY = -1;

	// Set some attributes
	windowAttributes.background_pixel = red.pixel;
	windowAttributes.override_redirect = True;
	windowMask = CWBackPixel | CWOverrideRedirect;

	// Create the window at position 10, 10, with width and height of the cursor
	mouseWindow = XCreateWindow(display, XRootWindow(display, screenNr), 10, 10, mouse_width, mouse_height, 0, DefaultDepth(display, screenNr), InputOutput, CopyFromParent, windowMask, &windowAttributes);
	assert(mouseWindow);

	// Create a bitmap with the size of the mouse cursor and its bits
	mouseCursor = XCreateBitmapFromData(display, mouseWindow, mouse_bits, mouse_width, mouse_height);

	// Use the mouse cursor as shape for the mouse window
	XShapeCombineMask(display, mouseWindow, ShapeBounding, 0, 0, mouseCursor, ShapeSet);

	// Show the mouse window
	XMapWindow(display, mouseWindow);
	XFlush(display);

	// Let it loop forever
	while (True)
	{
		// Get the position of the mouse and store it in the variables mouseX and mouseY
		XQueryPointer(display,DefaultRootWindow(display),&QueryRoot, &QueryChild,&mouseX,&mouseY,&winX,&winY,&mask);

		// Check, if the mouse was moved since the last time
		if ((mouseOldX != mouseX) || (mouseOldY != mouseY))
		{
			// Change the position of the mouse window to x+1 and y+1. +1 because without the normal mouse wouldn't be able to click on things anymore.
			windowChanges.x = mouseX+1;
			windowChanges.y = mouseY+1;
			XConfigureWindow(display, mouseWindow, CWX | CWY, &windowChanges);

			// Store the new mouse coordinates
			mouseOldX = mouseX;
			mouseOldY = mouseY;

			// Update the display
			XFlush(display);
		}

		// Make a pause of 1/100 seconds to save
		usleep(10000);
	}
}
