OCFileController
================

Support class for handling common file operations

This class takes a number of common file operations requiring lots of code and
 streamlining them down to a single line. Many assumptions are made about needs,
 requirements, and error handling, but there are always compromises when doing
 this sort of thing.

 Some of these are very basic, high-level actions, but some stem from fairly specific
 scenarios I have needed many times.

 About error handling:
 * Nil will always be returned on any error unless otherwise noted.
 * Functions assume values being passed are valid. Unless a passed value is nil, Xcode will take over during debugging.