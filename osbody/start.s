.code32
.global	mystart

.section	.mysection

.extern	HariMain
.extern _data_begin
mystart:
	jmp	HariMain
	. = 12
	.long	_data_begin  /*stack top*/
	.long	_move_count  /*bytes to remove*/
	.long	_move_source - 0x280000  /*target address offset*/
