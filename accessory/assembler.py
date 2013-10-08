import re
import sys

def com(s):
	if s != None:
		return s
	return ""
def num_down(s):
	s = "000" + s
	return s[len(s)-2 : len(s)]

def num_up(s):
	s = "000" + s
	return s[len(s)-4 : len(s)-2]

push = u"^\s*PUSH\s+(R[0-7])\s*(;.*)?$"
# PUSH R0 ==> ADDSP 0xFF , SW_SP Rx 0x0
assign = u"^\s*(R[0-7])\s*=\s*(R[0-7])\s*(;.*)?$"
# Rx = Ry ==> ADDIU3 Ry Rx 0x0
assign_number = u"^\s*(R[0-7])\s*=\s*0x(\d+)\s*(;.*)?$"
# Rx = 0xABCD ==> LI Rx 0xCD, SLL Rx Rx 0x0, ADDIU Rx 0xAB
pop = u"^\s*POP\s+(R[0-7])\s*(;.*)?$"
# POP R0 ==> LW_SP R0, ADDSP 0x1

text = file(sys.argv[1]).read().split('\n')

for s in text:
	if re.match(push, s) != None:
		rst = re.search(push, s)
		print "ADDSP 0xFF %s"%(com(rst.group(2)))
		print "SW_SP %s 0x0"%(rst.group(1))
	elif re.match(assign, s) != None:
		rst = re.search(assign, s)
		print "ADDIU3 %s %s %s"%(rst.group(2), rst.group(1), com(rst.group(3)))
	elif re.match(assign_number, s) != None:
		rst = re.search(assign_number, s)
		print "LI %s 0x%s %s"%(rst.group(1), num_down(rst.group(2)), com(rst.group(3)))
		print "SLL %s %s 0x0"%(rst.group(1), rst.group(1))
		print "ADDIU %s 0x%s"%(rst.group(1), num_up(rst.group(2)))
	elif re.match(pop, s) != None:
		rst = re.search(pop, s)
		print "LW_SP %s %s"%(rst.group(1), com(rst.group(2)))
		print "ADDSP 0x01"
	else:
		print s