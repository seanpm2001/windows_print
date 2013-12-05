#
# Author:: Derek Groh (<dgroh@arch.tamu.edu>)
# Cookbook Name:: windows_print
# resource:: printers
#
# Copyright 2013, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
actions :create, :delete

default_action :create

attribute :printer_name, :name_attribute => true, :kind_of => String, :required => true 
attribute :comment, :kind_of => String
attribute :shared, :kind_of => [ TrueClass, FalseClass ],
            :default => false
attribute :driver_name, :kind_of => String
attribute :port_name, :kind_of => String
attribute :ipv4_address, :kind_of => String, :regex => Resolv::IPv4::Regex
attribute :inf_path, :kind_of => String
attribute :version, :kind_of => String, :default => "Type 3 - User Mode"
attribute :environment, :kind_of => String, :default => "x64"
attribute :location, :kind_of => String
attribute :share_name, :kind_of => String