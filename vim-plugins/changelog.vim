" File: changelog.vim
" Summary: This file is a vim plug to add changelog entry.
" Author: Roman Joost, yetist <yetist@gmail.com>
" URL: http://gsnippet.googlecode.com/svn/trunk/vim-plugins/changelog.vim
" License: 
" 
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software
" Foundation, Inc., 59 Temple Place, Suite 330,
" Boston, MA 02111-1307, USA.
" Version: 2007-09-12 00:03:27
" Usage: do :ChangeLog

command! -nargs=* ChangeLog exec('py make_cl_entry(<f-args>)')

python <<EOF
import vim
import os
import commands
import re

from datetime import datetime, date
from types import ListType

svn_regexp = re.compile('[GDMA].{,6}(.*)')
cvs_regexp = re.compile('[PAMR].{,1}(.*)')

class ChangeLog(object):

    def __init__(self, name, email, cvs_command=None, svn_command=None):
        self.name = name 
        self.email = email 
        if cvs_command is not None:
            self.cvs_command = cvs_command
        else:
            self.cvs_command = 'cvs update -dP 2>&1 | grep -v "Updating"'

        if svn_command is not None:
            self.svn_command = svn_command
        else:
            self.svn_command = 'svn st'

    def addChangeLogEntry(self):
        if not self.is_cvs() and not self.is_svn():
            print "You don't seem to be in a CVS or SVN directory."
            return
        
        vim.command('set noexpandtab')
        vim.command('set ts=4')
        vim.command('set enc=utf-8')
        # XXX the print to the buffer is currently reversed once someone
        # figured how this can be done in a better way
        buf = []
        buf.append("%s  %s  <%s>" %(date.isoformat(datetime.today()), self.name, self.email))
        buf.append("")
        buf.extend(self.get_changes())
        vim.current.buffer[0:0] = buf

        #vim.current.window.cursor = 3, len(vim.current.buffer[3]) -1

        # set the cursor to the first entry line
        self.set_cursor()

    def get_changes(self):
        """returns a list of updated files"""
        if self.is_cvs():
            print "Note: Getting filelist from CVS. This can take a while."
            command = self.cvs_command
            regexp = cvs_regexp
        elif self.is_svn():
            command = self.svn_command
            regexp = svn_regexp
        else:
            print "You don't seem to be in a CVS or SVN directory"
            return 

        result = []
        changes = commands.getoutput(command).split('\n')
        for line in changes:
            try:
                result.append('\t* ' + regexp.match(line).group(1) + ": ")
            except AttributeError:
                pass
        return result

    def set_cursor(self):
        """sets the cursor on the end of the first line"""
        vim.current.window.cursor = (3, len(vim.current.buffer[2])-1)

    def get_changelog_date(self):
        """returns an iso formatted date (YYYY-MM-DD)"""
        return date.isoformat(datetime.today())

    def is_cvs(self):
        """checks if we're in a directory which has been checked out of an
           CVS repository
        """
        return os.path.exists(os.curdir + '/CVS')

    def is_svn(self):
        """checks if we're in a directory which has been checked out of an
           SVN repository
        """
        return os.path.exists(os.curdir + '/.svn')

def get_author():
    ret = {}
    if vim.eval("exists('g:author_name')") == "1":
        ret["name"] = vim.eval("g:author_name")
    else:
        ret["name"] = os.getlogin()
    if vim.eval("exists('g:author_email')") == "1":
        ret["email"] = vim.eval("g:author_email")
    else:
        ret["email"] = "%s@%s" % (ret["name"], os.uname()[1])
    if vim.eval("exists('g:author_url')") == "1":
        ret["url"] = vim.eval("g:author_url")
    else:
        ret["url"]= "http://none"
    if vim.eval("exists('g:author_blog')") == "1":
        ret["blog"] = vim.eval("g:author_blog")
    else:
        ret["blog"]= "http://none"
    return ret

def make_cl_entry(cvs_command=None, svn_command=None):
    auth = get_author()
    cl = ChangeLog(auth["name"], auth["email"], cvs_command, svn_command)
    cl.addChangeLogEntry()
EOF
