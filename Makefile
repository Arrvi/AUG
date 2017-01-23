ALL:    roman_calc
 
CC=g++

OBJ=	roman_calc_p.o roman_calc_s.o

roman_calc :	$(OBJ)
		$(CC) -o $@ $(OBJ) -lfl
		
roman_calc_p.c :    roman_calc.y
		bison -v -d -o roman_calc_p.c roman_calc.y

roman_calc_s.c :    roman_calc.l
		flex -I -oroman_calc_s.c roman_calc.l

clean:
		rm -f roman_calc_p.output roman_calc_p.h roman_calc_p.c roman_calc_s.c roman_calc
		rm -f *~
		rm -f *.o
		rm -f core
