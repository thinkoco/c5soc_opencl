// Copyright (C) 2013-2017 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

#include "Mouse.h"

// mouse button state maps (0 = UP, 1 = DOWN)
static char theMouseButtonState[3];

// Window size
extern unsigned int theWidth;
extern unsigned int theHeight;

// Global position variables
extern double theCurrentX;
extern double theCurrentY;
extern double theCurrentScale;

extern double theTargetX;
extern double theTargetY;
extern double theTargetScale;

// Callback functions to handle mouse button state changes
int mousePressEvent(SDL_Event* anEvent)
{
  // Cast event to appropriate type
  SDL_MouseButtonEvent* aMouseButtonEvent = (SDL_MouseButtonEvent*)anEvent;

  // Modify button states
  theMouseButtonState[aMouseButtonEvent->button] = 1;

  // If the Left button is pressed, pan
  if(theMouseButtonState[SDL_BUTTON_LEFT])
  {
    theTargetX = theCurrentX + (((double)aMouseButtonEvent->x)*theCurrentScale - ((double)(theWidth/2))*theTargetScale);
    theTargetY = theCurrentY - (((double)aMouseButtonEvent->y)*theCurrentScale - ((double)(theHeight/2))*theTargetScale);
  }

  // If the Right button is pressed, zoom in
  else if(theMouseButtonState[SDL_BUTTON_RIGHT])
  {
    theTargetScale = theCurrentScale * 0.7;
    theTargetX = theCurrentX + (((double)aMouseButtonEvent->x)*theCurrentScale - ((double)(theWidth/2))*theTargetScale);
    theTargetY = theCurrentY - (((double)aMouseButtonEvent->y)*theCurrentScale - ((double)(theHeight/2))*theTargetScale);
  }

  // If the Middle button is pressed, zoom out
  else if(theMouseButtonState[SDL_BUTTON_MIDDLE])
  {
    theTargetScale = theCurrentScale * 1.4286;
    theTargetX = theCurrentX + (((double)aMouseButtonEvent->x)*theCurrentScale - ((double)(theWidth/2))*theTargetScale);
    theTargetY = theCurrentY - (((double)aMouseButtonEvent->y)*theCurrentScale - ((double)(theHeight/2))*theTargetScale);
  }

  // return success
  return 0;
}

int mouseReleaseEvent(SDL_Event* anEvent)
{
  // Cast event to appropriate type
  SDL_MouseButtonEvent* aMouseButtonEvent = (SDL_MouseButtonEvent*)anEvent;

  // Modify button states
  theMouseButtonState[aMouseButtonEvent->button] = 0;

  // return success
  return 0;
}
