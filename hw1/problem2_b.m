filename='sample3.raw';
fid=fopen(filename,'rb');
if (fid==-1)
  	error('can not open imput image filem press CTRL-C to exit \n');
  	pause
end
pixel=fread(fid,inf, 'uchar');
fclose(fid);
[Y X]=size(pixel);
Size=(Y*X);
N=sqrt(Size);
G=zeros(N,N);
G(1:Size)=pixel(1:Size);
G=permute(G, [2,1]);
S1 = G;
S2 = G;

threshold1 = 0.01;

for i=1:N
	for j=1:N
		temp = rand(1);
		if temp < threshold1
			S1(i, j) = 0;
		elseif temp > 1-threshold1
			S1(i,j) = 255;
		end
	end
end

threshold2 = 0.05;
for i=1:N
	for j=1:N
		temp = rand(1);
		if temp < threshold2
			S2(i, j) = 0;
		elseif temp > 1-threshold2
			S2(i,j) = 255;
		end
	end
end

%show result
imshow(S1, [0,255]);
imshow(S2, [0,255]);


fid2=fopen('S1.raw','wb');
Towrite=permute(S1, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);

fid3=fopen('S2.raw','wb');
Towrite=permute(S2, [2,1]); 
count=fwrite(fid3,Towrite, 'uchar');
fclose(fid3);