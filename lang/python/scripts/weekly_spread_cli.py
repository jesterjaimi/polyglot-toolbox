#!/usr/bin/env python
"""
Client: Positive Trace
Engineer: Jaimi Becker
File: weekly_spread_cli.py
Create Date: 10/23/2017
Last Update: 10/23/2017
Desc: cli program to calculate the weekly playing card spread for a given birthday.
eg: ./weekly_spread_cli.py -MM 05 -DD 11 -YYYY 1968
"""
from datetime import date
import argparse

def load_args():
    parser = argparse.ArgumentParser(description='Script to learn basic argparse')
    parser.add_argument('-DD', '--day',
                        help="Day of Birth in 'DD' format",
                        required='True',
                        type=int,
                        default=5)
    parser.add_argument('-MM', '--month',
                        help= "Month of Birth in 'MM' format",
                        required='True',
                        type=int,
                        default=11)
    parser.add_argument('-YYYY', '--year',
                        help= "Year of Birth in 'YYYY' format",
                        required='True',
                        type=int,
                        default=1968)
    return parser.parse_args()

def main():
    args = load_args()
    y,m,d = args.year,args.month,args.day 
    print ('YYYY: ',y)
    print ('MM: ',m)
    print ('DD: ',d)
    f_date = date(y, m, d)
    l_date = date.today()    
    print("DOB: ", f_date)    
    print("Today: ", l_date)    
    delta = l_date - f_date
    print("Delta:", delta.days)
    num_weeks = (delta.days/7)
    print("Num Weeks:", num_weeks)
    weekly_spread = num_weeks % 90
    print("Weekly Spread:", weekly_spread)

if __name__ == '__main__':
    main()
