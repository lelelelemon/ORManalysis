#include<stdio.h>

int main(int argc, char** argv){
    
    char *input_file = argv[1], *output_file = argv[2];
    
    FILE* fin = fopen(input_file, "rb");
    FILE* fout = fopen(output_file, "wb");
    
    char a = fgetc(fin), b = fgetc(fin), c = fgetc(fin);
    while (a != EOF){
      if (a == '<' && b == '%'){
      	if (c == '='){
            a = fgetc(fin);
            b = fgetc(fin);
            while (a != '%' || b != '>'){
                fputc(a, fout);
                a = b;
                b = fgetc(fin);      
            }   
            fputc('\n', fout);
            a = fgetc(fin);
            b = fgetc(fin);
            c = fgetc(fin);
        } else {
        	a = c;
            b = fgetc(fin);
            while (a != '%' || b != '>'){
                fputc(a, fout);
                a = b;
                b = fgetc(fin);      
            }   
            fputc('\n', fout);
            a = fgetc(fin);
            b = fgetc(fin);
            c = fgetc(fin);
		}
      } else {
        a = b;
        b = c;
        c = fgetc(fin); 
      }
    }
    
    fclose(fin);
    fclose(fout);
}
