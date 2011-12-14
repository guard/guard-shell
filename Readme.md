# Guard-Shell

This little addition (1 proper line of code!) to guard allows you to run shell
commands when certain files are altered.


## Install
  
Make sure you have [guard](http://github.com/guard/guard) installed.

Install the gem with:

    gem install guard-shell

Add it to your Gemfile:

    gem 'guard-shell'

And then add a basic setup to your Guardfile:

    guard init shell


## Usage

If you can do something in your shell, it is probably very easy to setup with guard-shell, here are a few examples.


#### Creating Backups of Files On Change

    guard 'shell' do
      # create a copy of the file with '.backup' at the end
      watch(/(.*)/) {|m| `cp #{m[0]} #{m[0]}.backup` }
    end


#### Showing git st

    guard 'shell' do
      watch(/.*/) { `git st` }
    end


#### Rebuilding a LaTeX File

    guard 'shell' do
      # builds latex file to pdf and hides output
      watch(/(.*).tex/) do |m| 
        `pdflatex -shell-escape #{m[0]} 1>/dev/null`
        puts "built #{m[1]}.pdf"
      end
    end


#### Saying the Name of the File You Changed

    guard 'shell' do
      watch(/(.*)/) {|m| `say #{m[0]}` }
    end
