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

 License
 =======

 Copyright 2013 Philip Regan, http://www.oatmealandcoffee.com

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.