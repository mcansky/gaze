# Gaze And The Use Of It
A very mellow start to begin with, and so it goes:

## Installation

    git clone http://github.com/mcansky/gaze.git
    bundle install

## Use

You can rackup once you got a bundle install done
    
.. after which the mighty, mighty browser is pointed towards [http://localhost:4567](http://localhost:4567)
and all the fine Markdown-files shows up like perfectly pristine HTML pages.

## Requirements Are OK
    
    require 'sinatra'
    require 'haml'

Check the Gemfile for more.
    
## Formatting

gaze supports Markdown or Textile. Use the one you like best. Or both.

    require 'maruku' # Markdown
    require 'RedCloth' # Textile

## Punch me! With a Fork!

Copyright (c) 2008, 2009, 2010 Harry Vangberg, Mikkel Malmberg

Copyright (c) 2011 Thomas 'mcansky' Riboulet

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
