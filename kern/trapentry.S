/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 * https://pdos.csail.mit.edu/6.828/2018/readings/i386/s09_10.htm
 */
TRAPHANDLER_NOEC(vector0, 0)
TRAPHANDLER_NOEC(vector1, 1)
TRAPHANDLER_NOEC(vector2, 2)
TRAPHANDLER_NOEC(vector3, 3)
TRAPHANDLER_NOEC(vector4, 4)
TRAPHANDLER_NOEC(vector5, 5)
TRAPHANDLER_NOEC(vector6, 6)
TRAPHANDLER_NOEC(vector7, 7)
TRAPHANDLER(vector8, 8)
TRAPHANDLER_NOEC(vector9, 9)
TRAPHANDLER(vector10, 10)
TRAPHANDLER(vector11, 11)
TRAPHANDLER(vector12, 12)
TRAPHANDLER(vector13, 13)
TRAPHANDLER(vector14, 14)
TRAPHANDLER_NOEC(vector15, 15)
TRAPHANDLER_NOEC(vector16, 16)
TRAPHANDLER_NOEC(vector17, 17)
TRAPHANDLER_NOEC(vector18, 18)
TRAPHANDLER_NOEC(vector19, 19)
TRAPHANDLER_NOEC(vector20, 20)
TRAPHANDLER_NOEC(vector21, 21)
TRAPHANDLER_NOEC(vector22, 22)
TRAPHANDLER_NOEC(vector23, 23)
TRAPHANDLER_NOEC(vector24, 24)
TRAPHANDLER_NOEC(vector25, 25)
TRAPHANDLER_NOEC(vector26, 26)
TRAPHANDLER_NOEC(vector27, 27)
TRAPHANDLER_NOEC(vector28, 28)
TRAPHANDLER_NOEC(vector29, 29)
TRAPHANDLER_NOEC(vector30, 30)
TRAPHANDLER_NOEC(vector31, 31)
TRAPHANDLER_NOEC(vector32, 32)
TRAPHANDLER_NOEC(vector33, 33)
TRAPHANDLER_NOEC(vector34, 34)
TRAPHANDLER_NOEC(vector35, 35)
TRAPHANDLER_NOEC(vector36, 36)
TRAPHANDLER_NOEC(vector37, 37)
TRAPHANDLER_NOEC(vector38, 38)
TRAPHANDLER_NOEC(vector39, 39)
TRAPHANDLER_NOEC(vector40, 40)
TRAPHANDLER_NOEC(vector41, 41)
TRAPHANDLER_NOEC(vector42, 42)
TRAPHANDLER_NOEC(vector43, 43)
TRAPHANDLER_NOEC(vector44, 44)
TRAPHANDLER_NOEC(vector45, 45)
TRAPHANDLER_NOEC(vector46, 46)
TRAPHANDLER_NOEC(vector47, 47)
TRAPHANDLER_NOEC(vector48, 48)
TRAPHANDLER_NOEC(vector49, 49)
TRAPHANDLER_NOEC(vector50, 50)
TRAPHANDLER_NOEC(vector51, 51)
TRAPHANDLER_NOEC(vector52, 52)
TRAPHANDLER_NOEC(vector53, 53)
TRAPHANDLER_NOEC(vector54, 54)
TRAPHANDLER_NOEC(vector55, 55)
TRAPHANDLER_NOEC(vector56, 56)
TRAPHANDLER_NOEC(vector57, 57)
TRAPHANDLER_NOEC(vector58, 58)
TRAPHANDLER_NOEC(vector59, 59)
TRAPHANDLER_NOEC(vector60, 60)
TRAPHANDLER_NOEC(vector61, 61)
TRAPHANDLER_NOEC(vector62, 62)
TRAPHANDLER_NOEC(vector63, 63)
TRAPHANDLER_NOEC(vector64, 64)
TRAPHANDLER_NOEC(vector65, 65)
TRAPHANDLER_NOEC(vector66, 66)
TRAPHANDLER_NOEC(vector67, 67)
TRAPHANDLER_NOEC(vector68, 68)
TRAPHANDLER_NOEC(vector69, 69)
TRAPHANDLER_NOEC(vector70, 70)
TRAPHANDLER_NOEC(vector71, 71)
TRAPHANDLER_NOEC(vector72, 72)
TRAPHANDLER_NOEC(vector73, 73)
TRAPHANDLER_NOEC(vector74, 74)
TRAPHANDLER_NOEC(vector75, 75)
TRAPHANDLER_NOEC(vector76, 76)
TRAPHANDLER_NOEC(vector77, 77)
TRAPHANDLER_NOEC(vector78, 78)
TRAPHANDLER_NOEC(vector79, 79)
TRAPHANDLER_NOEC(vector80, 80)
TRAPHANDLER_NOEC(vector81, 81)
TRAPHANDLER_NOEC(vector82, 82)
TRAPHANDLER_NOEC(vector83, 83)
TRAPHANDLER_NOEC(vector84, 84)
TRAPHANDLER_NOEC(vector85, 85)
TRAPHANDLER_NOEC(vector86, 86)
TRAPHANDLER_NOEC(vector87, 87)
TRAPHANDLER_NOEC(vector88, 88)
TRAPHANDLER_NOEC(vector89, 89)
TRAPHANDLER_NOEC(vector90, 90)
TRAPHANDLER_NOEC(vector91, 91)
TRAPHANDLER_NOEC(vector92, 92)
TRAPHANDLER_NOEC(vector93, 93)
TRAPHANDLER_NOEC(vector94, 94)
TRAPHANDLER_NOEC(vector95, 95)
TRAPHANDLER_NOEC(vector96, 96)
TRAPHANDLER_NOEC(vector97, 97)
TRAPHANDLER_NOEC(vector98, 98)
TRAPHANDLER_NOEC(vector99, 99)
TRAPHANDLER_NOEC(vector100, 100)
TRAPHANDLER_NOEC(vector101, 101)
TRAPHANDLER_NOEC(vector102, 102)
TRAPHANDLER_NOEC(vector103, 103)
TRAPHANDLER_NOEC(vector104, 104)
TRAPHANDLER_NOEC(vector105, 105)
TRAPHANDLER_NOEC(vector106, 106)
TRAPHANDLER_NOEC(vector107, 107)
TRAPHANDLER_NOEC(vector108, 108)
TRAPHANDLER_NOEC(vector109, 109)
TRAPHANDLER_NOEC(vector110, 110)
TRAPHANDLER_NOEC(vector111, 111)
TRAPHANDLER_NOEC(vector112, 112)
TRAPHANDLER_NOEC(vector113, 113)
TRAPHANDLER_NOEC(vector114, 114)
TRAPHANDLER_NOEC(vector115, 115)
TRAPHANDLER_NOEC(vector116, 116)
TRAPHANDLER_NOEC(vector117, 117)
TRAPHANDLER_NOEC(vector118, 118)
TRAPHANDLER_NOEC(vector119, 119)
TRAPHANDLER_NOEC(vector120, 120)
TRAPHANDLER_NOEC(vector121, 121)
TRAPHANDLER_NOEC(vector122, 122)
TRAPHANDLER_NOEC(vector123, 123)
TRAPHANDLER_NOEC(vector124, 124)
TRAPHANDLER_NOEC(vector125, 125)
TRAPHANDLER_NOEC(vector126, 126)
TRAPHANDLER_NOEC(vector127, 127)
TRAPHANDLER_NOEC(vector128, 128)
TRAPHANDLER_NOEC(vector129, 129)
TRAPHANDLER_NOEC(vector130, 130)
TRAPHANDLER_NOEC(vector131, 131)
TRAPHANDLER_NOEC(vector132, 132)
TRAPHANDLER_NOEC(vector133, 133)
TRAPHANDLER_NOEC(vector134, 134)
TRAPHANDLER_NOEC(vector135, 135)
TRAPHANDLER_NOEC(vector136, 136)
TRAPHANDLER_NOEC(vector137, 137)
TRAPHANDLER_NOEC(vector138, 138)
TRAPHANDLER_NOEC(vector139, 139)
TRAPHANDLER_NOEC(vector140, 140)
TRAPHANDLER_NOEC(vector141, 141)
TRAPHANDLER_NOEC(vector142, 142)
TRAPHANDLER_NOEC(vector143, 143)
TRAPHANDLER_NOEC(vector144, 144)
TRAPHANDLER_NOEC(vector145, 145)
TRAPHANDLER_NOEC(vector146, 146)
TRAPHANDLER_NOEC(vector147, 147)
TRAPHANDLER_NOEC(vector148, 148)
TRAPHANDLER_NOEC(vector149, 149)
TRAPHANDLER_NOEC(vector150, 150)
TRAPHANDLER_NOEC(vector151, 151)
TRAPHANDLER_NOEC(vector152, 152)
TRAPHANDLER_NOEC(vector153, 153)
TRAPHANDLER_NOEC(vector154, 154)
TRAPHANDLER_NOEC(vector155, 155)
TRAPHANDLER_NOEC(vector156, 156)
TRAPHANDLER_NOEC(vector157, 157)
TRAPHANDLER_NOEC(vector158, 158)
TRAPHANDLER_NOEC(vector159, 159)
TRAPHANDLER_NOEC(vector160, 160)
TRAPHANDLER_NOEC(vector161, 161)
TRAPHANDLER_NOEC(vector162, 162)
TRAPHANDLER_NOEC(vector163, 163)
TRAPHANDLER_NOEC(vector164, 164)
TRAPHANDLER_NOEC(vector165, 165)
TRAPHANDLER_NOEC(vector166, 166)
TRAPHANDLER_NOEC(vector167, 167)
TRAPHANDLER_NOEC(vector168, 168)
TRAPHANDLER_NOEC(vector169, 169)
TRAPHANDLER_NOEC(vector170, 170)
TRAPHANDLER_NOEC(vector171, 171)
TRAPHANDLER_NOEC(vector172, 172)
TRAPHANDLER_NOEC(vector173, 173)
TRAPHANDLER_NOEC(vector174, 174)
TRAPHANDLER_NOEC(vector175, 175)
TRAPHANDLER_NOEC(vector176, 176)
TRAPHANDLER_NOEC(vector177, 177)
TRAPHANDLER_NOEC(vector178, 178)
TRAPHANDLER_NOEC(vector179, 179)
TRAPHANDLER_NOEC(vector180, 180)
TRAPHANDLER_NOEC(vector181, 181)
TRAPHANDLER_NOEC(vector182, 182)
TRAPHANDLER_NOEC(vector183, 183)
TRAPHANDLER_NOEC(vector184, 184)
TRAPHANDLER_NOEC(vector185, 185)
TRAPHANDLER_NOEC(vector186, 186)
TRAPHANDLER_NOEC(vector187, 187)
TRAPHANDLER_NOEC(vector188, 188)
TRAPHANDLER_NOEC(vector189, 189)
TRAPHANDLER_NOEC(vector190, 190)
TRAPHANDLER_NOEC(vector191, 191)
TRAPHANDLER_NOEC(vector192, 192)
TRAPHANDLER_NOEC(vector193, 193)
TRAPHANDLER_NOEC(vector194, 194)
TRAPHANDLER_NOEC(vector195, 195)
TRAPHANDLER_NOEC(vector196, 196)
TRAPHANDLER_NOEC(vector197, 197)
TRAPHANDLER_NOEC(vector198, 198)
TRAPHANDLER_NOEC(vector199, 199)
TRAPHANDLER_NOEC(vector200, 200)
TRAPHANDLER_NOEC(vector201, 201)
TRAPHANDLER_NOEC(vector202, 202)
TRAPHANDLER_NOEC(vector203, 203)
TRAPHANDLER_NOEC(vector204, 204)
TRAPHANDLER_NOEC(vector205, 205)
TRAPHANDLER_NOEC(vector206, 206)
TRAPHANDLER_NOEC(vector207, 207)
TRAPHANDLER_NOEC(vector208, 208)
TRAPHANDLER_NOEC(vector209, 209)
TRAPHANDLER_NOEC(vector210, 210)
TRAPHANDLER_NOEC(vector211, 211)
TRAPHANDLER_NOEC(vector212, 212)
TRAPHANDLER_NOEC(vector213, 213)
TRAPHANDLER_NOEC(vector214, 214)
TRAPHANDLER_NOEC(vector215, 215)
TRAPHANDLER_NOEC(vector216, 216)
TRAPHANDLER_NOEC(vector217, 217)
TRAPHANDLER_NOEC(vector218, 218)
TRAPHANDLER_NOEC(vector219, 219)
TRAPHANDLER_NOEC(vector220, 220)
TRAPHANDLER_NOEC(vector221, 221)
TRAPHANDLER_NOEC(vector222, 222)
TRAPHANDLER_NOEC(vector223, 223)
TRAPHANDLER_NOEC(vector224, 224)
TRAPHANDLER_NOEC(vector225, 225)
TRAPHANDLER_NOEC(vector226, 226)
TRAPHANDLER_NOEC(vector227, 227)
TRAPHANDLER_NOEC(vector228, 228)
TRAPHANDLER_NOEC(vector229, 229)
TRAPHANDLER_NOEC(vector230, 230)
TRAPHANDLER_NOEC(vector231, 231)
TRAPHANDLER_NOEC(vector232, 232)
TRAPHANDLER_NOEC(vector233, 233)
TRAPHANDLER_NOEC(vector234, 234)
TRAPHANDLER_NOEC(vector235, 235)
TRAPHANDLER_NOEC(vector236, 236)
TRAPHANDLER_NOEC(vector237, 237)
TRAPHANDLER_NOEC(vector238, 238)
TRAPHANDLER_NOEC(vector239, 239)
TRAPHANDLER_NOEC(vector240, 240)
TRAPHANDLER_NOEC(vector241, 241)
TRAPHANDLER_NOEC(vector242, 242)
TRAPHANDLER_NOEC(vector243, 243)
TRAPHANDLER_NOEC(vector244, 244)
TRAPHANDLER_NOEC(vector245, 245)
TRAPHANDLER_NOEC(vector246, 246)
TRAPHANDLER_NOEC(vector247, 247)
TRAPHANDLER_NOEC(vector248, 248)
TRAPHANDLER_NOEC(vector249, 249)
TRAPHANDLER_NOEC(vector250, 250)
TRAPHANDLER_NOEC(vector251, 251)
TRAPHANDLER_NOEC(vector252, 252)
TRAPHANDLER_NOEC(vector253, 253)
TRAPHANDLER_NOEC(vector254, 254)
TRAPHANDLER_NOEC(vector255, 255)

