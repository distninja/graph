package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"fmt"
	"unsafe"
)

//export Hello
func Hello(name *C.char) *C.char {
	goName := C.GoString(name)
	result := fmt.Sprintf("Hello, %s from Go!", goName)

	// Use C.CString which allocates in C heap, not Go heap
	return C.CString(result)
}

//export FreeString
func FreeString(s *C.char) {
	C.free(unsafe.Pointer(s))
}

func main() {
}
