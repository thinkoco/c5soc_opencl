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

#include "Keyboard.h"

// Whether we run demo mode or not
extern unsigned theDemoRunning;

// Callback functions to handle keyboard button state changes
int keyboardPressEvent(SDL_Event* anEvent)
{
  // Cast event to appropriate type
  SDL_KeyboardEvent* aKeyboardEvent = (SDL_KeyboardEvent*)anEvent;

  // Handle key states
  switch(aKeyboardEvent->keysym.sym)
  {
    // Program exit case
    case SDLK_q:
      // Exit event pushed to the queue when requested
      SDL_Event anExitEvent;
      anExitEvent.type = SDL_QUIT;
      SDL_PushEvent(&anExitEvent);
      break;

    // Switch between hardware and software calculation
    case SDLK_h:
      mandelbrotSwitchCalculationMethod();
      break;

    // Switch demo mode on and off
    case SDLK_d:
        theDemoRunning = !theDemoRunning;
      break;

    // Reset to original view location
    case SDLK_r:
      mandelbrotWindowResetView();
      break;

    // Default case does nothing
    default:
      break;
  }

  // return success
  return 0;
}
