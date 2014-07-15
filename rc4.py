#!/usr/bin/env python
#-*- coding:utf-8 -*-

from Crypto.Cipher import ARC4

keyfp = open('key.txt', 'r')
textfp = open('text.txt', 'r')
res = open("py.txt", "w")

for i in xrange(10000):
    key = keyfp.readline().replace("\n","")
    text = textfp.readline().replace("\n","")

    s = ARC4.new(key).encrypt(text)
    res.write("%s\n" % s)

