#!/usr/bin/env python
"""
Client: Positive Trace
Engineer: Jaimi Becker
File: python weekly_spread.py
Create Date: 10/20/2017
Last Update: 10/20/2017
Desc: calculate the days since a given day.
"""

from datetime import date
y,m,d = 1968,5,11
print ('YYYY: ',y)
print ('MM: ',m)
print ('DD: ',d)
f_date = date(y,m,d)
l_date = date.today()
print("DOB: ", f_date)    
print("Today: ", l_date)    
delta = l_date - f_date
print("Delta:", delta.days)
num_weeks = (delta.days/7)
print("Num Weeks:", num_weeks)
weekly_spread = num_weeks % 90
print("Weekly Spread:", weekly_spread)
