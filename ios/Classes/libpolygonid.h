/* Code generated by cmd/cgo; DO NOT EDIT. */

/* package github.com/0xPolygonID/c-polygonid/cmd/polygonid */


#line 1 "cgo-builtin-export-prolog"

#include <stddef.h>

#ifndef GO_CGO_EXPORT_PROLOGUE_H
#define GO_CGO_EXPORT_PROLOGUE_H

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef struct { const char *p; ptrdiff_t n; } _GoString_;
#endif

#endif

/* Start of preamble from import "C" comments.  */


#line 3 "polygonid.go"

#include <stdlib.h>
#include <string.h>

typedef enum
{
	PLGNSTATUSCODE_ERROR,
	PLGNSTATUSCODE_NIL_POINTER,
} PLGNStatusCode;

typedef struct _PLGNStatus
{
	PLGNStatusCode status;
	char *error_msg;
} PLGNStatus;

#line 1 "cgo-generated-wrapper"


/* End of preamble from import "C" comments.  */


/* Start of boilerplate cgo prologue.  */
#line 1 "cgo-gcc-export-header-prolog"

#ifndef GO_CGO_PROLOGUE_H
#define GO_CGO_PROLOGUE_H

typedef signed char GoInt8;
typedef unsigned char GoUint8;
typedef short GoInt16;
typedef unsigned short GoUint16;
typedef int GoInt32;
typedef unsigned int GoUint32;
typedef long long GoInt64;
typedef unsigned long long GoUint64;
typedef GoInt64 GoInt;
typedef GoUint64 GoUint;
typedef size_t GoUintptr;
typedef float GoFloat32;
typedef double GoFloat64;
#ifdef _MSC_VER
#include <complex.h>
typedef _Fcomplex GoComplex64;
typedef _Dcomplex GoComplex128;
#else
typedef float _Complex GoComplex64;
typedef double _Complex GoComplex128;
#endif

/*
  static assertion to make sure the file is being used on architecture
  at least with matching size of GoInt.
*/
typedef char _check_for_64_bit_pointer_matching_GoInt[sizeof(void*)==64/8 ? 1:-1];

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef _GoString_ GoString;
#endif
typedef void *GoMap;
typedef void *GoChan;
typedef struct { void *t; void *v; } GoInterface;
typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;

#endif

/* End of boilerplate cgo prologue.  */

#ifdef __cplusplus
extern "C" {
#endif

extern GoUint8 PLGNAuthV2InputsMarshal(char** jsonResponse, char* in, PLGNStatus** status);
extern GoUint8 PLGNCalculateGenesisID(char** jsonResponse, char* in, PLGNStatus** status);
extern GoUint8 PLGNCreateClaim(char** jsonResponse, char* in, PLGNStatus** status);

// PLGNIDToInt returns the ID as a big int string
// Input should be a valid JSON object: string enclosed by double quotes.
// Output is a valid JSON object to: string enclosed by double quotes.
//
extern GoUint8 PLGNIDToInt(char** jsonResponse, char* in, PLGNStatus** status);
extern GoUint8 PLGNProofFromSmartContract(char** jsonResponse, char* in, PLGNStatus** status);
extern GoUint8 PLGNProfileID(char** jsonResponse, char* in, PLGNStatus** status);

// PLGNAtomicQuerySigV2Inputs returns the inputs for the
// credentialAtomicQuerySigV2 with optional selective disclosure.
//
// Additional configuration may be required for Reverse Hash Service
// revocation validation. In other case cfg may be nil.
//
// Sample configuration:
//
//	{
//	 "ethereumUrl": "http://localhost:8545",
//	 "stateContractAddr": "0xEA9aF2088B4a9770fC32A12fD42E61BDD317E655",
//	 "reverseHashServiceUrl": "http://localhost:8003"
//	}
//
extern GoUint8 PLGNAtomicQuerySigV2Inputs(char** jsonResponse, char* in, char* cfg, PLGNStatus** status);

// PLGNSigV2Inputs returns the inputs for the Sig circuit v2 with
// optional selective disclosure.
//
// Deprecated: Does not support Reverse Hash Service credential status
// validation! Use PLGNAtomicQuerySigV2Inputs method with configuration instead.
//
extern GoUint8 PLGNSigV2Inputs(char** jsonResponse, char* in, PLGNStatus** status);

// PLGNAtomicQueryMtpV2Inputs returns the inputs for the
// credentialAtomicQueryMTPV2 with optional selective disclosure.
//
// Additional configuration may be required for Reverse Hash Service
// revocation validation. In other case cfg may be nil.
//
// Sample configuration:
//
//	{
//	  "ethereumUrl": "http://localhost:8545",
//	  "stateContractAddr": "0xEA9aF2088B4a9770fC32A12fD42E61BDD317E655",
//	  "reverseHashServiceUrl": "http://localhost:8003"
//	}
//
extern GoUint8 PLGNAtomicQueryMtpV2Inputs(char** jsonResponse, char* in, char* cfg, PLGNStatus** status);

// PLGNMtpV2Inputs returns the inputs for the MTP circuit v2 with
// optional selective disclosure.
//
// Deprecated: Does not support Reverse Hash Service credential status
// validation! Use PLGNAtomicQueryMtpV2Inputs method with configuration instead.
//
extern GoUint8 PLGNMtpV2Inputs(char** jsonResponse, char* in, PLGNStatus** status);

// PLGNAtomicQuerySigV2OnChainInputs returns the inputs for the
// credentialAtomicQuerySigV2OnChain circuit with optional selective disclosure.
//
// Additional configuration may be required for Reverse Hash Service
// revocation validation. In other case cfg may be nil.
//
// Sample configuration:
//
//	{
//	  "ethereumUrl": "http://localhost:8545",
//	  "stateContractAddr": "0xEA9aF2088B4a9770fC32A12fD42E61BDD317E655",
//	  "reverseHashServiceUrl": "http://localhost:8003"
//	}
//
extern GoUint8 PLGNAtomicQuerySigV2OnChainInputs(char** jsonResponse, char* in, char* cfg, PLGNStatus** status);

// PLGNAtomicQueryMtpV2OnChainInputs returns the inputs for the
// credentialAtomicQueryMTPV2OnChain circuit with optional selective disclosure.
//
// Additional configuration may be required for Reverse Hash Service
// revocation validation. In other case cfg may be nil.
//
// Sample configuration:
//
//	{
//	  "ethereumUrl": "http://localhost:8545",
//	  "stateContractAddr": "0xEA9aF2088B4a9770fC32A12fD42E61BDD317E655",
//	  "reverseHashServiceUrl": "http://localhost:8003"
//	}
//
extern GoUint8 PLGNAtomicQueryMtpV2OnChainInputs(char** jsonResponse, char* in, char* cfg, PLGNStatus** status);
extern void PLGNFreeStatus(PLGNStatus* status);

#ifdef __cplusplus
}
#endif
