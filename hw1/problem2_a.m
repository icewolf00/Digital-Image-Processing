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
imshow(G, [0,255]);
noise1 = normrnd(0,8,[N,N]);
noise2 = normrnd(0,32,[N,N]);

G1 = G + noise1;
G1(G1<0) = 0;
G1(G1>255)=255;
G1=uint8(G1);
G2 = G + noise2;
G2(G2<0) = 0;
G2(G2>255)=255;
G2=uint8(G2);

%show result
imshow(G, [0,255]);
imshow(G1, [0,255]);
imshow(G2, [0,255]);

fid2=fopen('G1.raw','wb');
Towrite=permute(G1, [2,1]); 
count=fwrite(fid2,Towrite, 'uchar');
fclose(fid2);

fid3=fopen('G2.raw','wb');
Towrite=permute(G2, [2,1]); 
count=fwrite(fid3,Towrite, 'uchar');
fclose(fid3);