for ((i = 0; i < 1000; i ++))
do 
	./tp2 -v pixelar -i asm lena.256x256.bmp
done

for ((i = 0; i < 1000; i ++))
do 
	./tp2 -v pixelar -i asm lena.512x512.bmp
done

for ((i = 0; i < 1000; i ++))
do 
	./tp2 -v pixelar -i asm lena.1024x1024.bmp
done