.data
.global vectors
vectors:
	.long vector0
	.long vector1
	.long vector2
	.long vector3
	.long vector4
	.long vector5
	.long vector6
	.long vector7
	.long vector8
	.long vector9
	.long vector10
	.long vector11
	.long vector12
	.long vector13
	.long vector14
	.long vector15
	.long vector16
	.long vector17
	.long vector18
	.long vector19
	.long vector20
	.long vector21
	.long vector22
	.long vector23
	.long vector24
	.long vector25
	.long vector26
	.long vector27
	.long vector28
	.long vector29
	.long vector30
	.long vector31
	.long vector32
	.long vector33
	.long vector34
	.long vector35
	.long vector36
	.long vector37
	.long vector38
	.long vector39
	.long vector40
	.long vector41
	.long vector42
	.long vector43
	.long vector44
	.long vector45
	.long vector46
	.long vector47
	.long vector48
	.long vector49
	.long vector50
	.long vector51
	.long vector52
	.long vector53
	.long vector54
	.long vector55
	.long vector56
	.long vector57
	.long vector58
	.long vector59
	.long vector60
	.long vector61
	.long vector62
	.long vector63
	.long vector64
	.long vector65
	.long vector66
	.long vector67
	.long vector68
	.long vector69
	.long vector70
	.long vector71
	.long vector72
	.long vector73
	.long vector74
	.long vector75
	.long vector76
	.long vector77
	.long vector78
	.long vector79
	.long vector80
	.long vector81
	.long vector82
	.long vector83
	.long vector84
	.long vector85
	.long vector86
	.long vector87
	.long vector88
	.long vector89
	.long vector90
	.long vector91
	.long vector92
	.long vector93
	.long vector94
	.long vector95
	.long vector96
	.long vector97
	.long vector98
	.long vector99
	.long vector100
	.long vector101
	.long vector102
	.long vector103
	.long vector104
	.long vector105
	.long vector106
	.long vector107
	.long vector108
	.long vector109
	.long vector110
	.long vector111
	.long vector112
	.long vector113
	.long vector114
	.long vector115
	.long vector116
	.long vector117
	.long vector118
	.long vector119
	.long vector120
	.long vector121
	.long vector122
	.long vector123
	.long vector124
	.long vector125
	.long vector126
	.long vector127
	.long vector128
	.long vector129
	.long vector130
	.long vector131
	.long vector132
	.long vector133
	.long vector134
	.long vector135
	.long vector136
	.long vector137
	.long vector138
	.long vector139
	.long vector140
	.long vector141
	.long vector142
	.long vector143
	.long vector144
	.long vector145
	.long vector146
	.long vector147
	.long vector148
	.long vector149
	.long vector150
	.long vector151
	.long vector152
	.long vector153
	.long vector154
	.long vector155
	.long vector156
	.long vector157
	.long vector158
	.long vector159
	.long vector160
	.long vector161
	.long vector162
	.long vector163
	.long vector164
	.long vector165
	.long vector166
	.long vector167
	.long vector168
	.long vector169
	.long vector170
	.long vector171
	.long vector172
	.long vector173
	.long vector174
	.long vector175
	.long vector176
	.long vector177
	.long vector178
	.long vector179
	.long vector180
	.long vector181
	.long vector182
	.long vector183
	.long vector184
	.long vector185
	.long vector186
	.long vector187
	.long vector188
	.long vector189
	.long vector190
	.long vector191
	.long vector192
	.long vector193
	.long vector194
	.long vector195
	.long vector196
	.long vector197
	.long vector198
	.long vector199
	.long vector200
	.long vector201
	.long vector202
	.long vector203
	.long vector204
	.long vector205
	.long vector206
	.long vector207
	.long vector208
	.long vector209
	.long vector210
	.long vector211
	.long vector212
	.long vector213
	.long vector214
	.long vector215
	.long vector216
	.long vector217
	.long vector218
	.long vector219
	.long vector220
	.long vector221
	.long vector222
	.long vector223
	.long vector224
	.long vector225
	.long vector226
	.long vector227
	.long vector228
	.long vector229
	.long vector230
	.long vector231
	.long vector232
	.long vector233
	.long vector234
	.long vector235
	.long vector236
	.long vector237
	.long vector238
	.long vector239
	.long vector240
	.long vector241
	.long vector242
	.long vector243
	.long vector244
	.long vector245
	.long vector246
	.long vector247
	.long vector248
	.long vector249
	.long vector250
	.long vector251
	.long vector252
	.long vector253
	.long vector254
	.long vector255

/*
 * Lab 3: Your code here for _alltraps
 */
.global _alltraps
_alltraps:
    # 1.Build trap frame
    # l means 32bit here
    pushl %ds 
    pushl %es

    pushal
    # 2.load GD_KD into %ds and %gs
    movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es

    # 3.push esp
    pushl %esp
    # call trap
    call trap