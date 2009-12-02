#! /usr/bin/env python
# -*- encoding:utf-8 -*-
# FileName: create_calendar.py

"这个文件用来批量创建Google Calendar的读经伴侣日历--全年读经计划，每个条目每年都重复执行。"
 
__author__   = "yetist"
__copyright__= "Copyright (C) 2009 yetist <yetist@gmail.com>"
__license__  = """
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import gdata.calendar.service
import gdata.service
import atom.service
import gdata.calendar
import atom
import time
import datetime
import sys

class _MyDate:
    def __init__ (self, year=2009, month=1, day=1):
        self.first = datetime.date(year, month, day)
        self.current = time.mktime(self.first.timetuple())

    def day(self):
        a=time.localtime(self.current)
        out = "%d%02d%02d" % (a.tm_year, a.tm_mon, a.tm_mday)
        return out

    def nextday(self):
        a=time.localtime(self.current + 3600 * 24)
        out = "%d%02d%02d" % (a.tm_year, a.tm_mon, a.tm_mday)
        return out

    def next(self):
        self.current = self.current + 3600 * 24

    def id(self):
        a=time.localtime(self.current)
        return a.tm_yday

class MyCalendar:
    def __init__ (self, email, passwd):
        self.cal_client = gdata.calendar.service.CalendarService()
        self.cal_client.email = email
        self.cal_client.password = passwd
        self.cal_client.source = 'Google-Calendar_Python_Sample-1.0'
        self.cal_client.ProgrammaticLogin()

    def get_calendar_url_by_title(self, title):
        feed = self.cal_client.GetAllCalendarsFeed()
        for i, a_calendar in zip(xrange(len(feed.entry)), feed.entry):
            if a_calendar.title.text == title:
                url = a_calendar.content.src
                #url = a_calendar.GetAlternateLink().href
        host = "http://www.google.com"
        if url.find(host) == 0:
            return url[len(host):]

    def _InsertEvent(self, title='title', content='content', where='',
        start_time=None, end_time=None, recurrence_data=None,
        url='/calendar/feeds/default/private/full'):

        event = gdata.calendar.CalendarEventEntry()
        event.title = atom.Title(text=title)
        event.content = atom.Content(text=content)
        event.where.append(gdata.calendar.Where(value_string=where))

        if recurrence_data is not None:
          # Set a recurring event
          event.recurrence = gdata.calendar.Recurrence(text=recurrence_data)
        else:
          if start_time is None:
            # Use current time for the start_time and have the event last 1 hour
            start_time = time.strftime('%Y-%m-%dT%H:%M:%S.000Z', time.gmtime())
            end_time = time.strftime('%Y-%m-%dT%H:%M:%S.000Z', 
                time.gmtime(time.time() + 3600))
          event.when.append(gdata.calendar.When(start_time=start_time, 
              end_time=end_time))

        new_event = self.cal_client.InsertEvent(event, url)
    
    def insert_event(self, calendar, title, content, where, start_time, end_time, recurrence_data):
        url = self.get_calendar_url_by_title(calendar)
        self._InsertEvent(title, content, where, start_time, end_time, recurrence_data, url)

def main():
    dd = _MyDate(2009,1,1)
    buf = open("header.txt").read()
    lines={}
    ord=[]
    for i in buf.splitlines():
        n=i.split("#")
        lines[n[0]] = {}
        lines[n[0]]["title"] = n[1]
        ord.append(n[0])
        #lines.append(i.split("\n")[1])

    buf = open("content.txt").read()
    for i in buf.splitlines():
        n=i.split("#")
        lines[n[0]]["content"] = n[1]

    for i in lines.keys():
        pass
        #print i,lines[i]

    print len(ord)
    #sys.exit(0)
    email="your@gmail.com"
    password="password"

    cal = MyCalendar(email, password)
    for n in ord:
        print n
        recurrence_data = ('DTSTART;VALUE=DATE:%s\r\nDTEND;VALUE=DATE:%s\r\nRRULE:FREQ=YEARLY\r\n' % (dd.day(), dd.nextday()))
        print lines[n]['title'], "<<<>>>",  lines[n]['content']
        #print "cal.insert_event(calendar=\"读经伴侣\", title=",lines[n]['title'],", content=",lines[n]['content'],", where='', start_time=",dd.day(),", end_time=",dd.day(),", recurrence_data=",recurrence_data")"
        cal.insert_event(calendar="读经伴侣", title=lines[n]['title'], content=lines[n]['content'], where='', start_time=dd.day(), end_time=dd.day(), recurrence_data=recurrence_data)
        dd.next()
main()
