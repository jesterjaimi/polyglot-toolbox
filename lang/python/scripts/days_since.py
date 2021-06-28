#!/usr/bin/env python
"""
Client: Positive Trace
Engineer: Jaimi Becker
File: python days_since.py
Create Date: 10/20/2017
Last Update: 10/20/2017
Desc: calculate the days since a given day.
"""

from datetime import date
f_date = date(1968, 5, 11)
l_date = date(2017, 10, 20)
delta = l_date - f_date
print(delta.days)
