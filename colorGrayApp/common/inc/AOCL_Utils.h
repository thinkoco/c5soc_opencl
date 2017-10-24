// Copyright (C) 2013-2014 Altera Corporation, San Jose, California, USA. All rights reserved. 
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

#ifndef AOCL_UTILS_H
#define AOCL_UTILS_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>

#include "CL/opencl.h"

namespace aocl_utils {

// Host allocation functions
void *alignedMalloc(size_t size);
void alignedFree(void *ptr);

// Error functions
void printError(cl_int error);
void _checkError(int line,
								 const char *file,
								 cl_int error,
                 const char *msg,
                 ...); // does not return
#define checkError(status, ...) _checkError(__LINE__, __FILE__, status, __VA_ARGS__)

// Sets the current working directory to the same directory that contains
// this executable. Returns true on success.
bool setCwdToExeDir();

// Find a platform that contains the search string in its name (case-insensitive match).
// Returns NULL if no match is found.
cl_platform_id findPlatform(const char *platform_name_search);

// Returns the name of the platform.
std::string getPlatformName(cl_platform_id pid);

// Returns the name of the device.
std::string getDeviceName(cl_device_id did);

// Returns an array of device ids for the given platform and the
// device type.
// Return value must be freed with delete[].
cl_device_id *getDevices(cl_platform_id pid, cl_device_type dev_type, cl_uint *num_devices);

// Create a OpenCL program from a binary file.
// The program is created for all given devices associated with the context. The same
// binary is used for all devices.
cl_program createProgramFromBinary(cl_context context, const char *binary_file_name, const cl_device_id *devices, unsigned num_devices);

// Load binary file.
// Return value must be freed with delete[].
unsigned char *loadBinaryFile(const char *file_name, size_t *size);

// Checks if a file exists.
bool fileExists(const char *file_name);

// Returns the path to the AOCX file to use for the given device.
// This is special handling for examples for the Altera SDK for OpenCL.
// It uses the device name to get the board name and then looks for a
// corresponding AOCX file. Specifically, it gets the device name and
// extracts the board name assuming the device name has the following format:
//  <board> : ...
//
// Then the AOCX file is <prefix>_<version>_<board>.aocx. If this
// file does not exist, then the file name defaults to <prefix>.aocx.
std::string getBoardBinaryFile(const char *prefix, cl_device_id device);

// Returns the time from a high-resolution timer in seconds. This value
// can be used with a value returned previously to measure a high-resolution
// time difference.
double getCurrentTimestamp();

// Returns the difference between the CL_PROFILING_COMMAND_END and
// CL_PROFILING_COMMAND_START values of a cl_event object.
// This requires that the command queue associated with the event be created
// with the CL_QUEUE_PROFILING_ENABLE property.
//
// The return value is in nanoseconds.
cl_ulong getStartEndTime(cl_event event);

// Wait for the specified number of milliseconds.
void waitMilliseconds(unsigned ms);

// Smart pointers.
// Interface is essentially the combination of std::auto_ptr and boost's smart pointers,
// along with some small extensions (auto conversion to T*).

// scoped_ptr: assumes pointer was allocated with operator new; destroys with operator delete
template<typename T>
class scoped_ptr {
public:
  typedef scoped_ptr<T> this_type;

  scoped_ptr() : m_ptr(NULL) {}
  scoped_ptr(T *ptr) : m_ptr(ptr) {}
  ~scoped_ptr() { reset(); }

  T *get() const { return m_ptr; }
  operator T *() const { return m_ptr; }
  T *operator ->() const { return m_ptr; }
  T &operator *() const { return *m_ptr; }

  this_type &operator =(T *ptr) { reset(ptr); return *this; }

  void reset(T *ptr = NULL) { delete m_ptr; m_ptr = ptr; }
  T *release() { T *ptr = m_ptr; m_ptr = NULL; return ptr; }

private:
  T *m_ptr;

  // noncopyable
  scoped_ptr(const this_type &);
  this_type &operator =(const this_type &);
};

// scoped_array: assumes pointer was allocated with operator new[]; destroys with operator delete[]
// Also supports allocation/reset with a number, which is the number of
// elements of type T.
template<typename T>
class scoped_array {
public:
  typedef scoped_array<T> this_type;

  scoped_array() : m_ptr(NULL) {}
  scoped_array(T *ptr) : m_ptr(NULL) { reset(ptr); }
  explicit scoped_array(size_t n) : m_ptr(NULL) { reset(n); }
  ~scoped_array() { reset(); }

  T *get() const { return m_ptr; }
  operator T *() const { return m_ptr; }
  T *operator ->() const { return m_ptr; }
  T &operator *() const { return *m_ptr; }
  T &operator [](int index) const { return m_ptr[index]; }

  this_type &operator =(T *ptr) { reset(ptr); return *this; }

  void reset(T *ptr = NULL) { delete[] m_ptr; m_ptr = ptr; }
  void reset(size_t n) { reset(new T[n]); }
  T *release() { T *ptr = m_ptr; m_ptr = NULL; return ptr; }

private:
  T *m_ptr;

  // noncopyable
  scoped_array(const this_type &);
  this_type &operator =(const this_type &);
};

// scoped_aligned_ptr: assumes pointer was allocated with alignedMalloc; destroys with alignedFree
// Also supports allocation/reset with a number, which is the number of
// elements of type T
template<typename T>
class scoped_aligned_ptr {
public:
  typedef scoped_aligned_ptr<T> this_type;

  scoped_aligned_ptr() : m_ptr(NULL) {}
  scoped_aligned_ptr(T *ptr) : m_ptr(NULL) { reset(ptr); }
  explicit scoped_aligned_ptr(size_t n) : m_ptr(NULL) { reset(n); }
  ~scoped_aligned_ptr() { reset(); }

  T *get() const { return m_ptr; }
  operator T *() const { return m_ptr; }
  T *operator ->() const { return m_ptr; }
  T &operator *() const { return *m_ptr; }
  T &operator [](int index) const { return m_ptr[index]; }

  this_type &operator =(T *ptr) { reset(ptr); return *this; }

  void reset(T *ptr = NULL) { if(m_ptr) alignedFree(m_ptr); m_ptr = ptr; }
  void reset(size_t n) { reset((T*) alignedMalloc(sizeof(T) * n)); }
  T *release() { T *ptr = m_ptr; m_ptr = NULL; return ptr; }

private:
  T *m_ptr;

  // noncopyable
  scoped_aligned_ptr(const this_type &);
  this_type &operator =(const this_type &);
};

} // ns aocl_utils

#endif

