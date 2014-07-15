#!/usr/bin/env python
#-*- coding:utf-8 -*-

import string
import random

chars = string.letters
case = 10000

keyfp = open('key.txt', 'w')
textfp = open('text.txt', 'w')

for i in xrange(case):
    key = ''.join(random.sample(chars, 20))
    text = ''.join(random.sample(chars, 40))
    keyfp.write('%s\n' % key)
    textfp.write('%s\n' % text)

keyfp.close()
textfp.close()
