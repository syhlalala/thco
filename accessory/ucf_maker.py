import io
import re

dct = {'ram1_data[12]': 'L17', 'switch[10]': 'V2', 'ram2_addr[10]': 'T18', 'ram2_data[10]': 'P13', 'ram1_addr[8]': 'F17', 'ram2_data[6]': 'R14', 'ram2_addr[9]': 'T17', 'flash_data[6]': 'H4', 'ram2_addr[14]': 'V12', 'ram1_addr[14]': 'H14', 'tsre': 'N9', 'flash_addr[3]': 'R2', 'oLed[5]': 'D11', 'flash_data[14]': 'F2', 'ram1_data[1]': 'J13', 'clk': 'U9', 'wrn': 'U5', 'flash_addr[21]': 'K5', 'flash_addr[18]': 'L2', 'switch[4]': 'M1', 'flash_data[2]': 'J2', 'flash_rp': 'D1', 'flash_addr[12]': 'M4', 'ram2_addr[0]': 'N14', 'flash_we': 'D4', 'flash_addr[19]': 'L1', 'ram1_data[6]': 'K12', 'ram2_data[11]': 'P12', 'ram2_addr[13]': 'V13', 'ram1_data[9]': 'K15', 'flash_data[5]': 'H5', 'ram1_addr[15]': 'H15', 'red[1]': 'C3', 'ram2_data[5]': 'R13', 'ram1_data[11]': 'L16', 'ram1_addr[7]': 'F15', 'flash_addr[10]': 'M6', 'red[2]': 'A4', 'oLed[6]': 'E11', 'flash_addr[20]': 'K6', 'switch[5]': 'N1', 'flash_addr[11]': 'M5', 'flash_ce': 'E4', 'ram1_addr[6]': 'F14', 'ram2_addr[1]': 'N15', 'flash_addr[14]': 'L6', 'iKey[3]': 'U14', 'oLed[15]': 'A14', 'ram1_data[2]': 'J14', 'switch[12]': 'V4', 'ram1_data[14]': 'M13', 'ram2_data[0]': 'U13', 'flash_byte': 'C1', 'flash_data[0]': 'J5', 'flash_oe': 'E1', 'ram2_addr[16]': 'U16', 'ram1_addr[12]': 'G15', 'ram2_addr[2]': 'N18', 'ram2_addr[5]': 'P18', 'red[0]': 'A7', 'ram1_addr[2]': 'D16', 'ram2_data[15]': 'N11', 'oLed[3]': 'B11', 'flash_data[8]': 'H2', 'ram2_we': 'M9', 'tbre': 'D14', 'switch[6]': 'N2', 'switch[11]': 'V3', 'flash_addr[2]': 'R3', 'ps2clock': 'U6', 'ram2_data[7]': 'R12', 'ram1_data[13]': 'L18', 'green[0]': 'B4', 'ps2data': 'V6', 'ram1_addr[9]': 'F18', 'ram1_data[8]': 'K14', 'ram2_addr[8]': 'R18', 'flash_data[7]': 'H3', 'oLed[14]': 'E13', 'ram1_addr[13]': 'G16', 'ram1_addr[0]': 'C17', 'flash_addr[13]': 'M3', 'ram2_addr[3]': 'P16', 'ram1_data[0]': 'J12', 'oLed[4]': 'C11', 'flash_data[15]': 'F1', 'green[2]': 'C5', 'switch[7]': 'R1', 'iKey[4]': 'U11', 'flash_addr[22]': 'K4', 'rdn': 'C14', 'oLed[13]': 'D13', 'iKey[1]': 'V16', 'ram1_addr[10]': 'G13', 'ram2_oe': 'R9', 'flash_addr[7]': 'P1', 'oLed[9]': 'E12', 'switch[9]': 'U1', 'ram2_data[12]': 'P11', 'blue[2]': 'B6', 'ram2_data[2]': 'T15', 'flash_addr[5]': 'P3', 'ram2_addr[17]': 'U15', 'switch[14]': 'R7', 'ram2_addr[15]': 'V9', 'green[1]': 'C4', 'flash_addr[16]': 'L4', 'flash_data[10]': 'G6', 'ram2_addr[4]': 'P17', 'oLed[1]': 'E10', 'ram2_data[14]': 'N12', 'ram2_data[8]': 'R11', 'ram1_data[5]': 'J17', 'switch[0]': 'J6', 'oLed[12]': 'B13', 'ram1_addr[11]': 'G14', 'flash_addr[4]': 'P4', 'flash_vpen': 'C2', 'vs': 'E6', 'switch[13]': 'U8', 'ram2_data[1]': 'T16', 'ram1_data[15]': 'M14', 'ram1_addr[4]': 'E15', 'rst': 'U10', 'flash_data[1]': 'J4', 'flash_addr[15]': 'L5', 'ram1_addr[1]': 'C18', 'flash_data[11]': 'G5', 'flash_data[13]': 'G3', 'ram1_addr[3]': 'D17', 'oLed[2]': 'A11', 'ram1_en': 'M15', 'hs': 'D6', 'flash_data[9]': 'H1', 'switch[1]': 'J7', 'oLed[0]': 'D10', 'iKey[2]': 'V14', 'oLed[11]': 'A13', 'ram2_addr[12]': 'V15', 'blue[0]': 'D5', 'flash_data[4]': 'H6', 'ram1_addr[16]': 'H16', 'flash_addr[1]': 'T1', 'ram1_data[10]': 'L15', 'ram2_data[4]': 'T12', 'switch[2]': 'K2', 'flash_addr[8]': 'N5', 'data_ready': 'A16', 'oLed[7]': 'F11', 'ram1_we': 'M18', 'ram1_data[3]': 'J15', 'ram2_addr[6]': 'R15', 'ram2_en': 'N10', 'ram2_data[9]': 'R10', 'ram1_data[7]': 'K13', 'ram2_data[13]': 'P10', 'oLed[8]': 'A12', 'flash_data[3]': 'J1', 'ram2_addr[11]': 'U18', 'blue[1]': 'A6', 'flash_addr[6]': 'P2', 'oLed[10]': 'F12', 'ram1_addr[17]': 'H17', 'switch[8]': 'R4', 'ram2_data[3]': 'T14', 'flash_data[12]': 'G4', 'switch[15]': 'T7', 'ram1_data[4]': 'J16', 'flash_addr[9]': 'N4', 'clk_right': 'B9', 'switch[3]': 'K7', 'ram1_oe': 'M16', 'flash_addr[17]': 'L3', 'ram2_addr[7]': 'R16', 'ram1_addr[5]': 'E16'}

source = file(raw_input(), 'r').read()

word_filter = re.compile(r"\sentity\s.*?\send", re.S)
text1 = word_filter.search(source).group()

split_filter = re.compile(r"\W*")

word_list = split_filter.split(text1)

rst = []
for i in word_list:
	for k in dct:
		index = k.find(i)
		if i!= "" and index == 0 and (len(k) == len(i) or k[len(i)] == '['):
			#print k, i
			rst.append('NET "'+k+'" LOC = '+dct[k]+';')


rst = {}.fromkeys(rst).keys()  

rst.sort()



print '\n'.join(rst)