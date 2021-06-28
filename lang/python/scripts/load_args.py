# python load_args.py

import sys
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

if __name__ == '__main__':
    args = load_args()
    print(args)

