// Contents of DLLDefines.h
#ifndef PCRecognition_DLLDEFINES_H_
#define PCRecognition_DLLDEFINES_H_

#if defined(SHARED_LIBS) && (defined (_WIN32) ||  defined (_WIN64))
	#if defined(dockerandjenkinslib_EXPORTS)
		#define  DLL_EXPORT __declspec(dllexport)
	#else
		#define  DLL_EXPORT __declspec(dllimport)
	#endif 
#else 
	#define DLL_EXPORT
#endif

#endif