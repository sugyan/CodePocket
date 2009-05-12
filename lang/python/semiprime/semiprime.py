#!/usr/bin/env python
# -*- coding:utf-8 -*-

def get_factor(target):
    for index in range(2, target-1):
        if target % index == 0:
            return index

if __name__ == '__main__':
    for target in range(1, 100):
        factor = get_factor(target)
        if factor and get_factor(target / factor) == None:
            print target
